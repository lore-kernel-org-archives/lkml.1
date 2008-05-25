Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbYEYJgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbYEYJgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 05:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbYEYJgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 05:36:42 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:1479 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbYEYJgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 05:36:41 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: linux-kernel@vger.kernel.org
Subject: Re: cpufreq limits avilable frequencies to 800MHz on git kernel
Date: Sun, 25 May 2008 11:36:24 +0200
User-Agent: PLD Linux KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, cpufreq@lists.linux.org.uk
References: <200805231944.57320.arekm@maven.pl> <20080523182507.29a2b10c.akpm@linux-foundation.org>
In-Reply-To: <20080523182507.29a2b10c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805251136.24313.arekm@maven.pl>
X-Agnat-Warning: Use smtp.agnat.eu as SMTP server
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 May 2008, Andrew Morton wrote:
> On Fri, 23 May 2008 19:44:57 +0200 Arkadiusz Miskiewicz <arekm@maven.pl> 
wrote:
> > thinkpad z60m, Intel(R) Pentium(R) M processor 2.00GHz. kernel from git
> > from 1-2 days ago.
> >
> > Unfortunately it seems that suspend to ram/resume causes frequency
> > to be limited to 800MHz only. I can't set it to 2GHz again :-/
> >
> > scaling_max_freq is then 800000 and cannot be changed.
> >
> > reboot and the problem disappears until new suspend/resume cycle.
> >
> > cpufreq stuff is driven by acpi-cpufreq
> >
> > $ cpufreq-info
> > cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
> > Report errors and bugs to linux@brodo.de, please.
> > analyzing CPU 0:
> >   driver: acpi-cpufreq
> >   CPUs which need to switch frequency at the same time: 0
> >   hardware limits: 800 MHz - 2.00 GHz
> >   available frequency steps: 2.00 GHz, 1.60 GHz, 1.33 GHz, 1.07 GHz, 800
> > MHz available cpufreq governors: powersave, userspace, ondemand,
> > performance current policy: frequency should be within 800 MHz and 800
> > MHz. The governor "performance" may decide which speed to use within this
> > range.
> >   current CPU frequency is 800 MHz.
> >
> > /sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:0
> > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq:800000
> > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq:2000000
> > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq:800000
> > /sys/devices/system/cpu/cpu0/cpufreq/related_cpus:0
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies:200000
> >0 1600000 1333000 1066000 800000
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors:powersav
> >e userspace ondemand performance
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq:800000
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver:acpi-cpufreq
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor:performance
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:800000
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq:800000
> > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed:<unsupported>
>
> Thanks.  Is this a newly-occurring bug or did earlier kernels do this also?
>
> If it was newly added, do you know in which kernel version we might
> have added it?

I wasn't able to reproduce the problem on final 2.6.24 but was able to 
reproduce on final 2.6.25. Problem introduced somewhere between it seems.

Note that 2-3 suspend to ram/resume cycles is needed to get into the problem.

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
