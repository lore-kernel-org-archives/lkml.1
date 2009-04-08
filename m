Return-Path: <linux-kernel-owner+w=401wt.eu-S1763551AbZDHHkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763551AbZDHHkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZDHHkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:40:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53915 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbZDHHkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:40:23 -0400
Date: Wed, 8 Apr 2009 09:40:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-rc1: invalid opcode with call trace
Message-ID: <20090408074021.GU5178@kernel.dk>
References: <49DC367A.90603@gawab.com> <20090408063240.GQ5178@kernel.dk> <20090408064733.GA16984@elte.hu> <19f34abd0904080027h5b7d2acfp7fdf774e67917175@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19f34abd0904080027h5b7d2acfp7fdf774e67917175@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08 2009, Vegard Nossum wrote:
> 2009/4/8 Ingo Molnar <mingo@elte.hu>:
> >
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> >
> >> On Tue, Apr 07 2009, Justin Madru wrote:
> >> > Hello,
> >> >
> >> > Testing 2.6.30-rc1,
> >> > While booting I get the following call trace about an invalid opcode.
> >> >
> >> > ACPI: SSDT 3f6d4134 00244 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
> >> > ACPI: SSDT 3f6d3ee9 001C6 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
> >> > ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> >> > processor ACPI_CPU:00: registered as cooling_device0
> >> > ACPI: Processor [CPU0] (supports 8 throttling states)
> >> > ACPI: SSDT 3f6d4378 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
> >> > ACPI: SSDT 3f6d40af 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
> >> > ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
> >> > processor ACPI_CPU:01: registered as cooling_device1
> >> > ACPI: Processor [CPU1] (supports 8 throttling states)
> >> > input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
> >> > ACPI: Lid Switch [LID]
> >> > input: Power Button (CM) as
> >> > /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
> >> > ACPI: Power Button (CM) [PBTN]
> >> > ACPI: AC Adapter [AC] (on-line)
> >> > input: Sleep Button (CM) as
> >> > /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
> >> > ACPI: Sleep Button (CM) [SBTN]
> >> > ACPI: Battery Slot [BAT0] (battery present)
> >> > invalid opcode: 0000 [#1] PREEMPT SMP
> >> > last sysfs file: /sys/devices/virtual/vtconsole/vtcon0/uevent
> >> > Modules linked in: snd_pcm battery ac button processor intel_agp
> >> > snd_page_alloc reiserfs crc32 sr_mod cdrom sg firewire_ohci
> >> > firewire_core crc_itu_t ata_piix ehci_hcd uhci_hcd usbcore thermal fan
> >> >
> >> > Pid: 1760, comm: async/0 Not tainted (2.6.30-rc1-git #1) MM061
> >> >                EIP: 0060:[<f80fb02c>] EFLAGS: 00010286 CPU: 1
> >> > EIP is at 0xf80fb02c
> >> > EAX: 00000000 EBX: 00000216 ECX: 00000000 EDX: 00000000
> >> > ESI: f68fb320 EDI: 00000001 EBP: f7117f88 ESP: f7117f88
> >> > DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> >> > Process async/0 (pid: 1760, ti=f7117000 task=f6935390 task.ti=f7117000)
> >> > Stack:
> >> > f7117fd0 c015e612 f7117fa8 c0129cf9 f7073bb0 00000000 f693560c f6935390
> >> > 00000286 f7117fd0 00000000 f6935390 c012fb20 f704efbc c04f22dc 00000000
> >> > c015e540 00000000 f7117fe0 c015558c c0155550 00000000 00000000 c0103f5f
> >> > Call Trace:
> >> > [<c015e612>] ? async_thread+0xd2/0x240
> >> > [<c0129cf9>] ? schedule_tail+0xd9/0x110
> >> > [<c012fb20>] ? default_wake_function+0x0/0x10
> >> > [<c015e540>] ? async_thread+0x0/0x240
> >> > [<c015558c>] ? kthread+0x3c/0x70
> >> > [<c0155550>] ? kthread+0x0/0x70
> >> > [<c0103f5f>] ? kernel_thread_helper+0x7/0x18
> >> > Code: 00 00 89 5d f4 8d 9e 88 00 00 00 89 7d fc 89 4d e8 e8 fc ff ff ff
> >> > 8b be 98 00 00 00 39 df 74 57 89 f8 e8 fc ff ff ff 89 d8 e8 fc <ff> ff
> >> > ff 8b 4d e8 89 f2 8b 45 ec c7 04 24 01 00 00 00 e8 3d c9
> >> > EIP: [<f80fb02c>] 0xf80fb02c SS:ESP 0068:f7117f88
> >> > ---[ end trace fefef3dd1f6b4bcf ]---
> >> > sdhci: Secure Digital Host Controller Interface driver
> >> > sdhci: Copyright(c) Pierre Ossman
> >>
> >> My x60 gets the exact same oops, 100% repeatable. I then added the
> >> initcall_debug boot option to get a closer look at what was
> >> crapping out, but then it works fine. So it smells like a race
> >> somewhere. Didn't look further.
> >
> > I too have an async hang/crash, on an old-style SCSI (aic7xxx) box -
> > hang log attached below.
> >
> > No other -tip testbox is showing async related crashes, so i think
> > it's hardware (and driver) specific, not an async core problem.
> >
> > ( but then again, we never expected the async bootup code to be
> >  problematic in the core, most of the complications were at the
> >  driver level. )
> >
> > Note that it's not a crash but a boot hang - so it might be two
> > separate regressions.
> >
> > ( Full bootlog attached below as well - i'm sending the config as a
> >  reply as this mail is close to lkml size limits already. )
> 
> Would you please try this patch? It has the same symptoms as a few
> other reports, only that this is 32-bit (and that makes it a bit
> different).
> 
> http://marc.info/?l=linux-kernel&m=123909566829773&w=2
> 
> I think Len Brown has applied it to the ACPI tree already.

Works for me!

-- 
Jens Axboe

