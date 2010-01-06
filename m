Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082Ab0AFSgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab0AFSgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981Ab0AFSgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:36:08 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45184 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab0AFSgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:36:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Y2SEcNw8z2EWLzIudNhkYH+6ohbMS6smOUK8TYEFKPWdBz0I1zpMIDqKWvhfBSRsbp
         +O7Ut/FUugivIqOUWrWT8+hJDIWpKNEK2njqHd9QTBP8vdY9Kg5owEqGZauZb42pOXcv
         765IRAUSfoBUU9brU2GA0WRw2Ckiw34rN5084=
MIME-Version: 1.0
In-Reply-To: <1262801263.4049.53.camel@laptop>
References: <a44ae5cd1001060916s4db1d94fsb7e012ab80ce6add@mail.gmail.com>
	 <1262801263.4049.53.camel@laptop>
Date: Wed, 6 Jan 2010 13:35:59 -0500
Message-ID: <a44ae5cd1001061035n65b5a41flc84a81285df4279c@mail.gmail.com>
Subject: Re: 2.6.33-rc3 -- Intel 945GME (inteldrmfb) -- Two Tux images 
	displayed are side by side (should only show one).
From: Miles Lane <miles.lane@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 1:07 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-01-06 at 12:16 -0500, Miles Lane wrote:
>> For a long time I have gotten two pictures of Tux showing up when I
>> include the Tux display option in my custom kernel builds.
>
> Doesn't it show one for each cpu in the system?

I know this is cosmetic, but could we change this behavior and just
show one Tux on all systems?  As a software tester, this just looks
like a bug.  Alternatively, let's put labels under the Tux images
showing "CPU (N)", "CPU (N+1)", ....

This seems like a much better way to know the state of your CPUs:

# cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 28
model name	: Intel(R) Atom(TM) CPU N280   @ 1.66GHz
stepping	: 2
cpu MHz		: 1667.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc
arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl est tm2
ssse3 xtpr pdcm movbe lahf_lm
bogomips	: 3325.27
clflush size	: 64
cache_alignment	: 64
address sizes	: 32 bits physical, 32 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 28
model name	: Intel(R) Atom(TM) CPU N280   @ 1.66GHz
stepping	: 2
cpu MHz		: 1000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc
arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl est tm2
ssse3 xtpr pdcm movbe lahf_lm
bogomips	: 3324.83
clflush size	: 64
cache_alignment	: 64
address sizes	: 32 bits physical, 32 bits virtual
power management:

And:

# dmesg | grep -i cpu
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
ACPI: SSDT 7f7aeb40 004F0 (v01  PmRef    CpuPm 00003000 INTL 20051117)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
setup_percpu: NR_CPUS:5 nr_cpumask_bits:5 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 15 pages/cpu @c6c00000 s39448 r0 d21992 u2097152
pcpu-alloc: s39448 r0 d21992 u2097152 alloc=1*4194304
pcpu-alloc: [0] 0 1
Initializing CPU#0
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
RCU-based detection of stalled CPUs is enabled.
CPU 0 irqstacks, hard=c6c00000 soft=c6c01000
Initializing cgroup subsys cpuacct
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
CPU0: Thermal monitoring enabled (TM2)
CPU0: Intel(R) Atom(TM) CPU N280   @ 1.66GHz stepping 02
CPU 1 irqstacks, hard=c6e00000 soft=c6e01000
Initializing CPU#1
Brought up 2 CPUs
ACPI: SSDT 7f7ae180 001FA (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
ACPI: SSDT 7f7ae410 00724 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
ACPI: SSDT 7f7ae0b0 000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
ACPI: SSDT 7f7ae380 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
cpu0(2) debug files 135
cpu1(2) debug files 135
microcode: CPU0 sig=0x106c2, pf=0x4, revision=0x212
microcode: CPU1 sig=0x106c2, pf=0x4, revision=0x212
cpuidle: using governor ladder
cpuidle: using governor menu
