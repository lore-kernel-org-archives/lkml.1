Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbXFEMG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbXFEMG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 08:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbXFEMGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 08:06:20 -0400
Received: from mailgw4.ericsson.se ([193.180.251.62]:55080 "EHLO
	mailgw4.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbXFEMGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 08:06:19 -0400
X-AuditID: c1b4fb3e-b1a1dbb0000061ca-ea-466551b94380 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Tue, 5 Jun 2007 14:06:17 +0200
Message-ID: <A6D19A13FE030A409EC4362C172E091F016F51B3@eseldmw101.eemea.ericsson.se>
In-Reply-To: <20070604204418.GA4214@sortiz.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Thread-Index: Acem6TPIQpbL8BZWRvm9ckCk93fiKQAf/Gjg
References: <200706040634.01622.arvidjaar@mail.ru> <20070604204418.GA4214@sortiz.org>
From: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>
To: "Samuel Ortiz" <samuel@sortiz.org>, "Andrey Borzenkov" <arvidjaar@mail.ru>
Cc: <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       <ambx1@neo.rr.com>, <bjorn.helgaas@hp.com>
X-OriginalArrivalTime: 05 Jun 2007 12:06:17.0396 (UTC) FILETIME=[EBDE2F40:01C7A769]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey wrote:

> And here is what PnP tells us:
> {pts/1}% cat /sys/bus/pnp/devices/00:0a/options
> port 0x100-0x130, align 0xf, size 0x8, 16-bit address decoding irq 
> 3,4,5,6,7,10,11 High-Edge dma 1,2,3 16-bit compatible
> Dependent: 01 - Priority acceptable
>    port 0x3f8-0x3f8, align 0x0, size 0x8, 16-bit address decoding
> Dependent: 02 - Priority acceptable
>    port 0x2e8-0x2e8, align 0x0, size 0x8, 16-bit address decoding
> Dependent: 03 - Priority acceptable
>    port 0x2f8-0x2f8, align 0x0, size 0x8, 16-bit address decoding
> Dependent: 04 - Priority acceptable
>    port 0x3e8-0x3e8, align 0x0, size 0x8, 16-bit address decoding 
> {pts/1}% cat /sys/bus/pnp/devices/00:0a/resources
> state = disabled
> {pts/1}% sudo sh -c 'echo activate > 
/sys/bus/pnp/devices/00:0a/resources'
> {pts/1}% cat /sys/bus/pnp/devices/00:0a/resources
> state = active
> io 0x100-0x107
> io 0x2e8-0x2ef
> irq 5
> dma 1

These values *could* be correct (not all PnP BIOS:es can be trusted,
apparently). What we need to do really, is to get PnP working
properly with smsc-ircc2 and the pass these PnP settings through
as if they were parameters to the module, in the call to 
smsc_ircc_preconfigure_subsystems() in the smsc_ircc_init() call.
Then it will (probably) preconfigure the bridge for the
correct ports all the time.

The static table I've put in there just happens to be factory
defaults on a few machines, subject to change whenever some HW
is added/removed I believe.

Linus
