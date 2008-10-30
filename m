Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbYJ3SC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbYJ3SC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYJ3SCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:02:11 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:51187 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbYJ3SCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:02:08 -0400
Message-ID: <4909F690.9090208@cosmosbay.com>
Date: Thu, 30 Oct 2008 19:01:52 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@linux.intel.com>
Subject: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 30 Oct 2008 19:02:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I tried to start my favorite tool, and discovered it wont fly on my HP BL460C G1

It samples few events then, seems to stop (no more NMI), other than that, machine
still running correctly.

(8 cpus like that one

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           E5450  @ 3.00GHz
stepping        : 6
cpu MHz         : 3000.253
cache size      : 6144 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 lahf_lm tpr_shadow vnmi flexpriority
bogomips        : 6000.50
clflush size    : 64
power management:

It is working correctly on 2.6.27

I tried a git bisect but quickly found a point where machine was not useable...
(partly because of the problem with the VPD problem on 5708S (PCI: Limit VPD length for Broadcom 5708S)

# opcontrol --deinit
Stopping profiling.
Killing daemon.
# rm -rf /var/lib/oprofile/samples/current
# opcontrol --vmlinux=vmlinux --start
Using 2.6+ OProfile kernel interface.
Reading module info.
Using log file /var/lib/oprofile/samples/oprofiled.log
Daemon started.
Profiler running.

# opcontrol --dump; opreport
CPU: Core 2, speed 3000.25 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (Unhalted core cycles) count 10000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
       17 80.9524 vmlinux
        2  9.5238 libc-2.3.4.so
        1  4.7619 bash
        1  4.7619 ld-2.3.4.so
# opcontrol --dump; opreport
CPU: Core 2, speed 3000.25 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (Unhalted core cycles) count 10000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
       17 80.9524 vmlinux
        2  9.5238 libc-2.3.4.so
        1  4.7619 bash
        1  4.7619 ld-2.3.4.so
# opcontrol --dump; opreport
CPU: Core 2, speed 3000.25 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (Unhalted core cycles) count 10000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
       17 80.9524 vmlinux
        2  9.5238 libc-2.3.4.so
        1  4.7619 bash
        1  4.7619 ld-2.3.4.so

# grep NMI /proc/interrupts
NMI:          8          2          2          6         11          7          6          5   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:          8          2          2          6         11          7          6          5   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:          8          2          2          6         11          7          6          5   Non-maskable interrupts
# grep NMI /proc/interrupts
NMI:          8          2          2          6         11          7          6          5   Non-maskable interrupts
