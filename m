Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZHLXWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZHLXWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 19:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbZHLXWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 19:22:09 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44679 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZHLXWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 19:22:07 -0400
Date: Wed, 12 Aug 2009 17:22:07 -0600
From: Alex Chiang <achiang@hp.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [PATCH 0/8 v5] x86: Adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090812232207.GA32125@ldl.fc.hp.com>
References: <20090807125609.GH7198@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807125609.GH7198@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

* Andreas Herrmann <andreas.herrmann3@amd.com>:
> Changes to previous patch set:
> - added patch to swap semantic of cpu_node_siblings and core_siblings
> - new patch to convert alloc/clear of cpumask to zalloc
> - added patch to update cputopology documentation
> 
> Current patch set contains 8 patches:
> - patch 1 adapts common code to show cpu_node_id,
>   cpu_node_siblings and cpu_node_siblings_list in
>   /sys/devices/system/cpu/cpu*/topology
> - patch 2 prepares arch/x86 to provide cpu_node information
> - patch 3 sets up cpu_node information for AMD Magny-Cours CPU

Do only Magny-Cours have the concept of a 'node' or should
Istanbul have nodes too?

Here is the output of my system with your patchset applied.
First, a representative entry from /proc/cpuinfo.

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 8
model name	: Six-Core AMD Opteron(tm) Processor 8439 SE
stepping	: 0
cpu MHz		: 800.000
cache size	: 512 KB
physical id	: 0
siblings	: 6
node id		: 0
core id		: 0
cpu cores	: 6
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips	: 5586.65
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

I do have the powernow_k8 module loaded too (so ignore the funny
MHz output).

# lsmod | grep k8
powernow_k8            13764  0 
processor              47724  1 powernow_k8

Here is the output with just a few fields selected.

# cat /proc/cpuinfo | egrep '^node|^core|processor|^physical|apicid' 
processor	: 0
physical id	: 0
node id		: 0
core id		: 0
apicid		: 0
initial apicid	: 0
processor	: 1
physical id	: 1
node id		: 0
core id		: 0
apicid		: 8
initial apicid	: 8
processor	: 2
physical id	: 2
node id		: 0
core id		: 0
apicid		: 16
initial apicid	: 16
processor	: 3
physical id	: 3
node id		: 0
core id		: 0
apicid		: 24
initial apicid	: 24
processor	: 4
physical id	: 4
node id		: 0
core id		: 0
apicid		: 32
initial apicid	: 32
processor	: 5
physical id	: 5
node id		: 0
core id		: 0
apicid		: 40
initial apicid	: 40
processor	: 6
physical id	: 6
node id		: 0
core id		: 0
apicid		: 48
initial apicid	: 48
processor	: 7
physical id	: 7
node id		: 0
core id		: 0
apicid		: 56
initial apicid	: 56
processor	: 8
physical id	: 0
node id		: 0
core id		: 1
apicid		: 1
initial apicid	: 1
processor	: 9
physical id	: 1
node id		: 0
core id		: 1
apicid		: 9
initial apicid	: 9
processor	: 10
physical id	: 2
node id		: 0
core id		: 1
apicid		: 17
initial apicid	: 17
processor	: 11
physical id	: 3
node id		: 0
core id		: 1
apicid		: 25
initial apicid	: 25
processor	: 12
physical id	: 4
node id		: 0
core id		: 1
apicid		: 33
initial apicid	: 33
processor	: 13
physical id	: 5
node id		: 0
core id		: 1
apicid		: 41
initial apicid	: 41
processor	: 14
physical id	: 6
node id		: 0
core id		: 1
apicid		: 49
initial apicid	: 49
processor	: 15
physical id	: 7
node id		: 0
core id		: 1
apicid		: 57
initial apicid	: 57
processor	: 16
physical id	: 0
node id		: 0
core id		: 2
apicid		: 2
initial apicid	: 2
processor	: 17
physical id	: 1
node id		: 0
core id		: 2
apicid		: 10
initial apicid	: 10
processor	: 18
physical id	: 2
node id		: 0
core id		: 2
apicid		: 18
initial apicid	: 18
processor	: 19
physical id	: 3
node id		: 0
core id		: 2
apicid		: 26
initial apicid	: 26
processor	: 20
physical id	: 4
node id		: 0
core id		: 2
apicid		: 34
initial apicid	: 34
processor	: 21
physical id	: 5
node id		: 0
core id		: 2
apicid		: 42
initial apicid	: 42
processor	: 22
physical id	: 6
node id		: 0
core id		: 2
apicid		: 50
initial apicid	: 50
processor	: 23
physical id	: 7
node id		: 0
core id		: 2
apicid		: 58
initial apicid	: 58
processor	: 24
physical id	: 0
node id		: 0
core id		: 3
apicid		: 3
initial apicid	: 3
processor	: 25
physical id	: 1
node id		: 0
core id		: 3
apicid		: 11
initial apicid	: 11
processor	: 26
physical id	: 2
node id		: 0
core id		: 3
apicid		: 19
initial apicid	: 19
processor	: 27
physical id	: 3
node id		: 0
core id		: 3
apicid		: 27
initial apicid	: 27
processor	: 28
physical id	: 4
node id		: 0
core id		: 3
apicid		: 35
initial apicid	: 35
processor	: 29
physical id	: 5
node id		: 0
core id		: 3
apicid		: 43
initial apicid	: 43
processor	: 30
physical id	: 6
node id		: 0
core id		: 3
apicid		: 51
initial apicid	: 51
processor	: 31
physical id	: 7
node id		: 0
core id		: 3
apicid		: 59
initial apicid	: 59
processor	: 32
physical id	: 0
node id		: 0
core id		: 4
apicid		: 4
initial apicid	: 4
processor	: 33
physical id	: 1
node id		: 0
core id		: 4
apicid		: 12
initial apicid	: 12
processor	: 34
physical id	: 2
node id		: 0
core id		: 4
apicid		: 20
initial apicid	: 20
processor	: 35
physical id	: 3
node id		: 0
core id		: 4
apicid		: 28
initial apicid	: 28
processor	: 36
physical id	: 4
node id		: 0
core id		: 4
apicid		: 36
initial apicid	: 36
processor	: 37
physical id	: 5
node id		: 0
core id		: 4
apicid		: 44
initial apicid	: 44
processor	: 38
physical id	: 6
node id		: 0
core id		: 4
apicid		: 52
initial apicid	: 52
processor	: 39
physical id	: 7
node id		: 0
core id		: 4
apicid		: 60
initial apicid	: 60
processor	: 40
physical id	: 0
node id		: 0
core id		: 5
apicid		: 5
initial apicid	: 5
processor	: 41
physical id	: 1
node id		: 0
core id		: 5
apicid		: 13
initial apicid	: 13
processor	: 42
physical id	: 2
node id		: 0
core id		: 5
apicid		: 21
initial apicid	: 21
processor	: 43
physical id	: 3
node id		: 0
core id		: 5
apicid		: 29
initial apicid	: 29
processor	: 44
physical id	: 4
node id		: 0
core id		: 5
apicid		: 37
initial apicid	: 37
processor	: 45
physical id	: 5
node id		: 0
core id		: 5
apicid		: 45
initial apicid	: 45
processor	: 46
physical id	: 6
node id		: 0
core id		: 5
apicid		: 53
initial apicid	: 53
processor	: 47
physical id	: 7
node id		: 0
core id		: 5
apicid		: 61
initial apicid	: 61

Thanks.

/ac

