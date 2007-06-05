Return-Path: <linux-kernel-owner+w=401wt.eu-S1763806AbXFEH5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763806AbXFEH5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXFEH5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:57:06 -0400
Received: from 25.mail-out.ovh.net ([213.186.37.103]:60887 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756796AbXFEH5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:57:05 -0400
Date: 5 Jun 2007 07:57:11 -0000
To: linus.walleij@ericsson.com, arvidjaar@mail.ru
Subject: RE: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
X-IlohaMail-Blah: samuel@sortiz.org
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: OVH (On: ssl0.ovh.net)
Message-ID: <7VXmfiOJ.1181030230.9946640.samuel@sortiz.org>
In-Reply-To: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se>
From: "Samuel Ortiz" <samuel@sortiz.org>
Bounce-To: "Samuel Ortiz" <samuel@sortiz.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "ambx1@neo.rr.com" <ambx1@neo.rr.com>,
       "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

On 6/5/2007, "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>
wrote:

>> > Ok, FIR and SIR are definitey mixed up. So, now could you  please
>try 
>> > Bjorn's patch ?
>> 
>> does not work.
>
>It looks like the purpose of the patch is to provide more printouts
>not to fix the problem, please mail your dmesg post-patch.

Here it is (from an answer from Andrey to Bjorn, you were not included
yet):

Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA chip,
pre-configuring device.
Activated ALi 1533 ISA bridge port 0x02e8.
Activated ALi 1533 ISA bridge port 0x02f8.
pnp: Device 00:0a activated.
smsc_ircc_pnp_probe(): fir 0x100 sir 0x2e8 dma 1 irq 5
High: 0x11, Chip 0x0
smsc_ircc_present(), addr 0x0100 - no device found!
pnp: Device 00:0a disabled.

Andrey, in addition to Bjorn's patch, could you also apply this one and
try again:

diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
index 31c6233..800562a 100644
--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -2463,7 +2463,7 @@ static struct smsc_ircc_subsystem_configuration
subsystem_
                .subvendor = 0x1179,
                .subdevice = 0xffff, /* 0xffff is "any" */
                .sir_io = 0x02e8,
-               .fir_io = 0x02f8,
+               .fir_io = 0x100,
                .fir_irq = 0x07,
                .fir_dma = 0x03,
                .cfg_base = 0x002e,
