Return-Path: <linux-kernel-owner+w=401wt.eu-S932745AbYB0A3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbYB0A3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYB0A3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:29:05 -0500
Received: from simmts7-qfe0.srvr.bell.ca ([206.47.199.165]:38819 "EHLO
	simmts7-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754952AbYB0A3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:29:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAANY9xEecIsR1/2dsb2JhbAAIiiWIBpwP
Message-ID: <47C4AEB7.1030404@gmail.com>
Date: Tue, 26 Feb 2008 20:28:39 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080214)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       len.brown@intel.com, linux-pm@lists.linux-foundation.org
Subject: Re: broken suspend to ram with velocity driver
References: <20080224162309.3e67dd22.sfr@canb.auug.org.au> <47C1B52B.3080104@gmail.com> <200802242100.46474.rjw@sisk.pl> <47C1FF2E.4060600@gmail.com> <20080225092628.GA493@elf.ucw.cz> <47C35C53.5010609@gmail.com> <20080226214950.GD10280@elf.ucw.cz>
In-Reply-To: <20080226214950.GD10280@elf.ucw.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> I recompiled the kernel without the velocity driver, and got behaviour more comparable to the other failures I've experienced in the past:
>>
>> Feb 25 20:18:46 alekhine kernel: [   73.564725] PM: Syncing filesystems ... done.
>> Feb 25 20:19:14 alekhine kernel: [   73.580807] Freezing user space processes ... (elapsed 0.01 seconds) done.
>> Feb 25 20:19:14 alekhine kernel: [   73.595524] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
>> Feb 25 20:19:14 alekhine kernel: [   73.595839] ACPI: Preparing to enter system sleep state S3
>> Feb 25 20:19:14 alekhine kernel: [   73.697308] Suspending console(s)
>> Feb 25 20:19:14 alekhine kernel: [   73.700386] sd 3:0:0:0: [sda] Synchronizing SCSI cache
>> Feb 25 20:19:14 alekhine kernel: [   73.783185] sd 3:0:0:0: [sda] Stopping disk
>> Feb 25 20:19:14 alekhine kernel: [   73.784302] ACPI: PCI interrupt for device 0000:00:11.5 disabled
>> Feb 25 20:19:14 alekhine kernel: [   73.794585] ACPI: PCI interrupt for device 0000:00:10.4 disabled
>> Feb 25 20:19:14 alekhine kernel: [   73.805370] ACPI: PCI interrupt for device 0000:00:10.3 disabled
>> Feb 25 20:19:14 alekhine kernel: [   73.816170] ACPI: PCI interrupt for device 0000:00:10.2 disabled
>> Feb 25 20:19:14 alekhine kernel: [   73.826999] ACPI: PCI interrupt for device 0000:00:10.1 disabled
>> Feb 25 20:19:14 alekhine kernel: [   73.837833] ACPI: PCI interrupt for device 0000:00:10.0 disabled
>> Feb 25 20:19:14 alekhine kernel: [   73.848668] ACPI: PCI interrupt for device 0000:00:0f.1 disabled
>> Feb 25 20:19:14 alekhine kernel: [   73.859346] ACPI: PCI interrupt for device 0000:00:0f.0 disabled
>> Feb 25 20:19:14 alekhine kernel: [   73.882878] Intel machine check architecture supported.
>> Feb 25 20:19:14 alekhine kernel: [   73.882878] Intel machine check reporting enabled on CPU#0.
>> Feb 25 20:19:14 alekhine kernel: [   73.884890] ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
>> Feb 25 20:19:14 alekhine kernel: [   73.884892] ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
>> Feb 25 20:19:14 alekhine kernel: [   73.890893] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 21
>> Feb 25 20:19:14 alekhine kernel: [   73.890893] usb usb2: root hub lost power or was reset
>> Feb 25 20:19:14 alekhine kernel: [   73.901724] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 21
>> Feb 25 20:19:14 alekhine kernel: [   73.901724] usb usb3: root hub lost power or was reset
>> Feb 25 20:19:14 alekhine kernel: [   73.912597] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 21
>> Feb 25 20:19:14 alekhine kernel: [   73.912597] usb usb4: root hub lost power or was reset
>> Feb 25 20:19:14 alekhine kernel: [   73.923472] ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 21
>> Feb 25 20:19:14 alekhine kernel: [   73.923472] usb usb5: root hub lost power or was reset
>> Feb 25 20:19:14 alekhine kernel: [   73.934336] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 21
>> Feb 25 20:19:14 alekhine kernel: [   73.945209] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 22
>> Feb 25 20:19:14 alekhine kernel: [   73.947465] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
>> Feb 25 20:19:14 alekhine kernel: [   73.947660] sd 3:0:0:0: [sda] Starting disk
>> Feb 25 20:19:14 alekhine kernel: [   74.183122] ata3.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
>> Feb 25 20:19:14 alekhine kernel: [   74.183122] ata3.01: ACPI cmd ef/03:42:00:00:00:b0 filtered out
>> Feb 25 20:19:14 alekhine kernel: [   74.336028] ata3.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
>> Feb 25 20:19:14 alekhine kernel: [   74.336028] ata3.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
>> Feb 25 20:19:14 alekhine kernel: [   74.491252] ata3.00: configured for UDMA/33
>> Feb 25 20:19:14 alekhine kernel: [   74.678330] ata3.01: configured for UDMA/33
>> Feb 25 20:19:14 alekhine kernel: [   78.168897] ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
>> Feb 25 20:19:14 alekhine kernel: [   78.168897] ata4.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
>> Feb 25 20:19:14 alekhine kernel: [   78.172976] ata4.00: configured for UDMA/100
>> Feb 25 20:19:14 alekhine kernel: [   78.177133] sd 3:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
>> Feb 25 20:19:14 alekhine kernel: [   78.177133] sd 3:0:0:0: [sda] Write Protect is off
>> Feb 25 20:19:14 alekhine kernel: [   78.177133] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> Feb 25 20:19:14 alekhine kernel: [   78.720991] Restarting tasks ... <6>usb 2-1: USB disconnect, address 2
>> Feb 25 20:19:14 alekhine kernel: [   78.766838] done.
>> Feb 25 20:19:14 alekhine kernel: [   78.951998] usb 2-1: new low speed USB device using uhci_hcd and address 4
>> Feb 25 20:19:14 alekhine kernel: [   79.114037] usb 2-1: configuration #1 chosen from 1 choice
>> Feb 25 20:19:14 alekhine kernel: [   79.138166] input: Logitech USB Mouse as /devices/pci0000:00/0000:00:10.0/usb2/2-1/2-1:1.0/input/input5
>> Feb 25 20:19:14 alekhine kernel: [   79.180828] input: USB HID v1.10 Mouse [Logitech USB Mouse] on usb-0000:00:10.0-1
>> Feb 25 20:19:14 alekhine kernel: [   79.181059] usb 2-2: USB disconnect, address 3
>> Feb 25 20:19:15 alekhine kernel: [   79.436567] usb 2-2: new low speed USB device using uhci_hcd and address 5
>> Feb 25 20:19:15 alekhine kernel: [   79.606180] usb 2-2: configuration #1 chosen from 1 choice
>> Feb 25 20:19:15 alekhine kernel: [   79.623893] input: Microsoft Microsoft<AE> Digital Media Pro Keyboard as /devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.0/input/input6
>> Feb 25 20:19:15 alekhine kernel: [   79.663140] input: USB HID v1.11 Keyboard [Microsoft Microsoft<AE> Digital Media Pro Keyboard] on usb-0000:00:10.0-2
>> Feb 25 20:19:15 alekhine kernel: [   79.697610] input: Microsoft Microsoft<AE> Digital Media Pro Keyboard as /devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.1/input/input7
>> Feb 25 20:19:15 alekhine kernel: [   79.721948] input: USB HID v1.11 Device [Microsoft Microsoft<AE> Digital Media Pro Keyboard] on usb-0000:00:10.0-2
>>
>>
>> I don't see anything there that would explain the failure, but the console never comes back, and I am forced to hard reset the box.  Anything else I can try?
>>
> 
> So machine works but video is that? See suspend.sf.net...
> 

I haven't done too much looking at what the tool on that site does,
but I was under the impression that I should be able to do:

echo mem > /sys/power/state

and then bring the system back up and have it work.  If that is
not expected to work, then I won't bother trying it again.  My
goal in all this is to help test the kernel, and provide feedback
and testing for features that are expected to work. If this is
expected to work, then I would rather provide testing for patches
to the kernel that will make this work, rather than relying on
userspace tricks to get around a broken kernel (because frankly,
I couldn't care much less if STR works for me or not - I was just
testing it to be helpful).

Am I wrong about this?  Is the tool at suspend.sf.net supposed to
be required for STR to work with current linux kernels?

-- 
Kevin Winchester


