Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZFSPgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZFSPgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZFSPg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:36:26 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:1050 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751659AbZFSPgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:36:25 -0400
X-Greylist: delayed 1427 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2009 11:36:25 EDT
Message-ID: <4A3BAAE8.3030606@athenacr.com>
Date: Fri, 19 Jun 2009 11:12:40 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: gettimeofday() time warps on Nehalem
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been using time-warp-test from 
http://people.redhat.com/mingo/time-warp-test/ and have some confusing results.
My machine is a IBM 3550M2 Nehalem box, kernel 2.6.30. time-warp-test.c finds
time warps in gettimeofday() and clock_gettime(CLOCK_MONOTONIC). TEST_TSC does
not find any timewarps from rdtsc.

Thought I'd ask Ingo & LKML before I dive deeper. Is this a kernel issue,
time-warp-test issue, or a problem with my machine? Do you expect
time-warp-test's TEST_TOD to pass on new kernels? I was under the impression
that the TSC clocksource protected against time warps in gettimeofday().

Thanks,
Brian Bloniarz

$ uname -a
Linux lab5 2.6.30-nehalem #1 SMP Fri Jun 12 11:18:50 EDT 2009 x86_64 GNU/Linux

$ head -24 /proc/cpuinfo 
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 26
model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
stepping        : 5
cpu MHz         : 2266.822
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology tsc_reliable nonstop_tsc pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
bogomips        : 4533.64
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:

$ cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
tsc

$ ./time-warp-test
16 CPUs, running 16 parallel test-tasks.
checking for time-warps via:
- gettimeofday (TOD) syscall (usec resolution)

new TOD-warp maximum:        -1 usecs,  00046cb465acb046 -> 00046cb465acb045
new TOD-warp maximum:        -2 usecs,  00046cb465ad7515 -> 00046cb465ad7513
TOD: 0.26us, fail:21534 \
