Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYKACaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYKACaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 22:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYKACaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 22:30:22 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:48959 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbYKACaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 22:30:21 -0400
X-BigFish: VPS-50(z21eWz62a3L1432R98dR936eQ1805M179dR936fO3b5bk8b9ck4cd6k19c2kzzzzz32i6bh68o)
X-Spam-TCS-SCL: 7:0
X-WSS-ID: 0K9MUXT-01-C7T-01
Date: Sat, 1 Nov 2008 03:29:43 +0100
From: Robert Richter <robert.richter@amd.com>
To: Eric Dumazet <dada1@cosmosbay.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
Message-ID: <20081101022943.GJ1029@erda.amd.com>
References: <4909F690.9090208@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4909F690.9090208@cosmosbay.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 01 Nov 2008 02:30:05.0191 (UTC) FILETIME=[BFF79970:01C93BC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

On 30.10.08 19:01:52, Eric Dumazet wrote:
> Hi
>
> I tried to start my favorite tool, and discovered it wont fly on my HP 
> BL460C G1
>
> It samples few events then, seems to stop (no more NMI), other than that, 
> machine
> still running correctly.

hmm, I can not reproduce this on my system. I am receiving samples and
the number is increasing. Andi, could you test this on some of your
systems?

-Robert

# opcontrol --dump; opreport 
CPU: AMD64 family10, speed 2100 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
    70897 98.6970 vmlinux
      467  0.6501 libc-2.6.1.so
      219  0.3049 bash
      141  0.1963 ld-2.6.1.so
       43  0.0599 oprofiled
       15  0.0209 gawk-3.1.5
       15  0.0209 opreport
        9  0.0125 libstdc++.so.6.0.8
        8  0.0111 grep
        5  0.0070 sshd
        4  0.0056 libcrypto.so.0.9.8
        2  0.0028 rm
        1  0.0014 cat
        1  0.0014 dirname
        1  0.0014 ls
        1  0.0014 mkdir
        1  0.0014 id
        1  0.0014 ophelp
        1  0.0014 libbfd-2.18.so
        1  0.0014 ntpd
# grep NMI /proc/interrupts 
NMI:      20357      14272      20151       9967      20140      13961      16291      20826   Non-maskable interrupts
# grep NMI /proc/interrupts 
NMI:      20627      14458      20398      10080      20391      14204      16444      21016   Non-maskable interrupts
# cat /proc/cpuinfo
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 2
model name	: Quad-Core AMD Opteron(tm) Processor 2352
stepping	: 3
cpu MHz		: 2100.000
cache size	: 512 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good pni monitor cx16 lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs
bogomips	: 4189.26
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate
# uname -a
Linux paloma 2.6.28-rc2-oprofile-x86_64-standard #1 SMP Sat Nov 1 01:28:08 CET 2008 x86_64 Quad-Core AMD Opteron(tm) Processor 2352 AuthenticAMD GNU/Linux

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

