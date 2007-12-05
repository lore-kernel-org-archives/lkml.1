Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbXLEPE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbXLEPE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbXLEPEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:04:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:49027 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750898AbXLEPEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:04:50 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18+DBFHeow+GK+PgWZF4KmkaP93OxjP/a1dP1E67C
	xYTPKK04ll6lJ9
Date: Wed, 5 Dec 2007 16:05:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Pavel Machek <pavel@ucw.cz>, Robert Hancock <hancockr@shaw.ca>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Timers SMP] can this machine be helped?
In-Reply-To: <4756B6EC.1000103@shaw.ca>
Message-ID: <Pine.LNX.4.64.0712051551150.29328@axis700.grange>
References: <fa./nzsMVb44+6c2x42WGfe04SPDrY@ifi.uio.no> <47560A98.9080700@shaw.ca>
 <Pine.LNX.4.64.0712050746500.29290@axis700.grange> <4756B6EC.1000103@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007, Pavel Machek wrote:

> On Mon 2007-12-03 22:45:06, Guennadi Liakhovetski wrote:
> > On Sun, 2 Dec 2007, Pavel Machek wrote:
> > 
> > > > I compiled a .24-ish kernel for it with CONFIG_NO_HZ and 
> > > > CONFIG_HIGH_RES_TIMERS. To get the system boot at least sometimes I have 
> > > > to specify nohz=off. Then I get
> > > 
> > > Try highres=off, too... Hehe, and even idle=poll might help.
> > 
> > Ok, for now I've compiled a kernel with all "advanced" features off like 
> > hrt, nohz. Will see how it behaves. But thanks for the hints.
> 
> Let us know...

Ok, it cold-booted (after a power-off, which is usually the most 
difficult case for this machine) once fine. On another boot it was 
veeeeery slow. I have a dmesg from that boot, here're some of the first 
differences with a subsequent normal boot:

-apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
+apm: BIOS version 1.2 Flags 0x0b (Driver version 1.16ac)

...

 Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
+serial 00:08: activated
 00:08: ttyS0 at I/O 0x3e8 (irq = 4) is a 16550A
+serial 00:09: activated
 00:09: ttyS1 at I/O 0x2e8 (irq = 3) is a NS16550A

...

 ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
 PIIX4: IDE controller (0x8086:0x7111 rev 0x01) at  PCI slot 0000:00:14.1
 PIIX4: not 100% native mode: will probe irqs later
-PIIX4: IDE port disabled
+    ide0: BM-DMA at 0x58c0-0x58c7, BIOS settings: hda:pio, hdb:pio
     ide1: BM-DMA at 0x58c8-0x58cf, BIOS settings: hdc:pio, hdd:pio
+Probing IDE interface ide0...
 Probing IDE interface ide1...
 Probing IDE interface ide0...
 Probing IDE interface ide1...

"+" is the slow boot. A reboot helped. And I've got two soft lockups now 
on that new boot each for 13s (hm, it's always 13s...:-() and this time I 
didn't specify "clocksource=tsc" as the last time.

On Wed, 5 Dec 2007, Robert Hancock wrote:

> On a machine that old, you shouldn't need ACPI to detect both CPUs, it should
> be able to use MPS..

Don't know the details, but remember it didn't work without ACPI. The only 
solution was acpi=noirq.

Thanks
Guennadi
---
Guennadi Liakhovetski
