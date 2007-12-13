Return-Path: <linux-kernel-owner+w=401wt.eu-S1760984AbXLMMeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760984AbXLMMeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 07:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbXLMMeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 07:34:15 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:49555 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751496AbXLMMeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 07:34:14 -0500
Date: Thu, 13 Dec 2007 18:03:33 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: gregkh@suse.de, htejun@gmail.com, stable@kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Gautham Shenoy <ego@in.ibm.com>
Subject: 2.6.22-stable causes oomkiller to be invoked
Message-ID: <20071213123333.GA16905@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Tejun,

The following script causes oomkiller to be invoked on my system here.

while echo; do cat /sys/kernel/kexec_crash_loaded; done

It gets invoked within 10 mins.

[root@llm11 ~]# cat /proc/cpuinfo 
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) MP CPU 2.50GHz
stepping        : 5
cpu MHz         : 2500.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid
xtpr
bogomips        : 4981.41
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) MP CPU 2.50GHz
stepping        : 5
cpu MHz         : 2500.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid
xtpr
bogomips        : 4976.80
clflush size    : 64

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) MP CPU 2.50GHz
stepping        : 5
cpu MHz         : 2500.000
cache size      : 1024 KB
physical id     : 1
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid
xtpr
bogomips        : 4977.07
clflush size    : 64

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) MP CPU 2.50GHz
stepping        : 5
cpu MHz         : 2500.000
cache size      : 1024 KB
physical id     : 1
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid
xtpr
bogomips        : 4977.20
clflush size    : 64

processor       : 4
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) MP CPU 2.50GHz
stepping        : 5
cpu MHz         : 2500.000
cache size      : 1024 KB
physical id     : 2
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid
xtpr
bogomips        : 4976.94
clflush size    : 64

processor       : 5
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) MP CPU 2.50GHz
stepping        : 5
cpu MHz         : 2500.000
cache size      : 1024 KB
physical id     : 2
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid
xtpr
bogomips        : 4977.08
clflush size    : 64

processor       : 6
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) MP CPU 2.50GHz
stepping        : 5
cpu MHz         : 2500.000
cache size      : 1024 KB
physical id     : 3
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid
xtpr
bogomips        : 4976.88
clflush size    : 64

processor       : 7
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) MP CPU 2.50GHz
stepping        : 5
cpu MHz         : 2500.000
cache size      : 1024 KB
physical id     : 3
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid
xtpr
bogomips        : 4977.02
clflush size    : 64

[root@llm11 ~]# 

[root@llm11 ~]# cat /proc/meminfo 
MemTotal:      4733124 kB
MemFree:       3949016 kB
Buffers:           248 kB
Cached:           8980 kB
SwapCached:          0 kB
Active:           7652 kB
Inactive:         4192 kB
HighTotal:     3956692 kB
HighFree:      3940608 kB
LowTotal:       776432 kB
LowFree:          8408 kB
SwapTotal:     1863532 kB
SwapFree:      1863532 kB
Dirty:              12 kB
Writeback:           0 kB
AnonPages:        2644 kB
Mapped:           3028 kB
Slab:             9872 kB
SReclaimable:     2900 kB
SUnreclaim:       6972 kB
PageTables:        416 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   4230092 kB
Committed_AS:    11284 kB
VmallocTotal:   116728 kB
VmallocUsed:      1084 kB
VmallocChunk:   115616 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
Hugepagesize:     2048 kB
[root@llm11 ~]# 


Will send config if required.

Thanks
-- 
regards,
Dhaval
