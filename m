Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbXLUMN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbXLUMN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbXLUMNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:13:17 -0500
Received: from puffyports.org ([213.61.174.206]:39754 "EHLO puffyports.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657AbXLUMNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:13:16 -0500
X-Greylist: delayed 1363 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2007 07:13:15 EST
Subject: drive appears confused; hda lost interrupt; IRQ169: nobody cared
From: Michael Schmitt <mschmitt@unixkiste.org>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 12:50:20 +0100
Message-Id: <1198237821.4577.63.camel@elara.tcw.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I have some major or at least annoying issues with a Asus P4P800-SE
mainboard. It has 2 pATA connectors (so 4 drives) and 2 sATA connectors.
In addition I plugged in another sATA controller too (to isolate
problems with the mainboard chipset more easily) with two sATA
connectors. All together 4 pATA drives and 4 sATA drives possible.
I changed the mainboard of this computer recently to this P4P800-SE from
a rubish oem SIS chipset board and I had the problems right away,
starting with kernel 2.6.18 but problems persist even with 2.6.23
(Debian kernels).

In the BIOS of the mainboard I can set the IDE operations to be
"native" (it says enhanced) or "not native" (it says compatible there)
which means in compatible mode I can choose between just pATA or two
pATA drives and 2 sATA drives, with enhanced I could use all.

Now the problems, I try to collect every information I am able to, but
please don't hesitate to ask if I missed something!

2.6.18; no kernel cmdline additions >
	irq 169: nobody cared (try booting with the "irqpoll" option)
Some data containing a stack trace (just made a photo) and after that
	Disabling IRQ 169
	hda: dma_timer_expiry: dma status == 0x24
	hda: DMA interrupt recovery
	hda: lost interrupt
	hda: dma_timer_expiry: dma status == 0x24
	[...]
I did hit the reset button at this stage, now booting 2.6.18 with
"irqpoll" option. The system boots up, apart from some errors in the log
(and again the hint to use irqpoll even if I did it already) I can use
the system nevertheless. See the file kern.log-2.6.18-irqpoll. hdc drive
appears confused, IRQ 169: nobody cared... but I can log in, read from
all disks / dvd drive, even burn a cd and I don't notice _any_ serious
problem during operation... just the log files make my head ache. There
is only one thing that does not work anymore, which maks be believe it
may be a hal / dbus issue. Normally I think gnome should ask me when I
insert a blank cd if I want to burn a cd. During my tests it does it not
anymore but burning itself works flawlessly. I just get every once in a
while this:
Dec 21 11:17:48 elara kernel: hdc: cdrom_pc_intr: The drive appears
confused (ireason = 0x01). Trying to recover by ending request.
Dec 21 11:23:28 elara kernel: hdc: cdrom_pc_intr: The drive appears
confused (ireason = 0x01). Trying to recover by ending request.
Dec 21 11:31:22 elara kernel: hdc: cdrom_pc_intr: The drive appears
confused (ireason = 0x01). Trying to recover by ending request.
Dec 21 11:33:26 elara kernel: hdc: cdrom_pc_intr: The drive appears
confused (ireason = 0x01). Trying to recover by ending request.
Dec 21 11:44:02 elara kernel: hdc: cdrom_pc_intr: The drive appears
confused (ireason = 0x01). Trying to recover by ending request.

On IRQ 169 seems to be the internal IDE controller but as said all
drives work, despite

mschmitt@elara:~$ dmesg |grep 169
irq 169: nobody cared (try booting with the "irqpoll" option)
Disabling IRQ #169
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 169
uhci_hcd 0000:00:1d.2: irq 169, io base 0x0000ef20
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 169
ata3: SATA max UDMA/133 cmd 0xEFA0 ctl 0xEF8E bmdma 0xEF60 irq 169
ata4: SATA max UDMA/133 cmd 0xEF80 ctl 0xEF8A bmdma 0xEF68 irq 169
mschmitt@elara:~$ 

As I watch /proc/interrupts I see that IRQ 169 does not change, as there
would be no interrupt requests and just to make it clear

169:     200116   IO-APIC-level  ide0, ide1, uhci_hcd:usb3, libata

rather busy interrupt but no real problems with ide0 (hda), ide1 (hdc)
and libata (in this case sdc, sda and sdb are on the PCI sATA controller
which is on IRQ 209). With "busy" I mean many devices on that IRQ but
the value "200116" stays forever.
With 2.6.23 it is more or less the same if you want I can provide you
with the same information for this kernel nevertheless. As a side note,
if I plug in another DVD drive (due to cableing issues hdc would become
hdd and hdc would be the new drive) I get those "drive appears confused"
messages for both optical drives but reading / burning no problem there
too, despite that the performance with slave / master sucks when both
drives are used at the same time.
So, my main concern is that there may be some sort of data corruption
even if I don't see them right now but as the messages seem to be very
serious... dunno. Any thoughts?

kind regards
Michael Schmitt

