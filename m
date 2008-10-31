Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbYJaOVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbYJaOVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYJaOVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:21:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:23683 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYJaOVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:21:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=YavJsS9A5joQvxaOWoQQ0Dd7jiv1keT+mmXDNcVPllyZEkArLKGAaO5r0+m7uHyw9E
         9JJCONJE+boc+RNwnpx9i4cGH6tFPCyGyfzFDEpDeI2Le7EnnDGcit3IYxVKf7VCdxKz
         hKleYVgxnv2m9/bRluCfE9d5EjACfHxS2es5I=
Message-ID: <84144f020810310721x1d1eccbeica5d10608d7b2e57@mail.gmail.com>
Date: Fri, 31 Oct 2008 16:21:21 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
Cc: "linux kernel" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@linux.intel.com>, robert.richter@amd.com,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <4909F690.9090208@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4909F690.9090208@cosmosbay.com>
X-Google-Sender-Auth: d0607b2f39b9d847
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding some more cc's)

On Thu, Oct 30, 2008 at 8:01 PM, Eric Dumazet <dada1@cosmosbay.com> wrote:
> I tried to start my favorite tool, and discovered it wont fly on my HP
> BL460C G1
>
> It samples few events then, seems to stop (no more NMI), other than that,
> machine
> still running correctly.
>
> (8 cpus like that one
>
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 23
> model name      : Intel(R) Xeon(R) CPU           E5450  @ 3.00GHz
> stepping        : 6
> cpu MHz         : 3000.253
> cache size      : 6144 KB
> physical id     : 0
> siblings        : 4
> core id         : 0
> cpu cores       : 4
> apicid          : 0
> initial apicid  : 0
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
> constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx est tm2
> ssse3 cx16 xtpr pdcm dca sse4_1 lahf_lm tpr_shadow vnmi flexpriority
> bogomips        : 6000.50
> clflush size    : 64
> power management:
>
> It is working correctly on 2.6.27
>
> I tried a git bisect but quickly found a point where machine was not
> useable...
> (partly because of the problem with the VPD problem on 5708S (PCI: Limit VPD
> length for Broadcom 5708S)
>
> # opcontrol --deinit
> Stopping profiling.
> Killing daemon.
> # rm -rf /var/lib/oprofile/samples/current
> # opcontrol --vmlinux=vmlinux --start
> Using 2.6+ OProfile kernel interface.
> Reading module info.
> Using log file /var/lib/oprofile/samples/oprofiled.log
> Daemon started.
> Profiler running.
>
> # opcontrol --dump; opreport
> CPU: Core 2, speed 3000.25 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit
> mask of 0x00 (Unhalted core cycles) count 10000
> CPU_CLK_UNHALT...|
>  samples|      %|
> ------------------
>      17 80.9524 vmlinux
>       2  9.5238 libc-2.3.4.so
>       1  4.7619 bash
>       1  4.7619 ld-2.3.4.so
> # opcontrol --dump; opreport
> CPU: Core 2, speed 3000.25 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit
> mask of 0x00 (Unhalted core cycles) count 10000
> CPU_CLK_UNHALT...|
>  samples|      %|
> ------------------
>      17 80.9524 vmlinux
>       2  9.5238 libc-2.3.4.so
>       1  4.7619 bash
>       1  4.7619 ld-2.3.4.so
> # opcontrol --dump; opreport
> CPU: Core 2, speed 3000.25 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit
> mask of 0x00 (Unhalted core cycles) count 10000
> CPU_CLK_UNHALT...|
>  samples|      %|
> ------------------
>      17 80.9524 vmlinux
>       2  9.5238 libc-2.3.4.so
>       1  4.7619 bash
>       1  4.7619 ld-2.3.4.so
>
> # grep NMI /proc/interrupts
> NMI:          8          2          2          6         11          7
>    6          5   Non-maskable interrupts
> # grep NMI /proc/interrupts
> NMI:          8          2          2          6         11          7
>    6          5   Non-maskable interrupts
> # grep NMI /proc/interrupts
> NMI:          8          2          2          6         11          7
>    6          5   Non-maskable interrupts
> # grep NMI /proc/interrupts
> NMI:          8          2          2          6         11          7
>    6          5   Non-maskable interrupts

I'm seeing the same thing on my 2-way x86-64. Here's my /proc/cpuinfo
in case it helps:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
stepping	: 6
cpu MHz		: 2000.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips	: 3989.97
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
stepping	: 6
cpu MHz		: 2000.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips	: 3989.97
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:
