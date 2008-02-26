Return-Path: <linux-kernel-owner+w=401wt.eu-S1758323AbYBZAvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323AbYBZAvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbYBZAu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:50:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33359 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYBZAu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:50:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Winchester <kjwinchester@gmail.com>
Subject: Re: broken suspend to ram with velocity driver
Date: Tue, 26 Feb 2008 01:49:39 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       len.brown@intel.com, linux-pm@lists.linux-foundation.org
References: <20080224162309.3e67dd22.sfr@canb.auug.org.au> <20080225092628.GA493@elf.ucw.cz> <47C35C53.5010609@gmail.com>
In-Reply-To: <47C35C53.5010609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260149.40659.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 26 of February 2008, Kevin Winchester wrote:
> Pavel Machek wrote:
[--snip--]
> (Trimmed cc, since this is really just more of a PM discussion)
> 
> No modules here...
> 
> I recompiled the kernel without the velocity driver, and got behaviour more
> comparable to the other failures I've experienced in the past: 
> 
> Feb 25 20:18:46 alekhine kernel: [   73.564725] PM: Syncing filesystems ... done.
> Feb 25 20:19:14 alekhine kernel: [   73.580807] Freezing user space processes ... (elapsed 0.01 seconds) done.
> Feb 25 20:19:14 alekhine kernel: [   73.595524] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> Feb 25 20:19:14 alekhine kernel: [   73.595839] ACPI: Preparing to enter system sleep state S3
> Feb 25 20:19:14 alekhine kernel: [   73.697308] Suspending console(s)
> Feb 25 20:19:14 alekhine kernel: [   73.700386] sd 3:0:0:0: [sda] Synchronizing SCSI cache
> Feb 25 20:19:14 alekhine kernel: [   73.783185] sd 3:0:0:0: [sda] Stopping disk
> Feb 25 20:19:14 alekhine kernel: [   73.784302] ACPI: PCI interrupt for device 0000:00:11.5 disabled
> Feb 25 20:19:14 alekhine kernel: [   73.794585] ACPI: PCI interrupt for device 0000:00:10.4 disabled
> Feb 25 20:19:14 alekhine kernel: [   73.805370] ACPI: PCI interrupt for device 0000:00:10.3 disabled
> Feb 25 20:19:14 alekhine kernel: [   73.816170] ACPI: PCI interrupt for device 0000:00:10.2 disabled
> Feb 25 20:19:14 alekhine kernel: [   73.826999] ACPI: PCI interrupt for device 0000:00:10.1 disabled
> Feb 25 20:19:14 alekhine kernel: [   73.837833] ACPI: PCI interrupt for device 0000:00:10.0 disabled
> Feb 25 20:19:14 alekhine kernel: [   73.848668] ACPI: PCI interrupt for device 0000:00:0f.1 disabled
> Feb 25 20:19:14 alekhine kernel: [   73.859346] ACPI: PCI interrupt for device 0000:00:0f.0 disabled
> Feb 25 20:19:14 alekhine kernel: [   73.882878] Intel machine check architecture supported.
> Feb 25 20:19:14 alekhine kernel: [   73.882878] Intel machine check reporting enabled on CPU#0.
> Feb 25 20:19:14 alekhine kernel: [   73.884890] ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
> Feb 25 20:19:14 alekhine kernel: [   73.884892] ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
> Feb 25 20:19:14 alekhine kernel: [   73.890893] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 21
> Feb 25 20:19:14 alekhine kernel: [   73.890893] usb usb2: root hub lost power or was reset
> Feb 25 20:19:14 alekhine kernel: [   73.901724] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 21
> Feb 25 20:19:14 alekhine kernel: [   73.901724] usb usb3: root hub lost power or was reset
> Feb 25 20:19:14 alekhine kernel: [   73.912597] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 21
> Feb 25 20:19:14 alekhine kernel: [   73.912597] usb usb4: root hub lost power or was reset
> Feb 25 20:19:14 alekhine kernel: [   73.923472] ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 21
> Feb 25 20:19:14 alekhine kernel: [   73.923472] usb usb5: root hub lost power or was reset
> Feb 25 20:19:14 alekhine kernel: [   73.934336] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 21
> Feb 25 20:19:14 alekhine kernel: [   73.945209] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 22
> Feb 25 20:19:14 alekhine kernel: [   73.947465] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> Feb 25 20:19:14 alekhine kernel: [   73.947660] sd 3:0:0:0: [sda] Starting disk
> Feb 25 20:19:14 alekhine kernel: [   74.183122] ata3.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
> Feb 25 20:19:14 alekhine kernel: [   74.183122] ata3.01: ACPI cmd ef/03:42:00:00:00:b0 filtered out
> Feb 25 20:19:14 alekhine kernel: [   74.336028] ata3.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
> Feb 25 20:19:14 alekhine kernel: [   74.336028] ata3.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
> Feb 25 20:19:14 alekhine kernel: [   74.491252] ata3.00: configured for UDMA/33
> Feb 25 20:19:14 alekhine kernel: [   74.678330] ata3.01: configured for UDMA/33
> Feb 25 20:19:14 alekhine kernel: [   78.168897] ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
> Feb 25 20:19:14 alekhine kernel: [   78.168897] ata4.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
> Feb 25 20:19:14 alekhine kernel: [   78.172976] ata4.00: configured for UDMA/100
> Feb 25 20:19:14 alekhine kernel: [   78.177133] sd 3:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
> Feb 25 20:19:14 alekhine kernel: [   78.177133] sd 3:0:0:0: [sda] Write Protect is off
> Feb 25 20:19:14 alekhine kernel: [   78.177133] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Feb 25 20:19:14 alekhine kernel: [   78.720991] Restarting tasks ... <6>usb 2-1: USB disconnect, address 2
> Feb 25 20:19:14 alekhine kernel: [   78.766838] done.
> Feb 25 20:19:14 alekhine kernel: [   78.951998] usb 2-1: new low speed USB device using uhci_hcd and address 4
> Feb 25 20:19:14 alekhine kernel: [   79.114037] usb 2-1: configuration #1 chosen from 1 choice
> Feb 25 20:19:14 alekhine kernel: [   79.138166] input: Logitech USB Mouse as /devices/pci0000:00/0000:00:10.0/usb2/2-1/2-1:1.0/input/input5
> Feb 25 20:19:14 alekhine kernel: [   79.180828] input: USB HID v1.10 Mouse [Logitech USB Mouse] on usb-0000:00:10.0-1
> Feb 25 20:19:14 alekhine kernel: [   79.181059] usb 2-2: USB disconnect, address 3
> Feb 25 20:19:15 alekhine kernel: [   79.436567] usb 2-2: new low speed USB device using uhci_hcd and address 5
> Feb 25 20:19:15 alekhine kernel: [   79.606180] usb 2-2: configuration #1 chosen from 1 choice
> Feb 25 20:19:15 alekhine kernel: [   79.623893] input: Microsoft Microsoft<AE> Digital Media Pro Keyboard as /devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.0/input/input6
> Feb 25 20:19:15 alekhine kernel: [   79.663140] input: USB HID v1.11 Keyboard [Microsoft Microsoft<AE> Digital Media Pro Keyboard] on usb-0000:00:10.0-2
> Feb 25 20:19:15 alekhine kernel: [   79.697610] input: Microsoft Microsoft<AE> Digital Media Pro Keyboard as /devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.1/input/input7
> Feb 25 20:19:15 alekhine kernel: [   79.721948] input: USB HID v1.11 Device [Microsoft Microsoft<AE> Digital Media Pro Keyboard] on usb-0000:00:10.0-2
> 
> 
> I don't see anything there that would explain the failure, but the console
> never comes back, and I am forced to hard reset the box.  Anything else I can
> try?  

First, let's try to remove some noise.

Please test 2.6.25-rc3 with commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
"power_state: get rid of write-only variable in SATA" reverted and with the
patch from http://marc.info/?l=linux-acpi&m=120389632114090&w=2 applied.

Second, what exactly do you do to suspend to RAM?

Rafael
