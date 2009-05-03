Return-Path: <linux-kernel-owner+w=401wt.eu-S1751618AbZECE0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbZECE0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 00:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbZECE0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 00:26:08 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:56011 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZECE0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 00:26:06 -0400
MIME-Version: 1.0
In-Reply-To: <f73f7ab80904301521x16effa0ar2d4756daceada122@mail.gmail.com>
References: <f73f7ab80904171732n41832d0hc62978e57bbcc32e@mail.gmail.com>
	 <625fc13d0904200529l152b8d75g33c3f940de1b2920@mail.gmail.com>
	 <f73f7ab80904201710m57472291yf7ff86760977b8e8@mail.gmail.com>
	 <1240388476.17445.10.camel@pasglop>
	 <f73f7ab80904300804j1f847b70ha0fe3cda07249110@mail.gmail.com>
	 <1241126291.29501.41.camel@pasglop>
	 <f73f7ab80904301521x16effa0ar2d4756daceada122@mail.gmail.com>
Date: Sun, 3 May 2009 00:26:05 -0400
Message-ID: <f73f7ab80905022126ud3225enc6409bd39b5b2eb8@mail.gmail.com>
Subject: Re: Porting the ibm_newemac driver to use phylib (and other PHY/MAC 
	questions)
From: Kyle Moffett <kyle@moffetthome.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, netdev <netdev@vger.kernel.org>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 6:21 PM, Kyle Moffett <kyle@moffetthome.net> wrote:
>>> I'm also curious about the intent of the "mdio_instance" pointer (IE:
>>> the "mdio-device" property).  Is that used when all the PHY devices
>>> are attached to the MDIO bus of only one of the (multiple) emac
>>> devices?
>>
>> It's common especially on older SoCs using EMAC to have only one of
>> the EMAC instance with an MDIO bus for configuring the PHYs. This is one
>> of the reasons why I have the mutex in the low level MDIO access
>> routines since 2 EMACs can try to talk to the same MDIO, and this is the
>> problem I had with phylib back then which was doing everything in atomic
>> contexts.
>
> Ok, good, the current mdiobus code seems to make handling this a good
> deal easier.

Ok, I've dug through the docs on the 460EPx (the CPU I'm using), and
I'd like some confirmation of the following:

*  The EMAC hardware itself internally has its own dedicated
MDIO/MDClk lines, driven by the STACR register.

*  On many/most cpus, there is only a single set of external
MDIO/MDClk pins, driven either off the ZMII bridge or the RGMII
bridge.

*  Both bridge-types have their own internal register for switching
the external MDIO/MDClk pins between the two sets of internal
EMAC<=>bridge links.

*  Some SoCs have both an ZMII and an RGMII bridge, and the external
MDIO/MDClk pins are only connected to one of the two bridges (How do I
know which one?  Alternatively, do I just program both and hope for
the best?).

*  Some older SoCs simply export the MDIO/MDClk pins from one of their
internal EMAC chips and don't bother with running it through the
multiplexing bridge.

Are there any SoCs which actually export the MDIO/MDClk pins from
both/all of their EMACs?

Cheers,
Kyle Moffett
