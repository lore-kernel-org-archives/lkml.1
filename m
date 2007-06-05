Return-Path: <linux-kernel-owner+w=401wt.eu-S1764334AbXFELGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764334AbXFELGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763790AbXFELGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:06:35 -0400
Received: from bravo.securenet-server.net ([207.210.84.244]:48469 "EHLO
	bravo.securenet-server.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763738AbXFELGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:06:34 -0400
From: Mircea Bardac <dev.list@mircea.bardac.net>
To: "Peter Oruba" <peter.oruba@amd.com>
Subject: Re: CPU off-on-off: lost CPU management?
Date: Tue, 5 Jun 2007 12:52:59 +0300
User-Agent: KMail/1.9.7
Cc: stefan.prechtel@googlemail.com,
       "Linux List" <linux-kernel@vger.kernel.org>
References: <200706051003.29501.peter.oruba@amd.com>
In-Reply-To: <200706051003.29501.peter.oruba@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706051253.01551.dev.list@mircea.bardac.net>
X-PopBeforeSMTPSenders: bmi@bardac.net
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bravo.securenet-server.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mircea.bardac.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

This time with Kernel 2.6.21.3.

On Tuesday 05 June 2007 11:03:23 Peter Oruba wrote:
> reagarding your Turion cpufreq issues - is that solved by now?
> http://lkml.org/lkml/2007/4/8/59


**** /proc/cpuinfo shows half the bogomips it showed in my initial post
**** (maybe it is right now)

# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping        : 2
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp 
lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8legacy ts fid 
vid ttp tm stc
bogomips        : 1597.67
clflush size    : 64

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping        : 2
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp 
lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8legacy ts fid 
vid ttp tm stc
bogomips        : 1597.67
clflush size    : 64


# cpufreq-info
cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
Report errors and bugs to linux@brodo.de, please.
analyzing CPU 0:
  driver: powernow-k8
  CPUs which need to switch frequency at the same time: 0 1
  hardware limits: 800 MHz - 1.60 GHz
  available frequency steps: 1.60 GHz, 800 MHz
  available cpufreq governors: ondemand, performance
  current policy: frequency should be within 800 MHz and 1.60 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz (asserted by call to hardware).
analyzing CPU 1:
  driver: powernow-k8
  CPUs which need to switch frequency at the same time: 0 1
  hardware limits: 800 MHz - 1.60 GHz
  available frequency steps: 1.60 GHz, 800 MHz
  available cpufreq governors: ondemand, performance
  current policy: frequency should be within 800 MHz and 1.60 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz (asserted by call to hardware).

# echo 0 > /sys/devices/system/cpu/cpu1/online

**** this time the bogomips didn't drop to half of the dual-cpu bogomips
**** mostly because the dual bogomips is now half
**** (as I said before, don't know if this is right)
**** the features list now shows "up"
**** (in addition to what the features list of the dual-cpu showed)
**** (is this right?, might have appeared in my initial post too)

# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping        : 2
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp 
lm 3dnowext 3dnow up pni cx16 lahf_lm cmp_legacy svm extapic cr8legacy ts fid 
vid ttp tm stc
bogomips        : 1597.67
clflush size    : 64


[root@cougar /home/mircea]# cpufreq-info
cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
Report errors and bugs to linux@brodo.de, please.
analyzing CPU 0:
  driver: powernow-k8
  CPUs which need to switch frequency at the same time: 0
  hardware limits: 800 MHz - 1.60 GHz
  available frequency steps: 1.60 GHz, 800 MHz
  available cpufreq governors: ondemand, performance
  current policy: frequency should be within 800 MHz and 1.60 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz (asserted by call to hardware).

**** compared to my initial post, everything below didn't change at all
**** meaning all inconsistences are still there
**** (like: cache size missing for the 2nd core)
**** still can't activate powernow-k8 for the 2nd core
**** bogomips appears to stay the same for each CPU compared to my prev
**** post

# echo 1 > /sys/devices/system/cpu/cpu1/online

# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping        : 2
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp 
lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8legacy ts fid 
vid ttp tm stc
bogomips        : 1597.67
clflush size    : 64

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping        : 2
cpu MHz         : 798.015
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp 
lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8legacy ts fid 
vid ttp tm stc
bogomips        : 1596.26
clflush size    : 64


# cpufreq-info
cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
Report errors and bugs to linux@brodo.de, please.
analyzing CPU 0:
  driver: powernow-k8
  CPUs which need to switch frequency at the same time: 0
  hardware limits: 800 MHz - 1.60 GHz
  available frequency steps: 1.60 GHz, 800 MHz
  available cpufreq governors: ondemand, performance
  current policy: frequency should be within 800 MHz and 1.60 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz (asserted by call to hardware).
analyzing CPU 1:
  no or unknown cpufreq driver is active on this CPU

# rmmod powernow-k8

# modprobe powernow-k8
FATAL: Error inserting powernow_k8 
(/lib/modules/2.6.21-ARCH/kernel/arch/i386/kernel/cpu/cpufreq/powernow-k8.ko): 
No such device


Many thanks for following this,
Mircea
