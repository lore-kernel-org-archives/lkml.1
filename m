Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZBOHLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZBOHLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 02:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbZBOHLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 02:11:42 -0500
Received: from rosi.naasa.net ([212.8.0.13]:35911 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZBOHLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 02:11:41 -0500
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: Frans Pop <elendil@planet.nl>
Subject: Re: cpuinfo shows wrong MHz value
Date: Sun, 15 Feb 2009 08:11:35 +0100
User-Agent: KMail/1.9.9
Cc: Kasper Sandberg <lkml@metanurb.dk>, linux-kernel@vger.kernel.org
References: <200902142217.51655.jplatte@naasa.net> <200902150102.11022.elendil@planet.nl> <200902150800.59694.jplatte@naasa.net>
In-Reply-To: <200902150800.59694.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902150811.36826.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 15. Februar 2009 schrieb Joerg Platte:
> Am Sonntag, 15. Februar 2009 schrieb Frans Pop:
> > On Sunday 15 February 2009, Joerg Platte wrote:
> > > Sorry, I should have made it clear that my computer is running with 13
> > > GHz (at leat according to the kernel). With previous kernels (IIRC
> /sys/devices/system/cpu/cpu0/cpufreq> grep . *
> affected_cpus:0
> cpuinfo_cur_freq:13000000
> cpuinfo_max_freq:13000000
> cpuinfo_min_freq:3250000
> related_cpus:0
> scaling_available_frequencies:3250000 4875000 6500000 8125000 9750000
> 11375000 13000000
> scaling_available_governors:conservative ondemand userspace powersave
> performance
> scaling_cur_freq:13000000
> scaling_driver:p4-clockmod
> scaling_governor:performance
> scaling_max_freq:13000000
> scaling_min_freq:3250000
> scaling_setspeed:<unsupported>

Looks like p4_clockmod is responsible for these high values. After removing 
it /proc/cpuinfo shows the correct values:

cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 1
model name      : Intel(R) Pentium(R) 4 CPU 1.60GHz
stepping        : 2
cpu MHz         : 1598.609
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pebs bts
bogomips        : 3197.21
clflush size    : 64
power management:

best regards,
Jörg
