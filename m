Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbYCZH0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbYCZH0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYCZH0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:26:06 -0400
Received: from n57.bullet.mail.sp1.yahoo.com ([98.136.44.49]:27676 "HELO
	n57.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750934AbYCZH0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:26:05 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 133752.64722.bm@omp105.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=BPxs9HfbRQ8/SS2cfzJzBxUrYZhPfaCPRA5nCpwkWjH/3Shug4HILgdeAmO7wCcBJwywdSR5csU9v0isTQ4rU4K/SYrtN2OFd/7h53PHiUKNCwU6dpfR9ed8UCDqrOrm2nxfvKnU6p0qkpPysIwwmhqT1DEpeJkHG6nOzM+Hu2I=;
X-YMail-OSG: 0eJVCWIVM1leY9EjZUvlOaMeiOvN4b5lV7FqfRqggjZg9EpX8_LTNgD.zxlY1jjtMw--
Date: Wed, 26 Mar 2008 08:26:01 +0100 (CET)
From: Michael Meyer <mike65134@yahoo.de>
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200803251927.14211.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <801587.47494.qm@web25803.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Len Brown <lenb@kernel.org> schrieb:

> On Tuesday 25 March 2008, Michael Meyer wrote:
> > 
> > --- Andi Kleen <andi@firstfloor.org> schrieb:
> > 
> > > Luciano Rocha <luciano@eurotux.com> writes:
> > > 
> > > > On Tue, Mar 25, 2008 at 02:47:50PM +0100, Michael
> > > Meyer wrote:
> > > > > Hi, 
> > > > > 
> > > > > what is the difference between booting a dual
> > > core
> > > > > machine with "maxcpus=1" or by deactivating the
> > > second
> > > > > core at run time with "echo 0 >
> > > > > /sys/devices/system/cpu/cpu1/online"?
> > > > 
> > > > maxcpus=1 should turn off the SMP alternative and
> > > switch to UP only,
> > > > optimising some locks and instructions.
> > > 
> > > CPU hot unplug will do the same. But it is unlikely
> > > it accounts
> > > for that much performance difference.
> > > 
> > > If he used maxcpus=0 it would make sense. maxcpus=0
> > > disables
> > > the IO-APIC which likely makes a large difference.
> > > But it should
> > > be actually slower.
> > > 
> > > There should be actually no difference in theory
> > > between max_cpus=1
> > > and hot unplug to one CPU. Might be some bug.
> > 
> > I had the following time values:
> > 
> > maxcpus=1:
> > real	0m1.642s
> > user	0m1.528s
> > sys	0m0.068s
> > 
> > maxcpus=2 and 
> > echo 1 > /sys/devices/system/cpu/cpu1/online:
> > real	0m2.579s
> > user	0m4.096s
> > sys	0m0.160s
> 
> this above is the baseline, yes?

Yes, it is.

> it is same as if you used no boot param
> and did not touch the online file, yes?

Yes. I just repeated it - once without the commands and once with the
same commands stated above. Same result. So this is the default.

> 
> > maxcpus=2 and
> > echo 0 > /sys/devices/system/cpu/cpu1/online:
> > real	0m3.757s
> > user	0m3.632s
> > sys	0m0.112s
> 
> Please post the contents of 
> # grep . /sys/devices/system/cpu/cpu*/cpufreq/*

# grep . /sys/devices/system/cpu/cpu*/cpufreq/*
/sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:0
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq:2400000
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq:1600000
/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies:2400000
1600000 
/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors:ondemand
userspace conservative powersave performance 
/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq:1600000
/sys/devices/system/cpu/cpu0/cpufreq/scaling_driver:acpi-cpufreq
/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor:ondemand
/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:2400000
/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq:1600000
/sys/devices/system/cpu/cpu1/cpufreq/affected_cpus:1
/sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_max_freq:2400000
/sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_min_freq:1600000
/sys/devices/system/cpu/cpu1/cpufreq/scaling_available_frequencies:2400000
1600000 
/sys/devices/system/cpu/cpu1/cpufreq/scaling_available_governors:ondemand
userspace conservative powersave performance 
/sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq:1600000
/sys/devices/system/cpu/cpu1/cpufreq/scaling_driver:acpi-cpufreq
/sys/devices/system/cpu/cpu1/cpufreq/scaling_governor:ondemand
/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq:2400000
/sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq:1600000


> and also
> grep . /proc/acpi/processor/*/power

# grep . /proc/acpi/processor/*/power
/proc/acpi/processor/CPU0/power:active state:            C0
/proc/acpi/processor/CPU0/power:max_cstate:              C8
/proc/acpi/processor/CPU0/power:bus master activity:     00000000
/proc/acpi/processor/CPU0/power:maximum allowed latency: 8000 usec
/proc/acpi/processor/CPU0/power:states:
/proc/acpi/processor/CPU0/power:    C1:                  type[C1]
promotion[--] demotion[--] latency[000] usage[00000000]
duration[00000000000000000000]
/proc/acpi/processor/CPU1/power:active state:            C0
/proc/acpi/processor/CPU1/power:max_cstate:              C8
/proc/acpi/processor/CPU1/power:bus master activity:     00000000
/proc/acpi/processor/CPU1/power:maximum allowed latency: 8000 usec
/proc/acpi/processor/CPU1/power:states:
/proc/acpi/processor/CPU1/power:    C1:                  type[C1]
promotion[--] demotion[--] latency[000] usage[00000000]
duration[00000000000000000000]


> 
> My guess that the maxcpus=1 case benefits from turbo mode, aka EIDA.
> That benefit, however, is subject to this bug:
> http://bugzilla.kernel.org/show_bug.cgi?id=5471
> because for a single thread to run faster than the marketing MHz,
> the other thread must be in deep-idle, which is prevented
> by the bug above.
> 
> If your scaling_available_frequencies includes 2401000
> then you probably have a turbo-mode enabled processor.

It does not include 2401000. The processor is an Intel Core 2 Duo E6600
(2.4GHZ) bought at the beginning of 2007. I do not think that that kind
of freqency scaling was available back than. 

> 
> one way to verify this would be to disable turbo mode
> by pegging the MHz like so:
> 
> # echo 2400000 >
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq
> # echo 2400000 >
> /sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_max_freq
> 
> -Len
> 

This does not work, as both are read-only. 


      E-Mails jetzt auf Ihrem Handy.
www.yahoo.de/go

