Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYE0Jff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYE0Jff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 05:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbYE0JfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 05:35:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:42324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915AbYE0JfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 05:35:20 -0400
Subject: Re: cpufreq limits avilable frequencies to 800MHz on git kernel
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, gnorton@novell.com,
       miguel@novell.com, linux-acpi <linux-acpi@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <200805261815.40601.arekm@maven.pl>
References: <200805231944.57320.arekm@maven.pl>
	 <200805260907.05561.arekm@maven.pl>
	 <1211801853.29901.174.camel@queen.suse.de>
	 <200805261815.40601.arekm@maven.pl>
Content-Type: text/plain; charset=UTF-8
Organization: Novell/SUSE
Date: Tue, 27 May 2008 11:35:17 +0200
Message-Id: <1211880917.29901.309.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-26 at 18:15 +0200, Arkadiusz Miskiewicz wrote:
> On Monday 26 May 2008, Thomas Renninger wrote:
> > On Mon, 2008-05-26 at 09:07 +0200, Arkadiusz Miskiewicz wrote:
> > > On Sunday 25 May 2008, Thomas Renninger wrote:
> > > > On Sun, 2008-05-25 at 11:36 +0200, Arkadiusz Miskiewicz wrote:
> > > > > On Saturday 24 May 2008, Andrew Morton wrote:
> > > > > > On Fri, 23 May 2008 19:44:57 +0200 Arkadiusz Miskiewicz
> > > > > > <arekm@maven.pl>
> > > > >
> > > > > wrote:
> > > > > > > thinkpad z60m, Intel(R) Pentium(R) M processor 2.00GHz. kernel
> > > > > > > from git from 1-2 days ago.
> > > > > > >
> > > > > > > Unfortunately it seems that suspend to ram/resume causes
> > > > > > > frequency to be limited to 800MHz only. I can't set it to 2GHz
> > > > > > > again :-/
> > > > > > >
> > > > > > > scaling_max_freq is then 800000 and cannot be changed.
> > > > > > >
> > > > > > > reboot and the problem disappears until new suspend/resume cycle.
> > > > > > >
> > > > > > > cpufreq stuff is driven by acpi-cpufreq
> > > > > > >
> > > > > > > $ cpufreq-info
> > > > > > > cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
> > > > > > > Report errors and bugs to linux@brodo.de, please.
> > > > > > > analyzing CPU 0:
> > > > > > >   driver: acpi-cpufreq
> > > > > > >   CPUs which need to switch frequency at the same time: 0
> > > > > > >   hardware limits: 800 MHz - 2.00 GHz
> > > > > > >   available frequency steps: 2.00 GHz, 1.60 GHz, 1.33 GHz, 1.07
> > > > > > > GHz, 800 MHz available cpufreq governors: powersave, userspace,
> > > > > > > ondemand, performance current policy: frequency should be within
> > > > > > > 800 MHz and 800 MHz. The governor "performance" may decide which
> > > > > > > speed to use within this range.
> > > > > > >   current CPU frequency is 800 MHz.
> > > > > > >
> > > > > > > /sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:0
> > > > > > > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq:800000
> > > > > > > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq:2000000
> > > > > > > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq:800000
> > > > > > > /sys/devices/system/cpu/cpu0/cpufreq/related_cpus:0
> > > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencie
> > > > > > >s:20 0000 0 1600000 1333000 1066000 800000
> > > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors:
> > > > > > >powe rsav e userspace ondemand performance
> > > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq:800000
> > > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver:acpi-cpufreq
> > > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor:performance
> > > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:800000
> > > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq:800000
> > > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed:<unsupporte
> > > > > > >d>
> > > > > >
> > > > > > Thanks.  Is this a newly-occurring bug or did earlier kernels do
> > > > > > this also?
> > > > > >
> > > > > > If it was newly added, do you know in which kernel version we might
> > > > > > have added it?
> > > > >
> > > > > I wasn't able to reproduce the problem on final 2.6.24 but was able
> > > > > to reproduce on final 2.6.25. Problem introduced somewhere between it
> > > > > seems.
> > > > >
> > > > > Note that 2-3 suspend to ram/resume cycles is needed to get into the
> > > > > problem.
> > > >
> > > > Sounds related to:
> > > > ﻿[Bug 374099] T61p speedstep problems (ondemand scheduler)
> > > > ﻿https://bugzilla.novell.com/show_bug.cgi?id=374099
> > >
> > > login/pass protected
> > >
> > > > Miguel speaks from "good boots" and "bad boots".
> > >
> > > Actually I also got "bad boot" (so no suspend/resume was needed).
> > >
> > > > Could you check whether the OS thinks it is too hot.
> > > > ﻿I described some basics how to monitor temperature and cpufreq (if
> > > > passive cooling kicks in) here:
> > > > https://bugzilla.novell.com/show_bug.cgi?id=387702#c13
> > >
> > > Doesn't seem to be overheated
> > >
> > > [arekm@tarm ~]$ cat
> > > /proc/acpi/thermal_zone/*/{temperature,trip_points,state}; cat
> > > /sys/devices/system/cpu/cpu*/cpufreq/scaling_{cur_freq,max_freq}
> > > temperature:             45 C
> > > critical (S5):           99 C
> > > passive:                 95 C: tc1=5 tc2=4 tsp=600 devices= CPU
> > > state:                   ok
> > > 800000
> > > 800000
> > >
> > > but still limited to 800MHz.
> > >
> > > > Hmm, it may just have been fixed by this one:
> > > > ﻿commit e56a727b023d40d1adf660168883f30f2e6abe0a
> > > > Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > > > Date:   Mon Apr 28 15:13:43 2008 -0400
> > > >
> > > > Miguel, Geoff: This is already in 11.0 for some time and in 10.3 for
> > > > some days.
> > >
> > > Unfortunately it doesn't fix the problem. The patch is in Linus tree for
> > > long time (so I guess I had it when initially reporting the problem) + I
> > > upgraded today to current git - the problem is still there.
> >
> > Yep, Dells and some HP should be fixed, it would have been strange if
> > ThinkPads are now also affected, but thanks for double checking, it
> > shows the same symptoms.
> >
> > Then it might be _PPC.
> > If you compile in CPUFREQ_DEBUG and add the boot param:
> > cpufreq.debug=7
> > you should see a message in dmesg (if you do not see one, then
> > everything is fine you have a "good boot" and freq should be at max?):
> > cpufreq_printk("CPU %d: _PPC is %d - frequency %s limited\n", pr->id,
> >                        (int)ppc, ppc ? "" : "not");
> >
> > If PPC is zero all frequencies are allowed, if it is one max_freq will
> > be set to the second highest freq, etc.
> >
> > If it's that you can workaround that (temporarily, pls help evaluating
> > this further) you can use:
> > processor.ignore_ppc=1
> >
> > I remember Ingo Molnar sent a patch to not always evaluate _PPC at
> > boot/initialization time, but only on processor notification events.
> > AFAIK this was a recent ThinkPad, so this might be it what you are
> > seeing. But nobody knew why some ThinkPads had a wrong _PPC value at
> > initialization time.
> >
> > If this is PPC related, this is more an ACPI than a cpufreq issue ->
> > adding linux-acpi list.
> 
> Ok, there is something, see:
> 
> [ 4093.625227] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> [ 4095.755272] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> [ 4095.755508] acpi-cpufreq: acpi_cpufreq_verify
> [ 4095.755642] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> [ 4095.755780] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> [ 4095.755916] acpi-cpufreq: acpi_cpufreq_verify
> [ 4095.756042] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
> [ 4095.756179] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
> [ 4095.756314] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
> 
> PPC related messages are:
> 
> $ dmesg|grep PPC
> [ 3597.291342] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
> [ 3721.943484] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
> [ 3881.874373] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
> [ 4216.175414] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
> 
This looks ok...
I'd expected:
[ 4216.175414] cpufreq-core: CPU 0: _PPC is 4 - frequency limited
Then it should be limited and get unlimited with e.g.:
[ 4216.175414] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited

AFAIK, max_freq should only get limited via passive cooling or explicit
BIOS limitation via _PPC.

> May 26 19:02:28 tarm kernel: [    6.184998] ACPI: Video Device [VID1]
The video driver is rather broken, especially on ThinkPads arbitrary HW
might get accessed, better blacklist video in modprobe.conf for now.
Probably unrelated, just to be sure...

Some strange frequency targets, min freq is 800.000 Khz, I wonder where
these values are coming from:
May 26 17:40:57 tarm kernel: [ 2319.124990] cpufreq-core: target for CPU
0: 400000 kHz, relation 0
May 26 17:40:57 tarm kernel: [ 2319.125141] acpi-cpufreq:
acpi_cpufreq_target 400000 (0)
May 26 17:59:39 tarm kernel: [ 3441.125163] cpufreq-core: target for CPU
0: 571428 kHz, relation 0
May 26 17:39:57 tarm kernel: [ 2259.125137] cpufreq-core: target for CPU 0: 342857 kHz, relation 0


The bad seems to happen at the end at 17:59 (the rest of the logs should
be rather uninteresting). There the frequency gets limited to 800. Then
every about 2-3 (18:02, 18:04)  mins something odd is happening:
The limitation falls away (2000 is allowed again) and ten seconds later
the frequency is limited again.

It already starts before...:
17:59:54 limited to 800
18:02:15 unlimited, max_freq 2000
18:02:28 limited to 800
18:04:20 unlimited, max_freq 2000
18:05:14 limited to 800
18:07:00 unlimited, max_freq 2000
18:10:34 limited to 800


Sorry, but I currently do not have time to look deeper at this.
I try to look at it the next days, if I haven't answered until Sa, I
won't be able to for the next 2 weeks.

   Thomas

> complete log from boot:
(stripped)
> May 26 17:13:47 tarm kernel: [  681.613159] Freezing user space processes ... (elapsed 0.00 seconds) done.
> May 26 17:13:47 tarm kernel: [  681.614674] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> May 26 17:13:47 tarm kernel: [  681.614758] Suspending console(s)
> May 26 17:13:47 tarm kernel: [  681.835093] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> May 26 17:13:47 tarm kernel: [  681.844214] sd 0:0:0:0: [sda] Stopping disk
> May 26 17:13:47 tarm kernel: [  683.265808] nsc-ircc 00:09: disabled
> May 26 17:13:47 tarm kernel: [  683.265997] eth1: Going into suspend...
> May 26 17:13:47 tarm kernel: [  683.270843] ACPI: PCI interrupt for device 0000:14:02.0 disabled
> May 26 17:13:47 tarm kernel: [  683.270855] ACPI handle has no context!
> May 26 17:13:47 tarm kernel: [  683.286131] ACPI handle has no context!
> May 26 17:13:47 tarm kernel: [  683.286160] ACPI: PCI interrupt for device 0000:14:00.2 disabled
> May 26 17:13:47 tarm kernel: [  683.286170] ACPI handle has no context!
> May 26 17:13:47 tarm kernel: [  683.306077] ACPI handle has no context!
> May 26 17:13:47 tarm kernel: [  683.462597] ACPI handle has no context!
> May 26 17:13:47 tarm kernel: [  683.681053] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
> May 26 17:13:47 tarm kernel: [  683.700321] ACPI: Preparing to enter system sleep state S3
> May 26 17:13:47 tarm kernel: [  683.712644] Extended CMOS year: 2000
> May 26 17:13:47 tarm kernel: [  683.712644] Intel machine check architecture supported.
> May 26 17:13:47 tarm kernel: [  683.712660] Intel machine check reporting enabled on CPU#0.
> May 26 17:13:47 tarm kernel: [  683.712761] Back to C!
> May 26 17:13:47 tarm kernel: [  683.712967] Extended CMOS year: 2000
> May 26 17:13:47 tarm kernel: [  683.712967] Force enabled HPET at resume
> May 26 17:13:47 tarm kernel: [  683.712967] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 17:13:47 tarm kernel: [  683.712967] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:13:47 tarm kernel: [  683.712967] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 17:13:47 tarm kernel: [  683.712967] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 17:13:47 tarm kernel: [  683.712967] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:13:47 tarm kernel: [  683.712967] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 17:13:47 tarm kernel: [  683.712967] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 17:13:47 tarm kernel: [  683.712967] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
> May 26 17:13:47 tarm kernel: [  683.712967] cpufreq-core: governor: change or update limits
> May 26 17:13:47 tarm kernel: [  683.712967] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 17:13:47 tarm kernel: [  683.762614] PM: Writing back config space on device 0000:00:01.0 at offset 1 (was 100107, writing 100507)
> May 26 17:13:47 tarm kernel: [  683.762614] PCI: Setting latency timer of device 0000:00:01.0 to 64
> May 26 17:13:47 tarm kernel: [  683.789051] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100006, writing 100002)
> May 26 17:13:47 tarm kernel: [  683.789074] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
> May 26 17:13:47 tarm kernel: [  683.789081] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> May 26 17:13:47 tarm kernel: [  683.845176] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
> May 26 17:13:47 tarm kernel: [  683.845248] PCI: Setting latency timer of device 0000:00:1c.0 to 64
> May 26 17:13:47 tarm kernel: [  683.845299] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
> May 26 17:13:47 tarm kernel: [  683.845363] PCI: Setting latency timer of device 0000:00:1c.1 to 64
> May 26 17:13:47 tarm kernel: [  683.845423] PM: Writing back config space on device 0000:00:1c.2 at offset 1 (was 100107, writing 100507)
> May 26 17:13:47 tarm kernel: [  683.845487] PCI: Setting latency timer of device 0000:00:1c.2 to 64
> May 26 17:13:47 tarm kernel: [  683.845548] PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100107, writing 100507)
> May 26 17:13:47 tarm kernel: [  683.845611] PCI: Setting latency timer of device 0000:00:1c.3 to 64
> May 26 17:13:47 tarm kernel: [  683.845627] PM: Writing back config space on device 0000:00:1d.0 at offset f (was 100, writing 10b)
> May 26 17:13:47 tarm kernel: [  683.845673] PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20b)
> May 26 17:13:47 tarm kernel: [  683.845728] PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 30b)
> May 26 17:13:47 tarm kernel: [  683.845774] PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 40b)
> May 26 17:13:47 tarm kernel: [  683.845836] PM: Writing back config space on device 0000:00:1d.7 at offset f (was 400, writing 40b)
> May 26 17:13:47 tarm kernel: [  683.845873] PM: Writing back config space on device 0000:00:1d.7 at offset 4 (was 0, writing b0004000)
> May 26 17:13:47 tarm kernel: [  683.845881] PM: Writing back config space on device 0000:00:1d.7 at offset 1 (was 2900000, writing 2900102)
> May 26 17:13:47 tarm kernel: [  683.845980] PCI: Setting latency timer of device 0000:00:1e.0 to 64
> May 26 17:13:47 tarm kernel: [  683.861043] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00005, writing 2b80005)
> May 26 17:13:47 tarm kernel: [  683.861062] PCI: Setting latency timer of device 0000:00:1f.2 to 64
> May 26 17:13:47 tarm kernel: [  683.863259] PM: Writing back config space on device 0000:01:00.0 at offset 1 (was 100103, writing 100107)
> May 26 17:13:47 tarm kernel: [  683.863323] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> May 26 17:13:47 tarm kernel: [  683.863327] PCI: Setting latency timer of device 0000:01:00.0 to 64
> May 26 17:13:47 tarm kernel: [  683.863365] PM: Writing back config space on device 0000:02:00.0 at offset c (was 0, writing fcff0000)
> May 26 17:13:47 tarm kernel: [  683.863391] PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 100102, writing 100106)
> May 26 17:13:47 tarm kernel: [  684.201259] PM: Writing back config space on device 0000:14:00.1 at offset 4 (was 0, writing c0001000)
> May 26 17:13:47 tarm kernel: [  684.201265] PM: Writing back config space on device 0000:14:00.1 at offset 3 (was 800000, writing 804000)
> May 26 17:13:47 tarm kernel: [  684.201273] PM: Writing back config space on device 0000:14:00.1 at offset 1 (was 2100000, writing 2100106)
> May 26 17:13:47 tarm kernel: [  684.213807] ata2.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
> May 26 17:13:47 tarm kernel: [  684.213809] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
> May 26 17:13:47 tarm kernel: [  684.221813] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 succeeded
> May 26 17:13:47 tarm kernel: [  684.229816] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 succeeded
> May 26 17:13:47 tarm kernel: [  684.254164] ata2.00: configured for UDMA/33
> May 26 17:13:47 tarm kernel: [  684.256181] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[c0001000-c00017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
> May 26 17:13:47 tarm kernel: [  684.281188] PM: Writing back config space on device 0000:14:00.2 at offset 4 (was 0, writing c0001800)
> May 26 17:13:47 tarm kernel: [  684.281193] PM: Writing back config space on device 0000:14:00.2 at offset 3 (was 800000, writing 804000)
> May 26 17:13:47 tarm kernel: [  684.281200] PM: Writing back config space on device 0000:14:00.2 at offset 1 (was 2100000, writing 2100106)
> May 26 17:13:47 tarm kernel: [  684.281219] ACPI: PCI Interrupt 0000:14:00.2[C] -> GSI 18 (level, low) -> IRQ 18
> May 26 17:13:47 tarm kernel: [  684.282264] eth1: Coming out of suspend...
> May 26 17:13:47 tarm kernel: [  684.304115] ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> IRQ 21
> May 26 17:13:47 tarm kernel: [  684.304856] nsc-ircc 00:09: activated
> May 26 17:13:47 tarm kernel: [  685.125021] __ratelimit: 36 messages suppressed
> May 26 17:13:47 tarm kernel: [  685.125024] cpufreq-core: target for CPU 0: 1005714 kHz, relation 0
> May 26 17:13:47 tarm kernel: [  685.240365] sd 0:0:0:0: [sda] Starting disk
> May 26 17:13:47 tarm kernel: [  685.361681] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
> May 26 17:13:47 tarm kernel: [  685.361686] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> May 26 17:13:47 tarm kernel: [  685.361691] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
> May 26 17:13:47 tarm kernel: [  685.361696] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
> May 26 17:13:47 tarm kernel: [  685.362115] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
> May 26 17:13:47 tarm kernel: [  685.385653] ata1.00: configured for UDMA/100
> May 26 17:13:47 tarm kernel: [  685.409640] ata1.00: configured for UDMA/100
> May 26 17:13:47 tarm kernel: [  685.409645] ata1: EH complete
> May 26 17:13:47 tarm kernel: [  685.409720] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
> May 26 17:13:47 tarm kernel: [  685.409754] sd 0:0:0:0: [sda] Write Protect is off
> May 26 17:13:47 tarm kernel: [  685.409759] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> May 26 17:13:47 tarm kernel: [  685.409816] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> May 26 17:13:47 tarm kernel: [  685.409873] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
> May 26 17:13:47 tarm kernel: [  685.409904] sd 0:0:0:0: [sda] Write Protect is off
> May 26 17:13:47 tarm kernel: [  685.409908] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> May 26 17:13:47 tarm kernel: [  685.409964] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> May 26 17:13:47 tarm kernel: [  688.101026] hdaps: initial latch check good (0x01).
> May 26 17:13:47 tarm kernel: [  688.509522] Restarting tasks ... done.
> May 26 17:13:47 tarm kernel: [  688.613227] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
> May 26 17:13:47 tarm kernel: [  688.613491] PCI: Setting latency timer of device 0000:00:1d.7 to 64
> May 26 17:13:47 tarm kernel: [  688.613633] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> May 26 17:13:47 tarm kernel: [  688.662871] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> May 26 17:13:47 tarm kernel: [  688.667009] ehci_hcd 0000:00:1d.7: debug port 1
> May 26 17:13:47 tarm kernel: [  688.669045] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
> May 26 17:13:47 tarm kernel: [  688.669225] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xb0004000
> May 26 17:13:47 tarm kernel: [  688.685034] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> May 26 17:13:47 tarm kernel: [  688.685481] usb usb1: configuration #1 chosen from 1 choice
> May 26 17:13:47 tarm kernel: [  688.691355] hub 1-0:1.0: USB hub found
> May 26 17:13:47 tarm kernel: [  688.691495] hub 1-0:1.0: 8 ports detected
> May 26 17:13:47 tarm kernel: [  688.805182] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> May 26 17:13:47 tarm kernel: [  688.805194] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> May 26 17:13:47 tarm kernel: [  688.805201] usb usb1: Product: EHCI Host Controller
> May 26 17:13:47 tarm kernel: [  688.805207] usb usb1: Manufacturer: Linux 2.6.26-rc3 ehci_hcd
> May 26 17:13:47 tarm kernel: [  688.805213] usb usb1: SerialNumber: 0000:00:1d.7
> May 26 17:13:47 tarm kernel: [  688.816077] USB Universal Host Controller Interface driver v3.0
> May 26 17:13:47 tarm kernel: [  688.816157] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
> May 26 17:13:47 tarm kernel: [  688.816177] PCI: Setting latency timer of device 0000:00:1d.0 to 64
> May 26 17:13:47 tarm kernel: [  688.816185] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> May 26 17:13:47 tarm kernel: [  688.816252] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> May 26 17:13:47 tarm kernel: [  688.816288] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
> May 26 17:13:47 tarm kernel: [  688.816514] usb usb2: configuration #1 chosen from 1 choice
> May 26 17:13:47 tarm kernel: [  688.816578] hub 2-0:1.0: USB hub found
> May 26 17:13:47 tarm kernel: [  688.816592] hub 2-0:1.0: 2 ports detected
> May 26 17:13:47 tarm kernel: [  688.917139] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> May 26 17:13:47 tarm kernel: [  688.917780] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> May 26 17:13:47 tarm kernel: [  688.917792] usb usb2: Product: UHCI Host Controller
> May 26 17:13:47 tarm kernel: [  688.917798] usb usb2: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
> May 26 17:13:47 tarm kernel: [  688.917803] usb usb2: SerialNumber: 0000:00:1d.0
> May 26 17:13:47 tarm kernel: [  688.917849] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
> May 26 17:13:47 tarm kernel: [  688.917868] PCI: Setting latency timer of device 0000:00:1d.1 to 64
> May 26 17:13:47 tarm kernel: [  688.917876] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> May 26 17:13:47 tarm kernel: [  688.917936] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> May 26 17:13:47 tarm kernel: [  688.917972] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
> May 26 17:13:47 tarm kernel: [  688.918197] usb usb3: configuration #1 chosen from 1 choice
> May 26 17:13:47 tarm kernel: [  688.918263] hub 3-0:1.0: USB hub found
> May 26 17:13:47 tarm kernel: [  688.918277] hub 3-0:1.0: 2 ports detected
> May 26 17:13:48 tarm kernel: [  689.001814] hub 1-0:1.0: unable to enumerate USB device on port 3
> May 26 17:13:48 tarm kernel: [  689.021284] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> May 26 17:13:48 tarm kernel: [  689.021491] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> May 26 17:13:48 tarm kernel: [  689.021502] usb usb3: Product: UHCI Host Controller
> May 26 17:13:48 tarm kernel: [  689.021507] usb usb3: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
> May 26 17:13:48 tarm kernel: [  689.021513] usb usb3: SerialNumber: 0000:00:1d.1
> May 26 17:13:48 tarm kernel: [  689.021559] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
> May 26 17:13:48 tarm kernel: [  689.021578] PCI: Setting latency timer of device 0000:00:1d.2 to 64
> May 26 17:13:48 tarm kernel: [  689.021586] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> May 26 17:13:48 tarm kernel: [  689.021641] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> May 26 17:13:48 tarm kernel: [  689.021675] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
> May 26 17:13:48 tarm kernel: [  689.021905] usb usb4: configuration #1 chosen from 1 choice
> May 26 17:13:48 tarm kernel: [  689.021971] hub 4-0:1.0: USB hub found
> May 26 17:13:48 tarm kernel: [  689.021984] hub 4-0:1.0: 2 ports detected
> May 26 17:13:48 tarm kernel: [  689.125223] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> May 26 17:13:48 tarm kernel: [  689.125235] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> May 26 17:13:48 tarm kernel: [  689.125242] usb usb4: Product: UHCI Host Controller
> May 26 17:13:48 tarm kernel: [  689.125248] usb usb4: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
> May 26 17:13:48 tarm kernel: [  689.125254] usb usb4: SerialNumber: 0000:00:1d.2
> May 26 17:13:48 tarm kernel: [  689.125297] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
> May 26 17:13:48 tarm kernel: [  689.125317] PCI: Setting latency timer of device 0000:00:1d.3 to 64
> May 26 17:13:48 tarm kernel: [  689.125324] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> May 26 17:13:48 tarm kernel: [  689.125377] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> May 26 17:13:48 tarm kernel: [  689.125412] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
> May 26 17:13:48 tarm kernel: [  689.125642] usb usb5: configuration #1 chosen from 1 choice
> May 26 17:13:48 tarm kernel: [  689.125708] hub 5-0:1.0: USB hub found
> May 26 17:13:48 tarm kernel: [  689.125722] hub 5-0:1.0: 2 ports detected
> May 26 17:13:48 tarm kernel: [  689.229073] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> May 26 17:13:48 tarm kernel: [  689.229218] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> May 26 17:13:48 tarm kernel: [  689.229275] usb usb5: Product: UHCI Host Controller
> May 26 17:13:48 tarm kernel: [  689.229328] usb usb5: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
> May 26 17:13:48 tarm kernel: [  689.229380] usb usb5: SerialNumber: 0000:00:1d.3
> May 26 17:13:48 tarm kernel: [  689.241062] hub 1-0:1.0: unable to enumerate USB device on port 5
> May 26 17:13:48 tarm kernel: [  689.335824] [drm] Loading R300 Microcode
> May 26 17:13:48 tarm kernel: [  689.481010] hub 1-0:1.0: unable to enumerate USB device on port 6
> May 26 17:13:48 tarm kernel: [  689.721001] usb 3-1: new low speed USB device using uhci_hcd and address 2
> May 26 17:13:48 tarm kernel: [  689.900933] usb 3-1: configuration #1 chosen from 1 choice
> May 26 17:13:48 tarm kernel: [  689.929009] input: Logitech Trackball as /class/input/input18
> May 26 17:13:48 tarm kernel: [  689.957156] input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:1d.1-1
> May 26 17:13:48 tarm kernel: [  689.957408] usb 3-1: New USB device found, idVendor=046d, idProduct=c404
> May 26 17:13:48 tarm kernel: [  689.957465] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> May 26 17:13:48 tarm kernel: [  689.957517] usb 3-1: Product: Trackball
> May 26 17:13:48 tarm kernel: [  689.957566] usb 3-1: Manufacturer: Logitech
> May 26 17:13:49 tarm kernel: [  690.197096] usb 4-1: new full speed USB device using uhci_hcd and address 2
> May 26 17:13:49 tarm kernel: [  690.374479] usb 4-1: configuration #1 chosen from 1 choice
> May 26 17:13:49 tarm kernel: [  690.380777] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2110
> May 26 17:13:49 tarm kernel: [  690.381156] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> May 26 17:13:49 tarm kernel: [  690.381228] usb 4-1: Product: BCM2045B
> May 26 17:13:49 tarm kernel: [  690.381279] usb 4-1: Manufacturer: Broadcom Corp
> May 26 17:13:49 tarm kernel: [  690.621038] usb 4-2: new full speed USB device using uhci_hcd and address 3
> May 26 17:13:49 tarm kernel: [  690.642216] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
> May 26 17:13:49 tarm kernel: [  690.649778] pan1: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
> May 26 17:13:49 tarm kernel: [  690.791941] usb 4-2: configuration #1 chosen from 1 choice
> May 26 17:13:49 tarm kernel: [  690.799042] usb 4-2: New USB device found, idVendor=0483, idProduct=2016
> May 26 17:13:49 tarm kernel: [  690.799147] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> May 26 17:13:49 tarm kernel: [  690.799217] usb 4-2: Product: Biometric Coprocessor
> May 26 17:13:49 tarm kernel: [  690.799267] usb 4-2: Manufacturer: STMicroelectronics
> May 26 17:13:51 tarm kernel: [  692.125168] __ratelimit: 20 messages suppressed
> May 26 17:13:51 tarm kernel: [  692.125309] cpufreq-core: target for CPU 0: 400000 kHz, relation 0
> May 26 17:13:51 tarm kernel: [  692.821450] ADDRCONF(NETDEV_UP): eth0: link is not ready
> May 26 17:13:54 tarm kernel: [  695.124991] __ratelimit: 13 messages suppressed
> May 26 17:13:54 tarm kernel: [  695.125126] cpufreq-core: target for CPU 0: 1714285 kHz, relation 0
> May 26 17:13:57 tarm kernel: [  698.726701] ADDRCONF(NETDEV_UP): eth1: link is not ready
> May 26 17:13:58 tarm kernel: [  699.619284] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> May 26 17:14:00 tarm kernel: [  701.625013] __ratelimit: 27 messages suppressed
> May 26 17:14:00 tarm kernel: [  701.625238] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:14:01 tarm kernel: [  702.285362] tun0: Disabled Privacy Extensions
> May 26 17:14:08 tarm kernel: [  709.912981] eth1: no IPv6 routers present
> May 26 17:14:10 tarm kernel: [  711.125019] __ratelimit: 27 messages suppressed
> May 26 17:14:10 tarm kernel: [  711.125255] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:14:10 tarm kernel: [  711.125430] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:14:51 tarm kernel: [  752.125025] __ratelimit: 12 messages suppressed
> May 26 17:14:51 tarm kernel: [  752.125268] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:14:51 tarm kernel: [  752.125414] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:14:51 tarm kernel: [  752.125551] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:14:51 tarm kernel: [  752.125691] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:14:51 tarm kernel: [  752.125820] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:14:51 tarm kernel: [  752.125978] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:14:51 tarm kernel: [  752.126035] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:14:51 tarm kernel: [  752.624990] cpufreq-core: target for CPU 0: 685714 kHz, relation 0
> May 26 17:14:54 tarm kernel: [  755.125030] __ratelimit: 20 messages suppressed
> May 26 17:14:54 tarm kernel: [  755.125175] cpufreq-core: target for CPU 0: 137142 kHz, relation 0
> May 26 17:15:05 tarm kernel: [  766.626964] __ratelimit: 39 messages suppressed
> May 26 17:15:05 tarm kernel: [  766.627173] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:15:05 tarm kernel: [  766.627318] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:15:09 tarm kernel: [  770.625018] __ratelimit: 19 messages suppressed
> May 26 17:15:09 tarm kernel: [  770.625466] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:15:18 tarm kernel: [  779.625026] __ratelimit: 13 messages suppressed
> May 26 17:15:18 tarm kernel: [  779.625254] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:15:19 tarm kernel: [  780.124986] __ratelimit: 6 messages suppressed
> May 26 17:15:19 tarm kernel: [  780.125126] cpufreq-core: target for CPU 0: 171428 kHz, relation 0
> May 26 17:15:53 tarm kernel: [  814.624997] __ratelimit: 20 messages suppressed
> May 26 17:15:53 tarm kernel: [  814.625215] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:15:53 tarm kernel: [  814.625381] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:15:53 tarm kernel: [  814.625513] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:15:53 tarm kernel: [  814.625650] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:15:53 tarm kernel: [  814.625779] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:15:53 tarm kernel: [  814.625913] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:15:54 tarm kernel: [  815.124988] __ratelimit: 1 messages suppressed
> May 26 17:15:54 tarm kernel: [  815.125128] cpufreq-core: target for CPU 0: 0 kHz, relation 0
> May 26 17:16:53 tarm kernel: [  874.624998] __ratelimit: 6 messages suppressed
> May 26 17:16:53 tarm kernel: [  874.625222] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:16:53 tarm kernel: [  874.625388] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:16:53 tarm kernel: [  874.625522] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:16:53 tarm kernel: [  874.625658] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:16:53 tarm kernel: [  874.625786] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:16:53 tarm kernel: [  874.625920] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:16:53 tarm kernel: [  874.625975] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:16:54 tarm kernel: [  875.124986] cpufreq-core: target for CPU 0: 0 kHz, relation 0
> May 26 17:16:54 tarm kernel: [  875.125137] acpi-cpufreq: acpi_cpufreq_target 0 (0)
> May 26 17:16:54 tarm kernel: [  875.125211] freq-table: request for target 0 kHz (relation: 0) for cpu 0
> May 26 17:17:53 tarm kernel: [  934.625012] __ratelimit: 18 messages suppressed
> May 26 17:17:53 tarm kernel: [  934.625248] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:17:53 tarm kernel: [  934.625413] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:17:53 tarm kernel: [  934.625549] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:17:53 tarm kernel: [  934.625685] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:17:53 tarm kernel: [  934.625815] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:17:53 tarm kernel: [  934.625949] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:17:53 tarm kernel: [  934.626004] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:17:54 tarm kernel: [  935.124990] cpufreq-core: target for CPU 0: 171428 kHz, relation 0
> May 26 17:17:54 tarm kernel: [  935.125159] acpi-cpufreq: acpi_cpufreq_target 171428 (0)
> May 26 17:17:54 tarm kernel: [  935.125249] freq-table: request for target 171428 kHz (relation: 0) for cpu 0
> May 26 17:18:04 tarm kernel: [  945.125001] __ratelimit: 4 messages suppressed
> May 26 17:18:04 tarm kernel: [  945.125228] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:18:04 tarm kernel: [  945.125397] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:18:53 tarm kernel: [  994.625059] __ratelimit: 12 messages suppressed
> May 26 17:18:53 tarm kernel: [  994.625297] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:18:53 tarm kernel: [  994.625440] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:18:53 tarm kernel: [  994.625575] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:18:53 tarm kernel: [  994.625715] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:18:53 tarm kernel: [  994.625847] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:18:53 tarm kernel: [  994.625983] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:18:53 tarm kernel: [  994.626037] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:18:54 tarm kernel: [  995.624989] cpufreq-core: target for CPU 0: 57142 kHz, relation 0
> May 26 17:18:54 tarm kernel: [  995.625149] acpi-cpufreq: acpi_cpufreq_target 57142 (0)
> May 26 17:18:54 tarm kernel: [  995.625223] freq-table: request for target 57142 kHz (relation: 0) for cpu 0
> May 26 17:19:14 tarm kernel: [ 1015.125008] __ratelimit: 4 messages suppressed
> May 26 17:19:14 tarm kernel: [ 1015.125233] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:19:14 tarm kernel: [ 1015.125399] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:19:14 tarm kernel: [ 1015.125533] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:19:14 tarm kernel: [ 1015.125670] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:19:54 tarm kernel: [ 1055.125008] __ratelimit: 17 messages suppressed
> May 26 17:19:54 tarm kernel: [ 1055.125243] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:19:54 tarm kernel: [ 1055.125382] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:19:54 tarm kernel: [ 1055.125513] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:19:54 tarm kernel: [ 1055.125649] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:19:54 tarm kernel: [ 1055.125777] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:19:54 tarm kernel: [ 1055.125911] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:19:54 tarm kernel: [ 1055.125965] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:19:54 tarm kernel: [ 1055.625012] cpufreq-core: target for CPU 0: 57142 kHz, relation 0
> May 26 17:20:14 tarm kernel: [ 1075.125008] __ratelimit: 6 messages suppressed
> May 26 17:20:14 tarm kernel: [ 1075.125237] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:20:14 tarm kernel: [ 1075.125381] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:20:14 tarm kernel: [ 1075.125515] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:20:14 tarm kernel: [ 1075.125653] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:20:26 tarm kernel: [ 1087.124998] __ratelimit: 10 messages suppressed
> May 26 17:20:26 tarm kernel: [ 1087.125221] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:20:26 tarm kernel: [ 1087.125384] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:20:54 tarm kernel: [ 1115.124997] __ratelimit: 12 messages suppressed
> May 26 17:20:54 tarm kernel: [ 1115.125222] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:20:54 tarm kernel: [ 1115.125388] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:20:54 tarm kernel: [ 1115.125523] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:20:54 tarm kernel: [ 1115.125659] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:20:54 tarm kernel: [ 1115.125788] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:20:54 tarm kernel: [ 1115.125947] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:21:15 tarm kernel: [ 1136.125011] __ratelimit: 8 messages suppressed
> May 26 17:21:15 tarm kernel: [ 1136.125243] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:21:15 tarm kernel: [ 1136.125382] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:21:15 tarm kernel: [ 1136.125527] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:21:15 tarm kernel: [ 1136.125689] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:21:54 tarm kernel: [ 1175.125018] __ratelimit: 10 messages suppressed
> May 26 17:21:54 tarm kernel: [ 1175.125245] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:21:54 tarm kernel: [ 1175.125387] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:21:54 tarm kernel: [ 1175.125520] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:21:54 tarm kernel: [ 1175.125658] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:21:54 tarm kernel: [ 1175.125790] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:21:54 tarm kernel: [ 1175.125925] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:21:54 tarm kernel: [ 1175.125979] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:21:54 tarm kernel: [ 1175.624992] cpufreq-core: target for CPU 0: 1771428 kHz, relation 0
> May 26 17:22:16 tarm kernel: [ 1197.625810] __ratelimit: 11 messages suppressed
> May 26 17:22:16 tarm kernel: [ 1197.626031] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:22:16 tarm kernel: [ 1197.626176] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:22:16 tarm kernel: [ 1197.626457] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:22:16 tarm kernel: [ 1197.626603] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:22:29 tarm kernel: [ 1210.125024] __ratelimit: 10 messages suppressed
> May 26 17:22:29 tarm kernel: [ 1210.125247] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:22:29 tarm kernel: [ 1210.125393] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:22:29 tarm kernel: [ 1210.125528] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:22:54 tarm kernel: [ 1235.625018] __ratelimit: 11 messages suppressed
> May 26 17:22:54 tarm kernel: [ 1235.625239] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:22:54 tarm kernel: [ 1235.625403] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:22:54 tarm kernel: [ 1235.625538] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:22:54 tarm kernel: [ 1235.625674] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:22:54 tarm kernel: [ 1235.625803] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:23:16 tarm kernel: [ 1257.125017] __ratelimit: 9 messages suppressed
> May 26 17:23:16 tarm kernel: [ 1257.125262] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:23:16 tarm kernel: [ 1257.125404] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:23:16 tarm kernel: [ 1257.125536] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:23:16 tarm kernel: [ 1257.125673] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:23:54 tarm kernel: [ 1295.625025] __ratelimit: 10 messages suppressed
> May 26 17:23:54 tarm kernel: [ 1295.625295] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:23:54 tarm kernel: [ 1295.625453] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:23:54 tarm kernel: [ 1295.625591] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:23:54 tarm kernel: [ 1295.625732] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:23:54 tarm kernel: [ 1295.625866] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:23:54 tarm kernel: [ 1295.626006] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:23:54 tarm kernel: [ 1295.626069] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:23:55 tarm kernel: [ 1296.124988] cpufreq-core: target for CPU 0: 342857 kHz, relation 0
> May 26 17:24:22 tarm kernel: [ 1323.125013] __ratelimit: 6 messages suppressed
> May 26 17:24:22 tarm kernel: [ 1323.125256] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:24:22 tarm kernel: [ 1323.125399] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:24:22 tarm kernel: [ 1323.125532] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:24:22 tarm kernel: [ 1323.125670] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:24:22 tarm kernel: [ 1323.125798] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:24:25 tarm kernel: [ 1326.125101] __ratelimit: 9 messages suppressed
> May 26 17:24:25 tarm kernel: [ 1326.125315] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:24:28 tarm kernel: [ 1329.625024] __ratelimit: 46 messages suppressed
> May 26 17:24:28 tarm kernel: [ 1329.625208] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:24:33 tarm kernel: [ 1334.624994] __ratelimit: 53 messages suppressed
> May 26 17:24:33 tarm kernel: [ 1334.625181] cpufreq-core: target for CPU 0: 121828 kHz, relation 0
> May 26 17:24:44 tarm kernel: [ 1345.125022] __ratelimit: 6 messages suppressed
> May 26 17:24:44 tarm kernel: [ 1345.125262] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:24:44 tarm kernel: [ 1345.125404] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:24:49 tarm kernel: [ 1350.125010] __ratelimit: 12 messages suppressed
> May 26 17:24:49 tarm kernel: [ 1350.125260] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:24:54 tarm kernel: [ 1355.625050] __ratelimit: 34 messages suppressed
> May 26 17:24:54 tarm kernel: [ 1355.625262] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:25:01 tarm kernel: [ 1362.124998] __ratelimit: 34 messages suppressed
> May 26 17:25:01 tarm kernel: [ 1362.125214] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:25:03 tarm kernel: [ 1364.625011] __ratelimit: 13 messages suppressed
> May 26 17:25:03 tarm kernel: [ 1364.625239] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:25:09 tarm kernel: [ 1370.625010] __ratelimit: 27 messages suppressed
> May 26 17:25:09 tarm kernel: [ 1370.625247] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:25:24 tarm kernel: [ 1385.625023] __ratelimit: 13 messages suppressed
> May 26 17:25:24 tarm kernel: [ 1385.625231] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:25:24 tarm kernel: [ 1385.625374] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:25:24 tarm kernel: [ 1385.625510] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:25:29 tarm kernel: [ 1390.125013] __ratelimit: 25 messages suppressed
> May 26 17:25:29 tarm kernel: [ 1390.125240] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:25:36 tarm kernel: [ 1397.125009] __ratelimit: 20 messages suppressed
> May 26 17:25:36 tarm kernel: [ 1397.125254] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:25:38 tarm kernel: [ 1399.625042] __ratelimit: 20 messages suppressed
> May 26 17:25:38 tarm kernel: [ 1399.625259] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:25:54 tarm kernel: [ 1415.625005] __ratelimit: 41 messages suppressed
> May 26 17:25:54 tarm kernel: [ 1415.625225] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:25:54 tarm kernel: [ 1415.625370] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:25:54 tarm kernel: [ 1415.625506] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:26:27 tarm kernel: [ 1448.625114] __ratelimit: 11 messages suppressed
> May 26 17:26:27 tarm kernel: [ 1448.625339] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:26:27 tarm kernel: [ 1448.625508] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:26:27 tarm kernel: [ 1448.625693] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:26:27 tarm kernel: [ 1448.625829] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:26:27 tarm kernel: [ 1448.625957] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:26:27 tarm kernel: [ 1448.626090] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:26:54 tarm kernel: [ 1476.125842] __ratelimit: 8 messages suppressed
> May 26 17:26:54 tarm kernel: [ 1476.126064] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:26:54 tarm kernel: [ 1476.126209] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:26:54 tarm kernel: [ 1476.126346] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:26:54 tarm kernel: [ 1476.126485] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:26:54 tarm kernel: [ 1476.126616] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:26:54 tarm kernel: [ 1476.126753] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:27:07 tarm kernel: [ 1488.625025] __ratelimit: 8 messages suppressed
> May 26 17:27:07 tarm kernel: [ 1488.625264] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:27:07 tarm kernel: [ 1488.625406] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:27:09 tarm kernel: [ 1491.128646] __ratelimit: 12 messages suppressed
> May 26 17:27:09 tarm kernel: [ 1491.128868] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:27:14 tarm kernel: [ 1496.125016] __ratelimit: 27 messages suppressed
> May 26 17:27:14 tarm kernel: [ 1496.125257] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:27:21 tarm kernel: [ 1502.625087] __ratelimit: 34 messages suppressed
> May 26 17:27:21 tarm kernel: [ 1502.625320] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:27:26 tarm kernel: [ 1507.625104] __ratelimit: 13 messages suppressed
> May 26 17:27:26 tarm kernel: [ 1507.625321] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:27:54 tarm kernel: [ 1536.125010] __ratelimit: 18 messages suppressed
> May 26 17:27:54 tarm kernel: [ 1536.125254] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:27:54 tarm kernel: [ 1536.125395] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:27:54 tarm kernel: [ 1536.125529] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:27:54 tarm kernel: [ 1536.125666] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:27:54 tarm kernel: [ 1536.125794] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:27:54 tarm kernel: [ 1536.125928] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:28:35 tarm kernel: [ 1577.125012] __ratelimit: 15 messages suppressed
> May 26 17:28:35 tarm kernel: [ 1577.125259] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:28:35 tarm kernel: [ 1577.125429] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:28:35 tarm kernel: [ 1577.125565] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:28:35 tarm kernel: [ 1577.125702] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:28:35 tarm kernel: [ 1577.125831] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:28:35 tarm kernel: [ 1577.125965] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:28:35 tarm kernel: [ 1577.126019] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:28:36 tarm kernel: [ 1577.625003] cpufreq-core: target for CPU 0: 914285 kHz, relation 0
> May 26 17:28:55 tarm kernel: [ 1596.625005] __ratelimit: 13 messages suppressed
> May 26 17:28:55 tarm kernel: [ 1596.625226] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:28:55 tarm kernel: [ 1596.625396] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:28:55 tarm kernel: [ 1596.625533] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:28:55 tarm kernel: [ 1596.625686] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:29:04 tarm kernel: [ 1605.626418] __ratelimit: 10 messages suppressed
> May 26 17:29:04 tarm kernel: [ 1605.626630] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:29:04 tarm kernel: [ 1605.626772] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:29:24 tarm kernel: [ 1625.625002] __ratelimit: 40 messages suppressed
> May 26 17:29:24 tarm kernel: [ 1625.625218] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:29:24 tarm kernel: [ 1625.625363] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:29:24 tarm kernel: [ 1625.625501] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:29:24 tarm kernel: [ 1625.625643] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:29:39 tarm kernel: [ 1641.125020] __ratelimit: 31 messages suppressed
> May 26 17:29:39 tarm kernel: [ 1641.125248] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:29:39 tarm kernel: [ 1641.125387] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:29:39 tarm kernel: [ 1641.125519] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:29:43 tarm kernel: [ 1644.624994] __ratelimit: 16 messages suppressed
> May 26 17:29:43 tarm kernel: [ 1644.625160] cpufreq-core: target for CPU 0: 152342 kHz, relation 0
> May 26 17:30:05 tarm kernel: [ 1666.625410] __ratelimit: 6 messages suppressed
> May 26 17:30:05 tarm kernel: [ 1666.625629] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:30:05 tarm kernel: [ 1666.625774] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:30:05 tarm kernel: [ 1666.625912] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:30:05 tarm kernel: [ 1666.626054] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:30:12 tarm kernel: [ 1674.125189] __ratelimit: 17 messages suppressed
> May 26 17:30:12 tarm kernel: [ 1674.125425] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:30:13 tarm kernel: [ 1674.624988] __ratelimit: 6 messages suppressed
> May 26 17:30:13 tarm kernel: [ 1674.625130] cpufreq-core: target for CPU 0: 0 kHz, relation 0
> May 26 17:30:18 tarm kernel: [ 1680.124993] __ratelimit: 13 messages suppressed
> May 26 17:30:18 tarm kernel: [ 1680.125137] cpufreq-core: target for CPU 0: 57142 kHz, relation 0
> May 26 17:30:23 tarm kernel: [ 1684.625011] __ratelimit: 41 messages suppressed
> May 26 17:30:23 tarm kernel: [ 1684.625238] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:30:25 tarm kernel: [ 1687.103612] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 17:30:25 tarm kernel: [ 1687.103851] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:30:25 tarm kernel: [ 1687.103983] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 17:30:25 tarm kernel: [ 1687.104121] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 17:30:25 tarm kernel: [ 1687.104257] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:30:25 tarm kernel: [ 1687.104385] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
> May 26 17:30:25 tarm kernel: [ 1687.104521] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
> May 26 17:30:25 tarm kernel: [ 1687.104656] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
> May 26 17:30:25 tarm kernel: [ 1687.104788] cpufreq-core: governor: change or update limits
> May 26 17:30:25 tarm kernel: [ 1687.105041] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 17:30:33 tarm kernel: [ 1695.412124] __ratelimit: 25 messages suppressed
> May 26 17:30:33 tarm kernel: [ 1695.412329] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
> May 26 17:30:33 tarm kernel: [ 1695.412490] cpufreq-core: updating policy for CPU 0
> May 26 17:30:33 tarm kernel: [ 1695.412623] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 17:30:33 tarm kernel: [ 1695.412757] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:30:33 tarm kernel: [ 1695.413087] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 17:30:33 tarm kernel: [ 1695.413265] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 17:30:33 tarm kernel: [ 1695.413402] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:30:33 tarm kernel: [ 1695.413529] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 17:30:33 tarm kernel: [ 1695.413664] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 17:30:33 tarm kernel: [ 1695.413798] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
> May 26 17:30:33 tarm kernel: [ 1695.413929] cpufreq-core: governor: change or update limits
> May 26 17:30:33 tarm kernel: [ 1695.414056] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 17:30:51 tarm kernel: [ 1712.625338] __ratelimit: 3 messages suppressed
> May 26 17:30:51 tarm kernel: [ 1712.625566] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:30:51 tarm kernel: [ 1712.625711] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:30:51 tarm kernel: [ 1712.625863] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:30:55 tarm kernel: [ 1716.625004] __ratelimit: 11 messages suppressed
> May 26 17:30:55 tarm kernel: [ 1716.625234] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:30:58 tarm kernel: [ 1719.625020] __ratelimit: 20 messages suppressed
> May 26 17:30:58 tarm kernel: [ 1719.625245] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:31:08 tarm kernel: [ 1729.625013] __ratelimit: 20 messages suppressed
> May 26 17:31:08 tarm kernel: [ 1729.625257] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:31:08 tarm kernel: [ 1729.625405] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:31:55 tarm kernel: [ 1777.125078] __ratelimit: 33 messages suppressed
> May 26 17:31:55 tarm kernel: [ 1777.125305] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:31:55 tarm kernel: [ 1777.125462] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:31:55 tarm kernel: [ 1777.125596] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:31:55 tarm kernel: [ 1777.125733] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:31:55 tarm kernel: [ 1777.125862] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:31:55 tarm kernel: [ 1777.126989] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:31:55 tarm kernel: [ 1777.127043] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:31:56 tarm kernel: [ 1777.625029] cpufreq-core: target for CPU 0: 1257142 kHz, relation 0
> May 26 17:31:56 tarm kernel: [ 1777.625190] acpi-cpufreq: acpi_cpufreq_target 1257142 (0)
> May 26 17:32:08 tarm kernel: [ 1789.625048] __ratelimit: 12 messages suppressed
> May 26 17:32:08 tarm kernel: [ 1789.625277] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:32:08 tarm kernel: [ 1789.625420] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:32:08 tarm kernel: [ 1789.625554] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:32:27 tarm kernel: [ 1808.625076] __ratelimit: 23 messages suppressed
> May 26 17:32:27 tarm kernel: [ 1808.625314] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:32:27 tarm kernel: [ 1808.625477] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:32:27 tarm kernel: [ 1808.625611] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:32:28 tarm kernel: [ 1809.625036] __ratelimit: 11 messages suppressed
> May 26 17:32:28 tarm kernel: [ 1809.625204] cpufreq-core: target for CPU 0: 594285 kHz, relation 0
> May 26 17:32:55 tarm kernel: [ 1837.125529] __ratelimit: 6 messages suppressed
> May 26 17:32:55 tarm kernel: [ 1837.125771] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:32:55 tarm kernel: [ 1837.125927] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:32:55 tarm kernel: [ 1837.126060] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:32:55 tarm kernel: [ 1837.126220] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:32:55 tarm kernel: [ 1837.126384] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:33:08 tarm kernel: [ 1850.124998] __ratelimit: 9 messages suppressed
> May 26 17:33:08 tarm kernel: [ 1850.125223] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:33:08 tarm kernel: [ 1850.125389] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:33:08 tarm kernel: [ 1850.125546] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:33:15 tarm kernel: [ 1856.625076] __ratelimit: 11 messages suppressed
> May 26 17:33:15 tarm kernel: [ 1856.625322] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:33:22 tarm kernel: [ 1864.124999] __ratelimit: 13 messages suppressed
> May 26 17:33:22 tarm kernel: [ 1864.125220] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:33:23 tarm kernel: [ 1864.624994] __ratelimit: 6 messages suppressed
> May 26 17:33:23 tarm kernel: [ 1864.625132] cpufreq-core: target for CPU 0: 0 kHz, relation 0
> May 26 17:33:37 tarm kernel: [ 1878.625014] __ratelimit: 60 messages suppressed
> May 26 17:33:37 tarm kernel: [ 1878.625252] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:33:37 tarm kernel: [ 1878.625420] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:33:38 tarm kernel: [ 1879.624989] __ratelimit: 10 messages suppressed
> May 26 17:33:38 tarm kernel: [ 1879.625128] cpufreq-core: target for CPU 0: 228571 kHz, relation 0
> May 26 17:33:43 tarm kernel: [ 1884.626773] __ratelimit: 20 messages suppressed
> May 26 17:33:43 tarm kernel: [ 1884.626985] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:33:49 tarm kernel: [ 1891.128517] __ratelimit: 34 messages suppressed
> May 26 17:33:49 tarm kernel: [ 1891.128729] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:33:53 tarm kernel: [ 1894.624989] __ratelimit: 27 messages suppressed
> May 26 17:33:53 tarm kernel: [ 1894.625138] cpufreq-core: target for CPU 0: 914285 kHz, relation 0
> May 26 17:34:10 tarm kernel: [ 1911.625009] __ratelimit: 27 messages suppressed
> May 26 17:34:10 tarm kernel: [ 1911.625242] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:34:10 tarm kernel: [ 1911.625381] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:34:10 tarm kernel: [ 1911.625513] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:34:57 tarm kernel: [ 1959.125001] __ratelimit: 25 messages suppressed
> May 26 17:34:57 tarm kernel: [ 1959.125227] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:34:57 tarm kernel: [ 1959.125397] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:34:57 tarm kernel: [ 1959.125532] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:34:57 tarm kernel: [ 1959.125670] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:34:57 tarm kernel: [ 1959.125798] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:34:57 tarm kernel: [ 1959.125931] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:34:57 tarm kernel: [ 1959.125986] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:34:58 tarm kernel: [ 1959.624990] cpufreq-core: target for CPU 0: 1257142 kHz, relation 0
> May 26 17:34:58 tarm kernel: [ 1959.625142] acpi-cpufreq: acpi_cpufreq_target 1257142 (0)
> May 26 17:34:58 tarm kernel: [ 1959.625221] freq-table: request for target 1257142 kHz (relation: 0) for cpu 0
> May 26 17:35:03 tarm kernel: [ 1964.624997] __ratelimit: 39 messages suppressed
> May 26 17:35:03 tarm kernel: [ 1964.625162] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:35:09 tarm kernel: [ 1970.625110] __ratelimit: 34 messages suppressed
> May 26 17:35:09 tarm kernel: [ 1970.625347] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:35:13 tarm kernel: [ 1974.625010] __ratelimit: 39 messages suppressed
> May 26 17:35:13 tarm kernel: [ 1974.625164] cpufreq-core: target for CPU 0: 914285 kHz, relation 0
> May 26 17:35:18 tarm kernel: [ 1979.624990] __ratelimit: 27 messages suppressed
> May 26 17:35:18 tarm kernel: [ 1979.625150] cpufreq-core: target for CPU 0: 137142 kHz, relation 0
> May 26 17:35:23 tarm kernel: [ 1984.625099] __ratelimit: 13 messages suppressed
> May 26 17:35:23 tarm kernel: [ 1984.625242] cpufreq-core: target for CPU 0: 228571 kHz, relation 0
> May 26 17:35:28 tarm kernel: [ 1989.625013] __ratelimit: 20 messages suppressed
> May 26 17:35:28 tarm kernel: [ 1989.625247] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:35:53 tarm kernel: [ 2014.625029] __ratelimit: 13 messages suppressed
> May 26 17:35:53 tarm kernel: [ 2014.625260] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:35:53 tarm kernel: [ 2014.625408] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:35:53 tarm kernel: [ 2014.625545] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:35:53 tarm kernel: [ 2014.625688] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:35:53 tarm kernel: [ 2014.625830] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:35:58 tarm kernel: [ 2020.124991] __ratelimit: 49 messages suppressed
> May 26 17:35:58 tarm kernel: [ 2020.125144] cpufreq-core: target for CPU 0: 960000 kHz, relation 0
> May 26 17:36:04 tarm kernel: [ 2025.625733] __ratelimit: 27 messages suppressed
> May 26 17:36:04 tarm kernel: [ 2025.625970] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:36:08 tarm kernel: [ 2030.124999] __ratelimit: 27 messages suppressed
> May 26 17:36:08 tarm kernel: [ 2030.125208] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:36:45 tarm kernel: [ 2066.624998] __ratelimit: 13 messages suppressed
> May 26 17:36:45 tarm kernel: [ 2066.625471] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:36:45 tarm kernel: [ 2066.625649] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:36:45 tarm kernel: [ 2066.625789] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:36:45 tarm kernel: [ 2066.625927] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:36:45 tarm kernel: [ 2066.626087] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:36:45 tarm kernel: [ 2066.626225] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:36:45 tarm kernel: [ 2066.626279] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:36:56 tarm kernel: [ 2077.625025] __ratelimit: 21 messages suppressed
> May 26 17:36:56 tarm kernel: [ 2077.625259] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:36:56 tarm kernel: [ 2077.625402] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:37:32 tarm kernel: [ 2114.125331] __ratelimit: 12 messages suppressed
> May 26 17:37:32 tarm kernel: [ 2114.125558] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:37:32 tarm kernel: [ 2114.125703] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:37:32 tarm kernel: [ 2114.125839] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:37:32 tarm kernel: [ 2114.125978] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:37:32 tarm kernel: [ 2114.126110] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:37:32 tarm kernel: [ 2114.126249] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:37:32 tarm kernel: [ 2114.126305] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:37:33 tarm kernel: [ 2114.624991] cpufreq-core: target for CPU 0: 1771428 kHz, relation 0
> May 26 17:37:38 tarm kernel: [ 2120.125076] __ratelimit: 11 messages suppressed
> May 26 17:37:38 tarm kernel: [ 2120.125306] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:37:43 tarm kernel: [ 2124.625018] __ratelimit: 27 messages suppressed
> May 26 17:37:43 tarm kernel: [ 2124.625164] cpufreq-core: target for CPU 0: 514285 kHz, relation 0
> May 26 17:37:51 tarm kernel: [ 2133.125018] __ratelimit: 6 messages suppressed
> May 26 17:37:51 tarm kernel: [ 2133.125274] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:37:53 tarm kernel: [ 2135.124987] __ratelimit: 20 messages suppressed
> May 26 17:37:53 tarm kernel: [ 2135.125133] cpufreq-core: target for CPU 0: 400000 kHz, relation 0
> May 26 17:38:08 tarm kernel: [ 2150.125024] __ratelimit: 20 messages suppressed
> May 26 17:38:08 tarm kernel: [ 2150.125263] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:38:08 tarm kernel: [ 2150.125406] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:38:08 tarm kernel: [ 2150.125541] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:38:44 tarm kernel: [ 2186.125030] __ratelimit: 39 messages suppressed
> May 26 17:38:44 tarm kernel: [ 2186.125274] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:38:44 tarm kernel: [ 2186.125419] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:38:44 tarm kernel: [ 2186.125554] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:38:44 tarm kernel: [ 2186.125692] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:38:44 tarm kernel: [ 2186.125950] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:38:44 tarm kernel: [ 2186.126086] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:38:44 tarm kernel: [ 2186.126140] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:39:42 tarm kernel: [ 2244.125003] __ratelimit: 7 messages suppressed
> May 26 17:39:42 tarm kernel: [ 2244.125386] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:39:42 tarm kernel: [ 2244.125533] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:39:42 tarm kernel: [ 2244.125668] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:39:42 tarm kernel: [ 2244.125805] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:39:42 tarm kernel: [ 2244.125933] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:39:42 tarm kernel: [ 2244.126067] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:39:42 tarm kernel: [ 2244.126122] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:39:43 tarm kernel: [ 2244.624993] cpufreq-core: target for CPU 0: 1142857 kHz, relation 0
> May 26 17:39:43 tarm kernel: [ 2244.625151] acpi-cpufreq: acpi_cpufreq_target 1142857 (0)
> May 26 17:39:43 tarm kernel: [ 2244.625231] freq-table: request for target 1142857 kHz (relation: 0) for cpu 0
> May 26 17:39:47 tarm kernel: [ 2249.124999] __ratelimit: 11 messages suppressed
> May 26 17:39:47 tarm kernel: [ 2249.125216] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:39:55 tarm kernel: [ 2257.125017] __ratelimit: 27 messages suppressed
> May 26 17:39:55 tarm kernel: [ 2257.125257] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:39:57 tarm kernel: [ 2259.124988] __ratelimit: 20 messages suppressed
> May 26 17:39:57 tarm kernel: [ 2259.125137] cpufreq-core: target for CPU 0: 342857 kHz, relation 0
> May 26 17:40:03 tarm kernel: [ 2264.625779] __ratelimit: 6 messages suppressed
> May 26 17:40:03 tarm kernel: [ 2264.626008] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:40:08 tarm kernel: [ 2269.625005] __ratelimit: 13 messages suppressed
> May 26 17:40:08 tarm kernel: [ 2269.625224] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:40:16 tarm kernel: [ 2277.625001] __ratelimit: 13 messages suppressed
> May 26 17:40:16 tarm kernel: [ 2277.625225] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:40:57 tarm kernel: [ 2318.625170] __ratelimit: 13 messages suppressed
> May 26 17:40:57 tarm kernel: [ 2318.625402] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:40:57 tarm kernel: [ 2318.625545] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:40:57 tarm kernel: [ 2318.625680] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:40:57 tarm kernel: [ 2318.625833] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:40:57 tarm kernel: [ 2318.625962] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:40:57 tarm kernel: [ 2318.626095] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:40:57 tarm kernel: [ 2318.626149] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:40:57 tarm kernel: [ 2319.124990] cpufreq-core: target for CPU 0: 400000 kHz, relation 0
> May 26 17:40:57 tarm kernel: [ 2319.125141] acpi-cpufreq: acpi_cpufreq_target 400000 (0)
> May 26 17:41:07 tarm kernel: [ 2329.125011] __ratelimit: 5 messages suppressed
> May 26 17:41:07 tarm kernel: [ 2329.125242] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:41:07 tarm kernel: [ 2329.125381] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:41:13 tarm kernel: [ 2334.625002] __ratelimit: 33 messages suppressed
> May 26 17:41:13 tarm kernel: [ 2334.625220] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:41:19 tarm kernel: [ 2340.625925] __ratelimit: 27 messages suppressed
> May 26 17:41:19 tarm kernel: [ 2340.626164] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:41:22 tarm kernel: [ 2344.125010] __ratelimit: 27 messages suppressed
> May 26 17:41:22 tarm kernel: [ 2344.125242] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:42:05 tarm kernel: [ 2386.625014] __ratelimit: 41 messages suppressed
> May 26 17:42:05 tarm kernel: [ 2386.625238] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:42:05 tarm kernel: [ 2386.625411] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:42:05 tarm kernel: [ 2386.625548] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:42:05 tarm kernel: [ 2386.625689] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:42:05 tarm kernel: [ 2386.625818] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:42:05 tarm kernel: [ 2386.626082] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:42:05 tarm kernel: [ 2386.626137] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:42:05 tarm kernel: [ 2387.124995] cpufreq-core: target for CPU 0: 114285 kHz, relation 0
> May 26 17:42:23 tarm kernel: [ 2405.126157] __ratelimit: 6 messages suppressed
> May 26 17:42:23 tarm kernel: [ 2405.126390] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:42:23 tarm kernel: [ 2405.126536] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:42:23 tarm kernel: [ 2405.126671] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:42:23 tarm kernel: [ 2405.126810] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:42:27 tarm kernel: [ 2409.124997] __ratelimit: 31 messages suppressed
> May 26 17:42:27 tarm kernel: [ 2409.125156] cpufreq-core: target for CPU 0: 960000 kHz, relation 0
> May 26 17:42:57 tarm kernel: [ 2439.125015] __ratelimit: 13 messages suppressed
> May 26 17:42:57 tarm kernel: [ 2439.125247] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:42:57 tarm kernel: [ 2439.125392] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:42:57 tarm kernel: [ 2439.125526] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:42:57 tarm kernel: [ 2439.125664] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:42:57 tarm kernel: [ 2439.125792] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:42:57 tarm kernel: [ 2439.125926] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:44:08 tarm kernel: [ 2509.627811] __ratelimit: 15 messages suppressed
> May 26 17:44:08 tarm kernel: [ 2509.628028] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:44:08 tarm kernel: [ 2509.628172] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:44:08 tarm kernel: [ 2509.628479] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:44:08 tarm kernel: [ 2509.628623] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:44:08 tarm kernel: [ 2509.628782] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:44:08 tarm kernel: [ 2509.628934] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:44:08 tarm kernel: [ 2509.629114] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:44:08 tarm kernel: [ 2510.128990] cpufreq-core: target for CPU 0: 1200000 kHz, relation 0
> May 26 17:44:08 tarm kernel: [ 2510.129147] acpi-cpufreq: acpi_cpufreq_target 1200000 (0)
> May 26 17:44:08 tarm kernel: [ 2510.129225] freq-table: request for target 1200000 kHz (relation: 0) for cpu 0
> May 26 17:45:53 tarm kernel: [ 2614.625003] __ratelimit: 11 messages suppressed
> May 26 17:45:53 tarm kernel: [ 2614.625214] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:45:53 tarm kernel: [ 2614.625359] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:45:53 tarm kernel: [ 2614.625497] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:45:53 tarm kernel: [ 2614.625638] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:45:53 tarm kernel: [ 2614.625773] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:45:53 tarm kernel: [ 2614.625914] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:45:53 tarm kernel: [ 2614.625971] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:45:53 tarm kernel: [ 2615.124994] cpufreq-core: target for CPU 0: 0 kHz, relation 0
> May 26 17:45:53 tarm kernel: [ 2615.125153] acpi-cpufreq: acpi_cpufreq_target 0 (0)
> May 26 17:45:53 tarm kernel: [ 2615.125213] freq-table: request for target 0 kHz (relation: 0) for cpu 0
> May 26 17:45:58 tarm kernel: [ 2620.125038] __ratelimit: 4 messages suppressed
> May 26 17:45:58 tarm kernel: [ 2620.125262] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:46:30 tarm kernel: [ 2652.125063] __ratelimit: 13 messages suppressed
> May 26 17:46:30 tarm kernel: [ 2652.125294] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:46:30 tarm kernel: [ 2652.125434] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:46:30 tarm kernel: [ 2652.125566] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:46:30 tarm kernel: [ 2652.125702] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:46:30 tarm kernel: [ 2652.125831] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:46:30 tarm kernel: [ 2652.125965] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:47:03 tarm kernel: [ 2684.630045] __ratelimit: 8 messages suppressed
> May 26 17:47:03 tarm kernel: [ 2684.630290] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:47:03 tarm kernel: [ 2684.630432] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:47:03 tarm kernel: [ 2684.630565] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:47:03 tarm kernel: [ 2684.630702] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:47:03 tarm kernel: [ 2684.630832] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:47:03 tarm kernel: [ 2684.630968] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:47:03 tarm kernel: [ 2684.631023] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:47:24 tarm kernel: [ 2706.124999] __ratelimit: 7 messages suppressed
> May 26 17:47:24 tarm kernel: [ 2706.125221] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:47:24 tarm kernel: [ 2706.125385] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:47:24 tarm kernel: [ 2706.125520] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:47:24 tarm kernel: [ 2706.125658] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:47:58 tarm kernel: [ 2740.124998] __ratelimit: 10 messages suppressed
> May 26 17:47:58 tarm kernel: [ 2740.125220] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:47:58 tarm kernel: [ 2740.125409] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:47:58 tarm kernel: [ 2740.125545] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:47:58 tarm kernel: [ 2740.125683] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:47:58 tarm kernel: [ 2740.125811] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:47:58 tarm kernel: [ 2740.125946] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:47:58 tarm kernel: [ 2740.126000] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:48:09 tarm kernel: [ 2751.125047] __ratelimit: 21 messages suppressed
> May 26 17:48:09 tarm kernel: [ 2751.125269] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:48:09 tarm kernel: [ 2751.125434] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:48:58 tarm kernel: [ 2800.125099] __ratelimit: 33 messages suppressed
> May 26 17:48:58 tarm kernel: [ 2800.125338] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:48:58 tarm kernel: [ 2800.125482] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:48:58 tarm kernel: [ 2800.125617] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:48:58 tarm kernel: [ 2800.125756] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:48:58 tarm kernel: [ 2800.125886] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:48:58 tarm kernel: [ 2800.126021] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:48:58 tarm kernel: [ 2800.126075] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:48:59 tarm kernel: [ 2801.124990] cpufreq-core: target for CPU 0: 285714 kHz, relation 0
> May 26 17:48:59 tarm kernel: [ 2801.125146] acpi-cpufreq: acpi_cpufreq_target 285714 (0)
> May 26 17:48:59 tarm kernel: [ 2801.125221] freq-table: request for target 285714 kHz (relation: 0) for cpu 0
> May 26 17:49:05 tarm kernel: [ 2806.625051] __ratelimit: 4 messages suppressed
> May 26 17:49:05 tarm kernel: [ 2806.625274] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:49:36 tarm kernel: [ 2837.625751] __ratelimit: 13 messages suppressed
> May 26 17:49:36 tarm kernel: [ 2837.625989] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:49:36 tarm kernel: [ 2837.626134] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:49:36 tarm kernel: [ 2837.626432] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:49:36 tarm kernel: [ 2837.626578] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:49:36 tarm kernel: [ 2837.626711] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:49:36 tarm kernel: [ 2837.626849] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:49:48 tarm kernel: [ 2850.125068] __ratelimit: 8 messages suppressed
> May 26 17:49:48 tarm kernel: [ 2850.125309] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:49:48 tarm kernel: [ 2850.125449] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:49:48 tarm kernel: [ 2850.125581] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:50:37 tarm kernel: [ 2898.625001] __ratelimit: 11 messages suppressed
> May 26 17:50:37 tarm kernel: [ 2898.625247] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:50:37 tarm kernel: [ 2898.625393] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:50:37 tarm kernel: [ 2898.625543] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:50:37 tarm kernel: [ 2898.625682] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:50:37 tarm kernel: [ 2898.625811] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:50:37 tarm kernel: [ 2898.625945] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:50:37 tarm kernel: [ 2898.625999] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:50:37 tarm kernel: [ 2899.124989] cpufreq-core: target for CPU 0: 0 kHz, relation 0
> May 26 17:50:37 tarm kernel: [ 2899.125144] acpi-cpufreq: acpi_cpufreq_target 0 (0)
> May 26 17:51:20 tarm kernel: [ 2941.625016] __ratelimit: 5 messages suppressed
> May 26 17:51:20 tarm kernel: [ 2941.625237] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:51:20 tarm kernel: [ 2941.625406] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:51:20 tarm kernel: [ 2941.625546] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:51:20 tarm kernel: [ 2941.625689] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:51:20 tarm kernel: [ 2941.625824] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:51:20 tarm kernel: [ 2941.626027] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:51:20 tarm kernel: [ 2941.626285] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:51:20 tarm kernel: [ 2942.124990] cpufreq-core: target for CPU 0: 1085714 kHz, relation 0
> May 26 17:51:20 tarm kernel: [ 2942.125146] acpi-cpufreq: acpi_cpufreq_target 1085714 (0)
> May 26 17:51:23 tarm kernel: [ 2945.124994] __ratelimit: 31 messages suppressed
> May 26 17:51:23 tarm kernel: [ 2945.125180] cpufreq-core: target for CPU 0: 944171 kHz, relation 0
> May 26 17:51:28 tarm kernel: [ 2950.124996] __ratelimit: 37 messages suppressed
> May 26 17:51:28 tarm kernel: [ 2950.125182] cpufreq-core: target for CPU 0: 852800 kHz, relation 0
> May 26 17:51:55 tarm kernel: [ 2977.125010] __ratelimit: 26 messages suppressed
> May 26 17:51:55 tarm kernel: [ 2977.125244] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:51:55 tarm kernel: [ 2977.125384] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:51:55 tarm kernel: [ 2977.125516] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:51:55 tarm kernel: [ 2977.125652] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:51:55 tarm kernel: [ 2977.125806] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:51:58 tarm kernel: [ 2980.125002] __ratelimit: 30 messages suppressed
> May 26 17:51:58 tarm kernel: [ 2980.125197] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:52:03 tarm kernel: [ 2984.753859] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 17:52:03 tarm kernel: [ 2984.754110] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:52:03 tarm kernel: [ 2984.754246] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 17:52:03 tarm kernel: [ 2984.754387] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 17:52:03 tarm kernel: [ 2984.754526] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:52:03 tarm kernel: [ 2984.754657] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
> May 26 17:52:03 tarm kernel: [ 2984.754935] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
> May 26 17:52:03 tarm kernel: [ 2984.755073] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
> May 26 17:52:03 tarm kernel: [ 2984.755208] cpufreq-core: governor: change or update limits
> May 26 17:52:03 tarm kernel: [ 2984.755339] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 17:52:15 tarm kernel: [ 2997.184583] __ratelimit: 39 messages suppressed
> May 26 17:52:15 tarm kernel: [ 2997.184789] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
> May 26 17:52:15 tarm kernel: [ 2997.185072] cpufreq-core: updating policy for CPU 0
> May 26 17:52:15 tarm kernel: [ 2997.185310] acpi-cpufreq: get_cur_freq_on_cpu (0)
> May 26 17:52:15 tarm kernel: [ 2997.185448] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 17:52:15 tarm kernel: [ 2997.185583] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:52:15 tarm kernel: [ 2997.185710] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 17:52:15 tarm kernel: [ 2997.185846] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 17:52:15 tarm kernel: [ 2997.186002] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:52:15 tarm kernel: [ 2997.186153] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 17:52:15 tarm kernel: [ 2997.186289] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 17:52:15 tarm kernel: [ 2997.186423] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
> May 26 17:52:15 tarm kernel: [ 2997.186555] cpufreq-core: governor: change or update limits
> May 26 17:52:15 tarm kernel: [ 2997.186682] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 17:53:50 tarm kernel: [ 3091.625021] __ratelimit: 2 messages suppressed
> May 26 17:53:50 tarm kernel: [ 3091.625236] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:53:50 tarm kernel: [ 3091.625380] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:53:50 tarm kernel: [ 3091.625514] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:53:50 tarm kernel: [ 3091.625653] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:53:50 tarm kernel: [ 3091.625785] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:53:50 tarm kernel: [ 3091.626086] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:53:50 tarm kernel: [ 3091.626142] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:53:50 tarm kernel: [ 3092.124989] cpufreq-core: target for CPU 0: 171428 kHz, relation 0
> May 26 17:53:50 tarm kernel: [ 3092.125141] acpi-cpufreq: acpi_cpufreq_target 171428 (0)
> May 26 17:53:50 tarm kernel: [ 3092.125227] freq-table: request for target 171428 kHz (relation: 0) for cpu 0
> May 26 17:54:23 tarm kernel: [ 3125.125835] __ratelimit: 4 messages suppressed
> May 26 17:54:23 tarm kernel: [ 3125.126073] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:54:23 tarm kernel: [ 3125.126214] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:54:23 tarm kernel: [ 3125.126374] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:54:23 tarm kernel: [ 3125.126511] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:54:23 tarm kernel: [ 3125.126639] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:54:23 tarm kernel: [ 3125.126772] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:54:25 tarm kernel: [ 3126.625001] __ratelimit: 15 messages suppressed
> May 26 17:54:25 tarm kernel: [ 3126.625156] cpufreq-core: target for CPU 0: 1600000 kHz, relation 0
> May 26 17:54:59 tarm kernel: [ 3161.125068] __ratelimit: 13 messages suppressed
> May 26 17:54:59 tarm kernel: [ 3161.125422] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:54:59 tarm kernel: [ 3161.125563] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:54:59 tarm kernel: [ 3161.125695] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:54:59 tarm kernel: [ 3161.125831] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:54:59 tarm kernel: [ 3161.125960] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:54:59 tarm kernel: [ 3161.126189] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:55:00 tarm kernel: [ 3161.624989] __ratelimit: 1 messages suppressed
> May 26 17:55:00 tarm kernel: [ 3161.625138] cpufreq-core: target for CPU 0: 628571 kHz, relation 0
> May 26 17:57:59 tarm kernel: [ 3341.125000] __ratelimit: 20 messages suppressed
> May 26 17:57:59 tarm kernel: [ 3341.125237] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:57:59 tarm kernel: [ 3341.125407] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:57:59 tarm kernel: [ 3341.125542] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:57:59 tarm kernel: [ 3341.125680] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:57:59 tarm kernel: [ 3341.125808] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:57:59 tarm kernel: [ 3341.125941] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 17:57:59 tarm kernel: [ 3341.126003] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 17:58:00 tarm kernel: [ 3342.124989] cpufreq-core: target for CPU 0: 0 kHz, relation 0
> May 26 17:58:00 tarm kernel: [ 3342.125176] acpi-cpufreq: acpi_cpufreq_target 0 (0)
> May 26 17:58:00 tarm kernel: [ 3342.125238] freq-table: request for target 0 kHz (relation: 0) for cpu 0
> May 26 17:58:09 tarm kernel: [ 3350.625020] __ratelimit: 4 messages suppressed
> May 26 17:58:09 tarm kernel: [ 3350.625222] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:58:11 tarm kernel: [ 3353.124988] __ratelimit: 6 messages suppressed
> May 26 17:58:11 tarm kernel: [ 3353.125210] cpufreq-core: target for CPU 0: 1600000 kHz, relation 0
> May 26 17:58:16 tarm kernel: [ 3357.625011] __ratelimit: 13 messages suppressed
> May 26 17:58:16 tarm kernel: [ 3357.625238] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:58:20 tarm kernel: [ 3361.625052] __ratelimit: 39 messages suppressed
> May 26 17:58:20 tarm kernel: [ 3361.625267] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:58:24 tarm kernel: [ 3366.125013] __ratelimit: 48 messages suppressed
> May 26 17:58:24 tarm kernel: [ 3366.125240] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:58:27 tarm kernel: [ 3368.864167] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 17:58:27 tarm kernel: [ 3368.864411] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:58:27 tarm kernel: [ 3368.864544] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 17:58:27 tarm kernel: [ 3368.864681] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 17:58:27 tarm kernel: [ 3368.864816] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:58:27 tarm kernel: [ 3368.864944] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
> May 26 17:58:27 tarm kernel: [ 3368.865130] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
> May 26 17:58:27 tarm kernel: [ 3368.865297] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
> May 26 17:58:27 tarm kernel: [ 3368.865433] cpufreq-core: governor: change or update limits
> May 26 17:58:27 tarm kernel: [ 3368.865564] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 17:58:43 tarm kernel: [ 3385.479447] __ratelimit: 30 messages suppressed
> May 26 17:58:43 tarm kernel: [ 3385.479651] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
> May 26 17:58:43 tarm kernel: [ 3385.479810] cpufreq-core: updating policy for CPU 0
> May 26 17:58:43 tarm kernel: [ 3385.479938] acpi-cpufreq: get_cur_freq_on_cpu (0)
> May 26 17:58:43 tarm kernel: [ 3385.480067] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 17:58:43 tarm kernel: [ 3385.480199] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:58:43 tarm kernel: [ 3385.480325] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 17:58:43 tarm kernel: [ 3385.480459] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 17:58:43 tarm kernel: [ 3385.480591] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:58:43 tarm kernel: [ 3385.480716] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 17:58:43 tarm kernel: [ 3385.480850] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 17:58:43 tarm kernel: [ 3385.481074] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
> May 26 17:58:43 tarm kernel: [ 3385.481231] cpufreq-core: governor: change or update limits
> May 26 17:58:43 tarm kernel: [ 3385.481361] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 17:59:07 tarm kernel: [ 3408.625001] __ratelimit: 2 messages suppressed
> May 26 17:59:07 tarm kernel: [ 3408.625221] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:59:07 tarm kernel: [ 3408.625385] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:59:07 tarm kernel: [ 3408.625519] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:59:07 tarm kernel: [ 3408.625677] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:59:07 tarm kernel: [ 3408.625803] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:59:10 tarm kernel: [ 3411.625026] __ratelimit: 9 messages suppressed
> May 26 17:59:10 tarm kernel: [ 3411.625265] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:59:36 tarm kernel: [ 3438.125078] __ratelimit: 13 messages suppressed
> May 26 17:59:36 tarm kernel: [ 3438.125317] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:59:36 tarm kernel: [ 3438.125536] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 17:59:36 tarm kernel: [ 3438.125667] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 17:59:36 tarm kernel: [ 3438.125799] freq-table: target is 0 (2000000 kHz, 0)
> May 26 17:59:36 tarm kernel: [ 3438.127191] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 17:59:39 tarm kernel: [ 3441.125011] __ratelimit: 16 messages suppressed
> May 26 17:59:39 tarm kernel: [ 3441.125163] cpufreq-core: target for CPU 0: 571428 kHz, relation 0
> May 26 17:59:44 tarm kernel: [ 3446.129064] __ratelimit: 51 messages suppressed
> May 26 17:59:44 tarm kernel: [ 3446.129319] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 17:59:50 tarm kernel: [ 3451.625003] __ratelimit: 39 messages suppressed
> May 26 17:59:50 tarm kernel: [ 3451.625174] cpufreq-core: target for CPU 0: 1142857 kHz, relation 0
> May 26 17:59:54 tarm kernel: [ 3456.079363] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 17:59:54 tarm kernel: [ 3456.079519] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:59:54 tarm kernel: [ 3456.079577] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 17:59:54 tarm kernel: [ 3456.079647] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 17:59:54 tarm kernel: [ 3456.079707] acpi-cpufreq: acpi_cpufreq_verify
> May 26 17:59:54 tarm kernel: [ 3456.079762] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
> May 26 17:59:54 tarm kernel: [ 3456.079821] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
> May 26 17:59:54 tarm kernel: [ 3456.079879] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
> May 26 17:59:54 tarm kernel: [ 3456.079936] cpufreq-core: governor: change or update limits
> May 26 17:59:54 tarm kernel: [ 3456.079992] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 17:59:54 tarm kernel: [ 3456.080058] cpufreq-core: target for CPU 0: 800000 kHz, relation 1
> May 26 17:59:54 tarm kernel: [ 3456.080114] acpi-cpufreq: acpi_cpufreq_target 800000 (0)
> May 26 17:59:54 tarm kernel: [ 3456.080196] freq-table: request for target 800000 kHz (relation: 1) for cpu 0
> May 26 17:59:54 tarm kernel: [ 3456.080254] freq-table: target is 4 (800000 kHz, 4)
> May 26 17:59:54 tarm kernel: [ 3456.080310] cpufreq-core: notification 0 of frequency transition to 800000 kHz
> May 26 17:59:54 tarm kernel: [ 3456.080385] cpufreq-core: notification 1 of frequency transition to 800000 kHz
> May 26 17:59:54 tarm kernel: [ 3456.080439] cpufreq-core: scaling loops_per_jiffy to 3195449 for frequency 800000 kHz
> May 26 18:02:15 tarm kernel: [ 3597.291132] __ratelimit: 39 messages suppressed
> May 26 18:02:15 tarm kernel: [ 3597.291342] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
> May 26 18:02:15 tarm kernel: [ 3597.291480] cpufreq-core: updating policy for CPU 0
> May 26 18:02:15 tarm kernel: [ 3597.291608] acpi-cpufreq: get_cur_freq_on_cpu (0)
> May 26 18:02:15 tarm kernel: [ 3597.291734] acpi-cpufreq: get_cur_val = 100664850
> May 26 18:02:15 tarm kernel: [ 3597.291859] acpi-cpufreq: cur freq = 800000
> May 26 18:02:15 tarm kernel: [ 3597.291984] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 18:02:15 tarm kernel: [ 3597.292116] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:02:15 tarm kernel: [ 3597.292241] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 18:02:15 tarm kernel: [ 3597.292377] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 18:02:15 tarm kernel: [ 3597.292546] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:02:15 tarm kernel: [ 3597.292675] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 18:02:15 tarm kernel: [ 3597.292812] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 18:02:15 tarm kernel: [ 3597.293470] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
> May 26 18:02:15 tarm kernel: [ 3597.293635] cpufreq-core: governor: change or update limits
> May 26 18:02:15 tarm kernel: [ 3597.293768] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 18:02:17 tarm kernel: [ 3598.625022] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:02:17 tarm kernel: [ 3598.625266] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 18:02:17 tarm kernel: [ 3598.625404] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 18:02:17 tarm kernel: [ 3598.625541] freq-table: target is 0 (2000000 kHz, 0)
> May 26 18:02:17 tarm kernel: [ 3598.625671] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 18:02:21 tarm kernel: [ 3602.625004] __ratelimit: 28 messages suppressed
> May 26 18:02:21 tarm kernel: [ 3602.625238] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:02:26 tarm kernel: [ 3607.627568] __ratelimit: 39 messages suppressed
> May 26 18:02:26 tarm kernel: [ 3607.627787] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:02:28 tarm kernel: [ 3609.767385] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 18:02:28 tarm kernel: [ 3609.767625] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:02:28 tarm kernel: [ 3609.767757] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 18:02:28 tarm kernel: [ 3609.767895] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 18:02:28 tarm kernel: [ 3609.768031] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:02:28 tarm kernel: [ 3609.768158] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
> May 26 18:02:28 tarm kernel: [ 3609.768294] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
> May 26 18:02:28 tarm kernel: [ 3609.768429] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
> May 26 18:02:28 tarm kernel: [ 3609.768561] cpufreq-core: governor: change or update limits
> May 26 18:02:28 tarm kernel: [ 3609.768689] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 18:04:20 tarm kernel: [ 3721.943273] __ratelimit: 18 messages suppressed
> May 26 18:04:20 tarm kernel: [ 3721.943484] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
> May 26 18:04:20 tarm kernel: [ 3721.943624] cpufreq-core: updating policy for CPU 0
> May 26 18:04:20 tarm kernel: [ 3721.943754] acpi-cpufreq: get_cur_freq_on_cpu (0)
> May 26 18:04:20 tarm kernel: [ 3721.943883] acpi-cpufreq: get_cur_val = 100664850
> May 26 18:04:20 tarm kernel: [ 3721.944010] acpi-cpufreq: cur freq = 800000
> May 26 18:04:20 tarm kernel: [ 3721.944137] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 18:04:20 tarm kernel: [ 3721.944271] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:04:20 tarm kernel: [ 3721.944418] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 18:04:20 tarm kernel: [ 3721.944556] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 18:04:20 tarm kernel: [ 3721.944691] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:04:20 tarm kernel: [ 3721.944818] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 18:04:20 tarm kernel: [ 3721.945412] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 18:04:20 tarm kernel: [ 3721.945579] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
> May 26 18:04:20 tarm kernel: [ 3721.945714] cpufreq-core: governor: change or update limits
> May 26 18:04:20 tarm kernel: [ 3721.945845] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 18:04:29 tarm kernel: [ 3730.625003] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:04:29 tarm kernel: [ 3730.625247] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 18:04:29 tarm kernel: [ 3730.625405] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 18:04:29 tarm kernel: [ 3730.625545] freq-table: target is 0 (2000000 kHz, 0)
> May 26 18:04:29 tarm kernel: [ 3730.625674] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 18:04:29 tarm kernel: [ 3730.625808] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 18:04:30 tarm kernel: [ 3732.125001] __ratelimit: 8 messages suppressed
> May 26 18:04:30 tarm kernel: [ 3732.125223] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:05:01 tarm kernel: [ 3762.625004] __ratelimit: 27 messages suppressed
> May 26 18:05:01 tarm kernel: [ 3762.625230] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:05:01 tarm kernel: [ 3762.625371] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 18:05:01 tarm kernel: [ 3762.625503] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 18:05:01 tarm kernel: [ 3762.625639] freq-table: target is 0 (2000000 kHz, 0)
> May 26 18:05:01 tarm kernel: [ 3762.625767] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 18:05:01 tarm kernel: [ 3762.625996] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 18:05:05 tarm kernel: [ 3767.125001] __ratelimit: 34 messages suppressed
> May 26 18:05:05 tarm kernel: [ 3767.125153] cpufreq-core: target for CPU 0: 457142 kHz, relation 0
> May 26 18:05:11 tarm kernel: [ 3772.625012] __ratelimit: 53 messages suppressed
> May 26 18:05:11 tarm kernel: [ 3772.625165] cpufreq-core: target for CPU 0: 685714 kHz, relation 0
> May 26 18:05:14 tarm kernel: [ 3775.942575] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 18:05:14 tarm kernel: [ 3775.942722] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:05:14 tarm kernel: [ 3775.942782] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 18:05:14 tarm kernel: [ 3775.942844] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 18:05:14 tarm kernel: [ 3775.942905] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:05:14 tarm kernel: [ 3775.942961] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
> May 26 18:05:14 tarm kernel: [ 3775.943022] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
> May 26 18:05:14 tarm kernel: [ 3775.943082] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
> May 26 18:05:14 tarm kernel: [ 3775.943140] cpufreq-core: governor: change or update limits
> May 26 18:05:14 tarm kernel: [ 3775.943197] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 18:05:14 tarm kernel: [ 3775.943255] cpufreq-core: target for CPU 0: 800000 kHz, relation 1
> May 26 18:05:14 tarm kernel: [ 3775.943311] acpi-cpufreq: acpi_cpufreq_target 800000 (0)
> May 26 18:05:14 tarm kernel: [ 3775.943369] freq-table: request for target 800000 kHz (relation: 1) for cpu 0
> May 26 18:05:14 tarm kernel: [ 3775.943428] freq-table: target is 4 (800000 kHz, 4)
> May 26 18:05:14 tarm kernel: [ 3775.943485] cpufreq-core: notification 0 of frequency transition to 800000 kHz
> May 26 18:05:14 tarm kernel: [ 3775.943546] cpufreq-core: notification 1 of frequency transition to 800000 kHz
> May 26 18:05:14 tarm kernel: [ 3775.943599] cpufreq-core: scaling loops_per_jiffy to 3195449 for frequency 800000 kHz
> May 26 18:07:00 tarm kernel: [ 3881.874163] __ratelimit: 44 messages suppressed
> May 26 18:07:00 tarm kernel: [ 3881.874373] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
> May 26 18:07:00 tarm kernel: [ 3881.874512] cpufreq-core: updating policy for CPU 0
> May 26 18:07:00 tarm kernel: [ 3881.874642] acpi-cpufreq: get_cur_freq_on_cpu (0)
> May 26 18:07:00 tarm kernel: [ 3881.874770] acpi-cpufreq: get_cur_val = 100664850
> May 26 18:07:00 tarm kernel: [ 3881.874896] acpi-cpufreq: cur freq = 800000
> May 26 18:07:00 tarm kernel: [ 3881.875047] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 18:07:00 tarm kernel: [ 3881.875182] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:07:00 tarm kernel: [ 3881.875310] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 18:07:00 tarm kernel: [ 3881.875447] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 18:07:00 tarm kernel: [ 3881.875583] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:07:00 tarm kernel: [ 3881.875710] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 18:07:00 tarm kernel: [ 3881.875847] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 18:07:00 tarm kernel: [ 3881.875982] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
> May 26 18:07:00 tarm kernel: [ 3881.876115] cpufreq-core: governor: change or update limits
> May 26 18:07:00 tarm kernel: [ 3881.876243] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 18:07:01 tarm kernel: [ 3882.625011] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:07:01 tarm kernel: [ 3882.625258] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 18:07:01 tarm kernel: [ 3882.625399] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 18:07:01 tarm kernel: [ 3882.625541] freq-table: target is 0 (2000000 kHz, 0)
> May 26 18:07:01 tarm kernel: [ 3882.625675] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 18:07:18 tarm kernel: [ 3899.625001] __ratelimit: 16 messages suppressed
> May 26 18:07:18 tarm kernel: [ 3899.625229] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:07:18 tarm kernel: [ 3899.625400] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 18:07:18 tarm kernel: [ 3899.625536] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 18:09:01 tarm kernel: [ 4003.125000] __ratelimit: 11 messages suppressed
> May 26 18:09:01 tarm kernel: [ 4003.125219] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:09:01 tarm kernel: [ 4003.125383] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 18:09:01 tarm kernel: [ 4003.125518] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 18:09:01 tarm kernel: [ 4003.125655] freq-table: target is 0 (2000000 kHz, 0)
> May 26 18:09:01 tarm kernel: [ 4003.125785] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 18:09:01 tarm kernel: [ 4003.125920] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 18:09:01 tarm kernel: [ 4003.125974] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 18:09:02 tarm kernel: [ 4003.624990] cpufreq-core: target for CPU 0: 457142 kHz, relation 0
> May 26 18:09:02 tarm kernel: [ 4003.625144] acpi-cpufreq: acpi_cpufreq_target 457142 (0)
> May 26 18:09:02 tarm kernel: [ 4003.625219] freq-table: request for target 457142 kHz (relation: 0) for cpu 0
> May 26 18:09:13 tarm kernel: [ 4014.625002] __ratelimit: 4 messages suppressed
> May 26 18:09:13 tarm kernel: [ 4014.625228] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:09:13 tarm kernel: [ 4014.625394] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 18:09:47 tarm kernel: [ 4048.625002] __ratelimit: 19 messages suppressed
> May 26 18:09:47 tarm kernel: [ 4048.625223] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:09:47 tarm kernel: [ 4048.625389] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 18:09:47 tarm kernel: [ 4048.625524] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 18:09:47 tarm kernel: [ 4048.625661] freq-table: target is 0 (2000000 kHz, 0)
> May 26 18:09:47 tarm kernel: [ 4048.625791] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 18:09:47 tarm kernel: [ 4048.625926] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 18:09:47 tarm kernel: [ 4048.625990] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 18:09:52 tarm kernel: [ 4053.626605] __ratelimit: 33 messages suppressed
> May 26 18:09:52 tarm kernel: [ 4053.626791] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:09:58 tarm kernel: [ 4060.133318] __ratelimit: 20 messages suppressed
> May 26 18:09:58 tarm kernel: [ 4060.133559] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:10:01 tarm kernel: [ 4063.125021] __ratelimit: 13 messages suppressed
> May 26 18:10:01 tarm kernel: [ 4063.125262] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:10:06 tarm kernel: [ 4068.125460] __ratelimit: 13 messages suppressed
> May 26 18:10:06 tarm kernel: [ 4068.125699] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:10:12 tarm kernel: [ 4074.125037] __ratelimit: 20 messages suppressed
> May 26 18:10:12 tarm kernel: [ 4074.125255] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:10:18 tarm kernel: [ 4079.626878] __ratelimit: 13 messages suppressed
> May 26 18:10:18 tarm kernel: [ 4079.627098] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:10:24 tarm kernel: [ 4086.133059] __ratelimit: 20 messages suppressed
> May 26 18:10:24 tarm kernel: [ 4086.133274] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:10:27 tarm kernel: [ 4088.624999] __ratelimit: 11 messages suppressed
> May 26 18:10:27 tarm kernel: [ 4088.625151] cpufreq-core: target for CPU 0: 1142857 kHz, relation 0
> May 26 18:10:32 tarm kernel: [ 4093.625002] __ratelimit: 27 messages suppressed
> May 26 18:10:32 tarm kernel: [ 4093.625227] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:10:34 tarm kernel: [ 4095.755272] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 18:10:34 tarm kernel: [ 4095.755508] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:10:34 tarm kernel: [ 4095.755642] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 18:10:34 tarm kernel: [ 4095.755780] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 18:10:34 tarm kernel: [ 4095.755916] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:10:34 tarm kernel: [ 4095.756042] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
> May 26 18:10:34 tarm kernel: [ 4095.756179] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
> May 26 18:10:34 tarm kernel: [ 4095.756314] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
> May 26 18:10:34 tarm kernel: [ 4095.756447] cpufreq-core: governor: change or update limits
> May 26 18:10:34 tarm kernel: [ 4095.756575] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 18:12:34 tarm kernel: [ 4216.175207] __ratelimit: 39 messages suppressed
> May 26 18:12:34 tarm kernel: [ 4216.175414] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
> May 26 18:12:34 tarm kernel: [ 4216.175553] cpufreq-core: updating policy for CPU 0
> May 26 18:12:34 tarm kernel: [ 4216.175682] acpi-cpufreq: get_cur_freq_on_cpu (0)
> May 26 18:12:34 tarm kernel: [ 4216.175809] acpi-cpufreq: get_cur_val = 100664850
> May 26 18:12:34 tarm kernel: [ 4216.175936] acpi-cpufreq: cur freq = 800000
> May 26 18:12:34 tarm kernel: [ 4216.176061] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
> May 26 18:12:34 tarm kernel: [ 4216.176194] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:12:34 tarm kernel: [ 4216.176322] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 18:12:34 tarm kernel: [ 4216.176458] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 18:12:34 tarm kernel: [ 4216.176592] acpi-cpufreq: acpi_cpufreq_verify
> May 26 18:12:34 tarm kernel: [ 4216.176719] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
> May 26 18:12:34 tarm kernel: [ 4216.176856] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
> May 26 18:12:34 tarm kernel: [ 4216.177405] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
> May 26 18:12:34 tarm kernel: [ 4216.177565] cpufreq-core: governor: change or update limits
> May 26 18:12:34 tarm kernel: [ 4216.177696] cpufreq-core: __cpufreq_governor for CPU 0, event 3
> May 26 18:12:49 tarm kernel: [ 4230.625012] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:12:49 tarm kernel: [ 4230.625277] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 18:12:49 tarm kernel: [ 4230.625421] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 18:12:49 tarm kernel: [ 4230.625563] freq-table: target is 0 (2000000 kHz, 0)
> May 26 18:12:49 tarm kernel: [ 4230.625698] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
> May 26 18:12:49 tarm kernel: [ 4230.625838] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
> May 26 18:12:49 tarm kernel: [ 4230.625904] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
> May 26 18:13:00 tarm kernel: [ 4241.624998] __ratelimit: 7 messages suppressed
> May 26 18:13:00 tarm kernel: [ 4241.625219] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:13:00 tarm kernel: [ 4241.625384] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> May 26 18:13:00 tarm kernel: [ 4241.625519] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
> May 26 18:13:14 tarm kernel: [ 4255.624998] __ratelimit: 37 messages suppressed
> May 26 18:13:14 tarm kernel: [ 4255.625224] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
> May 26 18:13:14 tarm kernel: [ 4255.625391] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
> 

