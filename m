Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbYE0TpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbYE0TpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 15:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbYE0To5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 15:44:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbYE0To4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 15:44:56 -0400
Date: Tue, 27 May 2008 12:43:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Cc: hancockr@shaw.ca, jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: SATA disk reports DRDY and goes to PIO0 eventually. noapic
 fixes it
Message-Id: <20080527124330.12e0d1f3.akpm@linux-foundation.org>
In-Reply-To: <5a4c581d0805191250r5d2ecd30x15e6bc6faafcb587@mail.gmail.com>
References: <fa.jF9ypkPPBXioKUr869XKpRZGAa4@ifi.uio.no>
	<4830E112.9010602@shaw.ca>
	<5a4c581d0805191250r5d2ecd30x15e6bc6faafcb587@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 21:50:47 +0200
"Alessandro Suardi" <alessandro.suardi@gmail.com> wrote:

> On Mon, May 19, 2008 at 4:08 AM, Robert Hancock <hancockr@shaw.ca> wrote:
> > Alessandro Suardi wrote:
> >>
> >> Since some time I noticed my nephew's Fedora 8 box would have
> >>  some noise in /var/log/messages with timeouts reported by the
> >>  SATA layer, with the drive in DRDY state. Flux is like this (from
> >>  the base Fedora 9 kernel installed today):
> >>
> >> May 17 17:18:39 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> >> SErr 0x0 action 0x2 frozen
> >> May 17 17:18:39 rospo kernel: ata4.00: cmd
> >> a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
> >> May 17 17:18:39 rospo kernel:          cdb 4a 01 00 00 10 00 00 00  08
> >> 00 00 00 00 00 00 00
> >> May 17 17:18:39 rospo kernel:          res
> >> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >> May 17 17:18:39 rospo kernel: ata4.00: status: { DRDY }
> >> May 17 17:18:39 rospo kernel: ata4: soft resetting link
> >> May 17 17:18:39 rospo kernel: ata4.00: configured for UDMA/33
> >> May 17 17:18:39 rospo kernel: ata4: EH complete
> >> May 17 17:18:40 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> >> usb interface 1:1
> >> May 17 17:18:40 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> >> usb interface 1:1
> >> May 17 17:18:46 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> >> SErr 0x0 action 0x2 frozen
> >> May 17 17:18:46 rospo kernel: ata4.00: cmd
> >> a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
> >> May 17 17:18:46 rospo kernel:          cdb 4a 01 00 00 10 00 00 00  08
> >> 00 00 00 00 00 00 00
> >> May 17 17:18:46 rospo kernel:          res
> >> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >> May 17 17:18:46 rospo kernel: ata4.00: status: { DRDY }
> >> May 17 17:18:46 rospo kernel: ata4: soft resetting link
> >> May 17 17:18:46 rospo kernel: ata4.00: configured for UDMA/33
> >> May 17 17:18:46 rospo kernel: ata4: EH complete
> >> May 17 17:18:53 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> >> SErr 0x0 action 0x2 frozen
> >> May 17 17:18:53 rospo kernel: ata4.00: cmd
> >> a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
> >> May 17 17:18:53 rospo kernel:          cdb 4a 01 00 00 10 00 00 00  08
> >> 00 00 00 00 00 00 00
> >> May 17 17:18:53 rospo kernel:          res
> >> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >> May 17 17:18:53 rospo kernel: ata4.00: status: { DRDY }
> >> May 17 17:18:53 rospo kernel: ata4: soft resetting link
> >> May 17 17:18:54 rospo kernel: ata4.00: configured for UDMA/33
> >> May 17 17:18:54 rospo kernel: ata4: EH complete
> >> May 17 17:19:01 rospo kernel: ata4.00: limiting speed to UDMA/25:PIO4
> >> May 17 17:19:01 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> >> SErr 0x0 action 0x2 frozen
> >> May 17 17:19:01 rospo kernel: ata4.00: cmd
> >> a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
> >> May 17 17:19:01 rospo kernel:          cdb 4a 01 00 00 10 00 00 00  08
> >> 00 00 00 00 00 00 00
> >> May 17 17:19:01 rospo kernel:          res
> >> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >> May 17 17:19:01 rospo kernel: ata4.00: status: { DRDY }
> >> May 17 17:19:01 rospo kernel: ata4: soft resetting link
> >> May 17 17:19:01 rospo kernel: ata4.00: configured for UDMA/25
> >> May 17 17:19:01 rospo kernel: ata4: EH complete
> >> May 17 17:19:01 rospo kernel: sr0: CDROM (ioctl) error, command: Get
> >> event status notification 4a 01 00 00 10 00 00 00 08 00
> >> May 17 17:19:01 rospo kernel: sr: Sense Key : Aborted Command
> >> [current] [descriptor]
> >> May 17 17:19:01 rospo kernel: sr: Add. Sense: No additional sense
> >> information
> >> May 17 17:19:06 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> >> usb interface 1:1
> >> May 17 17:19:06 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> >> usb interface 1:1
> >> May 17 17:19:11 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> >> SErr 0x0 action 0x2 frozen
> >> May 17 17:19:11 rospo kernel: ata4.00: cmd
> >> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> >> May 17 17:19:11 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
> >> 00 00 00 00 00 00 00
> >> May 17 17:19:11 rospo kernel:          res
> >> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >> May 17 17:19:11 rospo kernel: ata4.00: status: { DRDY }
> >> May 17 17:19:11 rospo kernel: ata4: soft resetting link
> >> May 17 17:19:12 rospo kernel: ata4.00: configured for UDMA/25
> >> May 17 17:19:12 rospo kernel: ata4: EH complete
> >> May 17 17:19:22 rospo kernel: ata4.00: limiting speed to PIO4
> >> May 17 17:19:22 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> >> SErr 0x0 action 0x2 frozen
> >> May 17 17:19:22 rospo kernel: ata4.00: cmd
> >> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> >> May 17 17:19:22 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
> >> 00 00 00 00 00 00 00
> >> May 17 17:19:22 rospo kernel:          res
> >> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >> May 17 17:19:22 rospo kernel: ata4.00: status: { DRDY }
> >> May 17 17:19:22 rospo kernel: ata4: soft resetting link
> >> May 17 17:19:22 rospo kernel: ata4.00: configured for PIO4
> >> May 17 17:19:22 rospo kernel: ata4: EH complete
> >> May 17 17:19:32 rospo kernel: ata4.00: limiting speed to PIO3
> >> May 17 17:19:32 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> >> SErr 0x0 action 0x2 frozen
> >> May 17 17:19:32 rospo kernel: ata4.00: cmd
> >> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> >> May 17 17:19:32 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
> >> 00 00 00 00 00 00 00
> >> May 17 17:19:32 rospo kernel:          res
> >> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >> May 17 17:19:32 rospo kernel: ata4.00: status: { DRDY }
> >> May 17 17:19:32 rospo kernel: ata4: soft resetting link
> >> May 17 17:19:33 rospo kernel: ata4.00: configured for PIO3
> >> May 17 17:19:33 rospo kernel: ata4: EH complete
> >> May 17 17:19:43 rospo kernel: ata4.00: limiting speed to PIO0
> >> May 17 17:19:43 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> >> SErr 0x0 action 0x2 frozen
> >> May 17 17:19:43 rospo kernel: ata4.00: cmd
> >> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> >> May 17 17:19:43 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
> >> 00 00 00 00 00 00 00
> >> May 17 17:19:43 rospo kernel:          res
> >> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >> May 17 17:19:43 rospo kernel: ata4.00: status: { DRDY }
> >> May 17 17:19:43 rospo kernel: ata4: soft resetting link
> >> May 17 17:19:43 rospo kernel: ata4.00: configured for PIO0
> >> May 17 17:19:43 rospo kernel: ata4: EH complete
> >> May 17 17:19:50 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> >> usb interface 1:1
> >> May 17 17:19:50 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> >> usb interface 1:1
> >> May 17 17:19:53 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> >> SErr 0x0 action 0x2 frozen
> >> May 17 17:19:53 rospo kernel: ata4.00: cmd
> >> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> >> May 17 17:19:53 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
> >> 00 00 00 00 00 00 00
> >> May 17 17:19:53 rospo kernel:          res
> >> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >> May 17 17:19:53 rospo kernel: ata4.00: status: { DRDY }
> >> May 17 17:19:53 rospo kernel: ata4: soft resetting link
> >> May 17 17:19:54 rospo kernel: ata4.00: configured for PIO0
> >> May 17 17:19:54 rospo kernel: ata4: EH complete
> >> May 17 17:20:01 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> >> usb interface 1:1
> >> May 17 17:20:04 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> >> SErr 0x0 action 0x2 frozen
> >> May 17 17:20:04 rospo kernel: ata4.00: cmd
> >> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> >> May 17 17:20:04 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
> >> 00 00 00 00 00 00 00
> >> May 17 17:20:04 rospo kernel:          res
> >> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >> May 17 17:20:04 rospo kernel: ata4.00: status: { DRDY }
> >> May 17 17:20:04 rospo kernel: ata4: soft resetting link
> >> May 17 17:20:04 rospo kernel: ata4.00: configured for PIO0
> >> May 17 17:20:04 rospo kernel: ata4: EH complete
> >> May 17 17:20:04 rospo kernel: sr 3:0:0:0: ioctl_internal_command
> >> return code = 8000002
> >> May 17 17:20:04 rospo kernel:    : Sense Key : Aborted Command
> >> [current] [descriptor]
> >> May 17 17:20:04 rospo kernel:    : Add. Sense: No additional sense
> >> information
> >> May 17 17:20:34 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> >> SErr 0x0 action 0x2 frozen
> >> May 17 17:20:34 rospo kernel: ata4.00: cmd
> >> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> >> May 17 17:20:34 rospo kernel:          cdb 00 00 00 00 00 00 00 00  00
> >> 00 00 00 00 00 00 00
> >> May 17 17:20:34 rospo kernel:          res
> >> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> >> May 17 17:20:34 rospo kernel: ata4.00: status: { DRDY }
> >> May 17 17:20:34 rospo kernel: ata4: soft resetting link
> >> May 17 17:20:35 rospo kernel: ata4.00: configured for PIO0
> >> May 17 17:20:35 rospo kernel: ata4: EH complete
> >>
> >> ..and on and on and on.
> >>
> >> Reading another report on lkml I turned to the ATA wiki @ kernel.org
> >>  today, as even the newest Fedora 9 update (2.6.25.3-18) was still
> >>  behaving the same way - pci=nomsi wasn't useful, acpi=off was
> >>  also not useful, noapic did instead get rid of the messages, even
> >>  under 'find /' (which would usually turn up the ATA resets in less
> >>  than 10 seconds).
> >>
> >> Is there anything more useful than simply booting noapic that
> >>  can be done here, or is that it ?
> >
> > Please post the full dmesg output from bootup. We can't see what controller
> > type this is, etc.
> 
> Robert,
> 
>   thanks for replying. Of course now that I look a bit more into
>   the messages file, I notice that ATA 4.00 is the DVD drive,
>   not the disk <blush>
> 
> Funny as there is nothing in the DVD drive... oh well.
> 
> /var/log/messages attached as a .gz file since I'm not sure it's
>  small enough to avoid being bounced by vger.
> 

It'd be nice to fix one of these noapic-fixes-stuff bugs one day :(

`grep -i apic' says:

May 17 15:41:17 rospo kernel: ACPI: APIC 3FFC0390, 0078 (r1 A M I  OEMAPIC  11000617 MSFT       97)
May 17 15:41:17 rospo kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
May 17 15:41:17 rospo kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
May 17 15:41:17 rospo kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
May 17 15:41:17 rospo kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
May 17 15:41:17 rospo kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
May 17 15:41:17 rospo kernel: IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
May 17 15:41:17 rospo kernel: ACPI: IOAPIC (id[0x03] address[0xfecc0000] gsi_base[24])
May 17 15:41:17 rospo kernel: IOAPIC[1]: apic_id 3, address 0xfecc0000, GSI 24-47
May 17 15:41:17 rospo kernel: Setting APIC routing to flat
May 17 15:41:17 rospo kernel: Using local APIC timer interrupts.
May 17 15:41:17 rospo kernel: Detected 16.625 MHz APIC timer.
May 17 15:41:17 rospo kernel: Booting processor 1/2 APIC 0x1
May 17 15:41:17 rospo kernel: ACPI: Using IOAPIC for interrupt routing
May 17 15:41:17 rospo kernel: pci 0000:00:11.0: Bypassing VIA 8237 APIC De-Assert Message

Is that disbling of local APICs expected?

May 17 15:41:17 rospo kernel: ACPI: PM-Timer IO Port: 0x808
May 17 15:41:17 rospo kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
May 17 15:41:17 rospo kernel: Processor #0 (Bootup-CPU)
May 17 15:41:17 rospo kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
May 17 15:41:17 rospo kernel: Processor #1
May 17 15:41:17 rospo kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
May 17 15:41:17 rospo kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
May 17 15:41:17 rospo kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
May 17 15:41:17 rospo kernel: IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
May 17 15:41:17 rospo kernel: ACPI: IOAPIC (id[0x03] address[0xfecc0000] gsi_base[24])
May 17 15:41:17 rospo kernel: IOAPIC[1]: apic_id 3, address 0xfecc0000, GSI 24-47
May 17 15:41:17 rospo kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
May 17 15:41:17 rospo kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
May 17 15:41:17 rospo kernel: Setting APIC routing to flat
May 17 15:41:17 rospo kernel: Using ACPI (MADT) for SMP configuration information

As the machine only has two CPUs I guess it's a BIOS wart.
