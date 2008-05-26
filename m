Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYEZLhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYEZLhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 07:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbYEZLhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 07:37:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:45486 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbYEZLhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 07:37:35 -0400
Subject: Re: cpufreq limits avilable frequencies to 800MHz on git kernel
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, gnorton@novell.com,
       miguel@novell.com, linux-acpi <linux-acpi@vger.kernel.org>
In-Reply-To: <200805260907.05561.arekm@maven.pl>
References: <200805231944.57320.arekm@maven.pl>
	 <200805251136.24313.arekm@maven.pl>
	 <1211727835.3422.36.camel@linux-2bdv.site>
	 <200805260907.05561.arekm@maven.pl>
Content-Type: text/plain; charset=UTF-8
Organization: Novell/SUSE
Date: Mon, 26 May 2008 13:37:33 +0200
Message-Id: <1211801853.29901.174.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-26 at 09:07 +0200, Arkadiusz Miskiewicz wrote:
> On Sunday 25 May 2008, Thomas Renninger wrote:
> > On Sun, 2008-05-25 at 11:36 +0200, Arkadiusz Miskiewicz wrote:
> > > On Saturday 24 May 2008, Andrew Morton wrote:
> > > > On Fri, 23 May 2008 19:44:57 +0200 Arkadiusz Miskiewicz
> > > > <arekm@maven.pl>
> > >
> > > wrote:
> > > > > thinkpad z60m, Intel(R) Pentium(R) M processor 2.00GHz. kernel from
> > > > > git from 1-2 days ago.
> > > > >
> > > > > Unfortunately it seems that suspend to ram/resume causes frequency
> > > > > to be limited to 800MHz only. I can't set it to 2GHz again :-/
> > > > >
> > > > > scaling_max_freq is then 800000 and cannot be changed.
> > > > >
> > > > > reboot and the problem disappears until new suspend/resume cycle.
> > > > >
> > > > > cpufreq stuff is driven by acpi-cpufreq
> > > > >
> > > > > $ cpufreq-info
> > > > > cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
> > > > > Report errors and bugs to linux@brodo.de, please.
> > > > > analyzing CPU 0:
> > > > >   driver: acpi-cpufreq
> > > > >   CPUs which need to switch frequency at the same time: 0
> > > > >   hardware limits: 800 MHz - 2.00 GHz
> > > > >   available frequency steps: 2.00 GHz, 1.60 GHz, 1.33 GHz, 1.07 GHz,
> > > > > 800 MHz available cpufreq governors: powersave, userspace, ondemand,
> > > > > performance current policy: frequency should be within 800 MHz and
> > > > > 800 MHz. The governor "performance" may decide which speed to use
> > > > > within this range.
> > > > >   current CPU frequency is 800 MHz.
> > > > >
> > > > > /sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:0
> > > > > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq:800000
> > > > > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq:2000000
> > > > > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq:800000
> > > > > /sys/devices/system/cpu/cpu0/cpufreq/related_cpus:0
> > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies:20
> > > > >0000 0 1600000 1333000 1066000 800000
> > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors:powe
> > > > >rsav e userspace ondemand performance
> > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq:800000
> > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver:acpi-cpufreq
> > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor:performance
> > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:800000
> > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq:800000
> > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed:<unsupported>
> > > >
> > > > Thanks.  Is this a newly-occurring bug or did earlier kernels do this
> > > > also?
> > > >
> > > > If it was newly added, do you know in which kernel version we might
> > > > have added it?
> > >
> > > I wasn't able to reproduce the problem on final 2.6.24 but was able to
> > > reproduce on final 2.6.25. Problem introduced somewhere between it seems.
> > >
> > > Note that 2-3 suspend to ram/resume cycles is needed to get into the
> > > problem.
> >
> > Sounds related to:
> > ﻿[Bug 374099] T61p speedstep problems (ondemand scheduler)
> > ﻿https://bugzilla.novell.com/show_bug.cgi?id=374099
> 
> login/pass protected
> 
> >
> > Miguel speaks from "good boots" and "bad boots".
> 
> Actually I also got "bad boot" (so no suspend/resume was needed).
> 
> >
> > Could you check whether the OS thinks it is too hot.
> > ﻿I described some basics how to monitor temperature and cpufreq (if
> > passive cooling kicks in) here:
> > https://bugzilla.novell.com/show_bug.cgi?id=387702#c13
> 
> Doesn't seem to be overheated
> 
> [arekm@tarm ~]$ cat /proc/acpi/thermal_zone/*/{temperature,trip_points,state}; cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_{cur_freq,max_freq}
> temperature:             45 C
> critical (S5):           99 C
> passive:                 95 C: tc1=5 tc2=4 tsp=600 devices= CPU
> state:                   ok
> 800000
> 800000
> 
> but still limited to 800MHz.
> 
> >
> > Hmm, it may just have been fixed by this one:
> > ﻿commit e56a727b023d40d1adf660168883f30f2e6abe0a
> > Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > Date:   Mon Apr 28 15:13:43 2008 -0400
> >
> > Miguel, Geoff: This is already in 11.0 for some time and in 10.3 for
> > some days.
> 
> Unfortunately it doesn't fix the problem. The patch is in Linus tree for long
> time (so I guess I had it when initially reporting the problem) + I upgraded
> today to current git - the problem is still there.

Yep, Dells and some HP should be fixed, it would have been strange if
ThinkPads are now also affected, but thanks for double checking, it
shows the same symptoms.

Then it might be _PPC.
If you compile in CPUFREQ_DEBUG and add the boot param:
cpufreq.debug=7
you should see a message in dmesg (if you do not see one, then
everything is fine you have a "good boot" and freq should be at max?):
cpufreq_printk("CPU %d: _PPC is %d - frequency %s limited\n", pr->id,
                       (int)ppc, ppc ? "" : "not");

If PPC is zero all frequencies are allowed, if it is one max_freq will
be set to the second highest freq, etc.

If it's that you can workaround that (temporarily, pls help evaluating
this further) you can use:
processor.ignore_ppc=1

I remember Ingo Molnar sent a patch to not always evaluate _PPC at
boot/initialization time, but only on processor notification events.
AFAIK this was a recent ThinkPad, so this might be it what you are
seeing. But nobody knew why some ThinkPads had a wrong _PPC value at
initialization time.

If this is PPC related, this is more an ACPI than a cpufreq issue ->
adding linux-acpi list.

   Thomas

