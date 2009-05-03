Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZECWPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZECWPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 18:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZECWPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 18:15:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:38707 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbZECWPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 18:15:16 -0400
Subject: Re: Porting the ibm_newemac driver to use phylib (and other
 PHY/MAC questions)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, netdev <netdev@vger.kernel.org>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <f73f7ab80905022126ud3225enc6409bd39b5b2eb8@mail.gmail.com>
References: <f73f7ab80904171732n41832d0hc62978e57bbcc32e@mail.gmail.com>
	 <625fc13d0904200529l152b8d75g33c3f940de1b2920@mail.gmail.com>
	 <f73f7ab80904201710m57472291yf7ff86760977b8e8@mail.gmail.com>
	 <1240388476.17445.10.camel@pasglop>
	 <f73f7ab80904300804j1f847b70ha0fe3cda07249110@mail.gmail.com>
	 <1241126291.29501.41.camel@pasglop>
	 <f73f7ab80904301521x16effa0ar2d4756daceada122@mail.gmail.com>
	 <f73f7ab80905022126ud3225enc6409bd39b5b2eb8@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 04 May 2009 08:14:54 +1000
Message-Id: <1241388894.1781.18.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-03 at 00:26 -0400, Kyle Moffett wrote:

> Ok, I've dug through the docs on the 460EPx (the CPU I'm using), and
> I'd like some confirmation of the following:
> 
> *  The EMAC hardware itself internally has its own dedicated
> MDIO/MDClk lines, driven by the STACR register.

Yes, though not all EMACs cells have this wired to anything. For
example, the 405EP has 2 EMACs but only EMAC0 has MDIO, which is
used to control both PHYs. Later variants multiplex the MDIOs via
a programmable switch in the ZMII or RGMII though.

> *  On many/most cpus, there is only a single set of external
> MDIO/MDClk pins, driven either off the ZMII bridge or the RGMII
> bridge.

Yes, though on the very old ones, the ZMII bridge is effectively
invisible (if it exists at all) and only EMAC0 MDIO pins are wired out.

> *  Both bridge-types have their own internal register for switching
> the external MDIO/MDClk pins between the two sets of internal
> EMAC<=>bridge links.

Yes.

> *  Some SoCs have both an ZMII and an RGMII bridge, and the external
> MDIO/MDClk pins are only connected to one of the two bridges (How do I
> know which one?  Alternatively, do I just program both and hope for
> the best?).

That's been my approach so far :-)

> *  Some older SoCs simply export the MDIO/MDClk pins from one of their
> internal EMAC chips and don't bother with running it through the
> multiplexing bridge.

Yes.

> Are there any SoCs which actually export the MDIO/MDClk pins from
> both/all of their EMACs?

I don't know of such a beast.

Cheers,
Ben.

> Cheers,
> Kyle Moffett

