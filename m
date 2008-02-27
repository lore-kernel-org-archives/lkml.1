Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbYB0AtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbYB0AtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbYB0Asu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:48:50 -0500
Received: from simmts7-srv.bellnexxia.net ([206.47.199.165]:42860 "EHLO
	simmts7-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755431AbYB0Ast (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:48:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CALpBxEecIsR1/2dsb2JhbAAIgxmHDIgGnBU
Message-ID: <47C4B36E.40807@gmail.com>
Date: Tue, 26 Feb 2008 20:48:46 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080214)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       len.brown@intel.com, linux-pm@lists.linux-foundation.org
Subject: Re: broken suspend to ram with velocity driver
References: <20080224162309.3e67dd22.sfr@canb.auug.org.au> <20080225092628.GA493@elf.ucw.cz> <47C35C53.5010609@gmail.com> <200802260149.40659.rjw@sisk.pl>
In-Reply-To: <200802260149.40659.rjw@sisk.pl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, 26 of February 2008, Kevin Winchester wrote:
>> Pavel Machek wrote:
> [--snip--]
>> (Trimmed cc, since this is really just more of a PM discussion)
>>
>> No modules here...
>>
>> I recompiled the kernel without the velocity driver, and got behaviour more
>> comparable to the other failures I've experienced in the past: 
>>

<snip old trace>

>>
>>
>> I don't see anything there that would explain the failure, but the console
>> never comes back, and I am forced to hard reset the box.  Anything else I can
>> try?  
> 
> First, let's try to remove some noise.
> 
> Please test 2.6.25-rc3 with commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
> "power_state: get rid of write-only variable in SATA" reverted and with the
> patch from http://marc.info/?l=linux-acpi&m=120389632114090&w=2 applied.
> 
> Second, what exactly do you do to suspend to RAM?
> 

And here is the trace from the kernel with the revert and patch:

Feb 26 20:42:14 alekhine kernel: [  278.487844] PM: Syncing filesystems ... done.
Feb 26 20:42:40 alekhine kernel: [  278.523599] Freezing user space processes ... (elapsed 0.00 seconds) done.
Feb 26 20:42:40 alekhine kernel: [  278.525885] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
Feb 26 20:42:40 alekhine kernel: [  278.526196] ACPI: Preparing to enter system sleep state S3
Feb 26 20:42:40 alekhine kernel: [  278.627907] Suspending console(s)
Feb 26 20:42:40 alekhine kernel: [  278.631643] sd 3:0:0:0: [sda] Synchronizing SCSI cache
Feb 26 20:42:40 alekhine kernel: [  278.738062] sd 3:0:0:0: [sda] Stopping disk
Feb 26 20:42:40 alekhine kernel: [  278.739041] ACPI: PCI interrupt for device 0000:00:11.5 disabled
Feb 26 20:42:40 alekhine kernel: [  278.749597] ACPI: PCI interrupt for device 0000:00:10.4 disabled
Feb 26 20:42:40 alekhine kernel: [  278.760383] ACPI: PCI interrupt for device 0000:00:10.3 disabled
Feb 26 20:42:40 alekhine kernel: [  278.771183] ACPI: PCI interrupt for device 0000:00:10.2 disabled
Feb 26 20:42:40 alekhine kernel: [  278.782017] ACPI: PCI interrupt for device 0000:00:10.1 disabled
Feb 26 20:42:40 alekhine kernel: [  278.792851] ACPI: PCI interrupt for device 0000:00:10.0 disabled
Feb 26 20:42:40 alekhine kernel: [  278.803686] ACPI: PCI interrupt for device 0000:00:0f.1 disabled
Feb 26 20:42:40 alekhine kernel: [  278.814329] ACPI: PCI interrupt for device 0000:00:0f.0 disabled
Feb 26 20:42:40 alekhine kernel: [  278.837854] Intel machine check architecture supported.
Feb 26 20:42:40 alekhine kernel: [  278.837854] Intel machine check reporting enabled on CPU#0.
Feb 26 20:42:40 alekhine kernel: [  278.840865] ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
Feb 26 20:42:40 alekhine kernel: [  278.840866] ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
Feb 26 20:42:40 alekhine kernel: [  278.846866] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 21
Feb 26 20:42:40 alekhine kernel: [  278.846866] usb usb2: root hub lost power or was reset
Feb 26 20:42:40 alekhine kernel: [  278.857689] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 21
Feb 26 20:42:40 alekhine kernel: [  278.857689] usb usb3: root hub lost power or was reset
Feb 26 20:42:40 alekhine kernel: [  278.868560] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 21
Feb 26 20:42:40 alekhine kernel: [  278.868560] usb usb4: root hub lost power or was reset
Feb 26 20:42:40 alekhine kernel: [  278.879436] ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 21
Feb 26 20:42:40 alekhine kernel: [  278.879436] usb usb5: root hub lost power or was reset
Feb 26 20:42:40 alekhine kernel: [  278.890311] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 21
Feb 26 20:42:40 alekhine kernel: [  278.901173] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 22
Feb 26 20:42:40 alekhine kernel: [  278.903446] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
Feb 26 20:42:40 alekhine kernel: [  278.903642] sd 3:0:0:0: [sda] Starting disk
Feb 26 20:42:40 alekhine kernel: [  279.144623] ata3.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
Feb 26 20:42:40 alekhine kernel: [  279.144623] ata3.01: ACPI cmd ef/03:42:00:00:00:b0 filtered out
Feb 26 20:42:40 alekhine kernel: [  279.297860] ata3.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
Feb 26 20:42:40 alekhine kernel: [  279.297860] ata3.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
Feb 26 20:42:40 alekhine kernel: [  279.453232] ata3.00: configured for UDMA/33
Feb 26 20:42:40 alekhine kernel: [  279.640338] ata3.01: configured for UDMA/33
Feb 26 20:42:40 alekhine kernel: [  283.485517] ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
Feb 26 20:42:40 alekhine kernel: [  283.485517] ata4.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
Feb 26 20:42:40 alekhine kernel: [  283.487637] ata4.00: configured for UDMA/100
Feb 26 20:42:40 alekhine kernel: [  283.490010] sd 3:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
Feb 26 20:42:40 alekhine kernel: [  283.490030] sd 3:0:0:0: [sda] Write Protect is off
Feb 26 20:42:40 alekhine kernel: [  283.490137] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb 26 20:42:40 alekhine kernel: [  284.034036] Restarting tasks ... <6>usb 2-1: USB disconnect, address 2
Feb 26 20:42:40 alekhine kernel: [  284.061980] done.
Feb 26 20:42:40 alekhine kernel: [  284.265037] usb 2-1: new low speed USB device using uhci_hcd and address 4
Feb 26 20:42:40 alekhine kernel: [  284.428562] usb 2-1: configuration #1 chosen from 1 choice
Feb 26 20:42:40 alekhine kernel: [  284.452701] input: Logitech USB Mouse as /devices/pci0000:00/0000:00:10.0/usb2/2-1/2-1:1.0/input/input5
Feb 26 20:42:40 alekhine kernel: [  284.495532] input: USB HID v1.10 Mouse [Logitech USB Mouse] on usb-0000:00:10.0-1
Feb 26 20:42:40 alekhine kernel: [  284.495724] usb 2-2: USB disconnect, address 3
Feb 26 20:42:40 alekhine kernel: [  284.751242] usb 2-2: new low speed USB device using uhci_hcd and address 5
Feb 26 20:42:41 alekhine kernel: [  284.920833] usb 2-2: configuration #1 chosen from 1 choice
Feb 26 20:42:41 alekhine kernel: [  284.938005] input: Microsoft Microsoft<AE> Digital Media Pro Keyboard as /devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.0/input/input6
Feb 26 20:42:41 alekhine kernel: [  284.977818] input: USB HID v1.11 Keyboard [Microsoft Microsoft<AE> Digital Media Pro Keyboard] on usb-0000:00:10.0-2
Feb 26 20:42:41 alekhine kernel: [  285.012253] input: Microsoft Microsoft<AE> Digital Media Pro Keyboard as /devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.1/input/input7
Feb 26 20:42:41 alekhine kernel: [  285.033838] input: USB HID v1.11 Device [Microsoft Microsoft<AE> Digital Media Pro Keyboard] on usb-0000:00:10.0-2

It looks basically identical to me, but I haven't diff'ed them or
anything.  Do you have any other options, or am I out of luck for\
the moment?

Thanks for the help,
-- 
Kevin Winchester
