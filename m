Return-Path: <linux-kernel-owner+w=401wt.eu-S2993100AbXDSBef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993100AbXDSBef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 21:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993099AbXDSBef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 21:34:35 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:61352 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993078AbXDSBee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 21:34:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17958.50974.973764.356099@smtp.charter.net>
Date: Wed, 18 Apr 2007 21:34:22 -0400
From: "John Stoffel" <john@stoffel.org>
To: "John Stoffel" <john@stoffel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc6-mm1 ATA HPT37x regression
In-Reply-To: <17957.8073.587946.969040@smtp.charter.net>
References: <17956.12963.163961.762444@smtp.charter.net>
	<4624D4C3.9010109@ru.mvista.com>
	<17956.63043.521397.597430@smtp.charter.net>
	<4624FE88.2010908@ru.mvista.com>
	<20070417181340.7de99868@the-village.bc.nu>
	<17957.8073.587946.969040@smtp.charter.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "John" == John Stoffel <john@stoffel.org> writes:

>>> > Ok, so do I need to do anything special with the next -mm release and
>>> > the next version?
>>> 
>>> Well, let Alan decide that (2Alan: and I said that HPT code is bogus :-).

Alan> Try drivers/ide/pci/hpt366 - if that works grab a dmesg and let
Alan> me know.  It means that Sergei's DPLL sync code seems to work
Alan> better than the vendor code and its time to swap it over.

John> Ok, I'll give that a whirl under 2.6.21-rc7 tonight.  I'll build them
John> in modular so I can switch around more easily.  I hope.  :]

Ok, here's the dmesg output using the hpt366 old IDE driver,
2.6.21-rc7, SMP: 

[  160.926355] HPT302: IDE controller at PCI slot 0000:03:06.0
[  160.928030] ACPI: PCI Interrupt 0000:03:06.0[A] -> GSI 18 (level, low) -> IRQ
 18
[  160.931212] HPT302: chipset revision 1
[  160.932801] HPT302: DPLL base: 66 MHz, f_CNT: 100, assuming 33 MHz PCI
[  160.941157] HPT302: using 66 MHz DPLL clock
[  160.942646] HPT302: 100% native mode on irq 18
[  160.943918]     ide2: BM-DMA at 0xe800-0xe807, BIOS settings: hde:DMA, hdf:pi
o
[  160.946636]     ide3: BM-DMA at 0xe808-0xe80f, BIOS settings: hdg:DMA, hdh:pi
o
[  160.949439] Probing IDE interface ide2...
[  161.213560] hde: WDC WD1200JB-00CRA1, ATA DISK drive
[  161.828020] ide2 at 0xecf8-0xecff,0xecf2 on irq 18
[  161.829616] Probing IDE interface ide3...
[  162.094086] hdg: WDC WD1200JB-00EVA0, ATA DISK drive
[  162.709002] ide3 at 0xece0-0xece7,0xecda on irq 18


Which looks ok to me I guess.  It found my MD disks on there and
assmebled them, eventually.  *grin*

I'll reboot and send out the corresponding ATA HPT37x driver dmesg...

John

