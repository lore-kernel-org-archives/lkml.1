Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257Ab0ASMAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab0ASMAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512Ab0ASMAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:00:32 -0500
Received: from mail-a01.ithnet.com ([217.64.83.96]:56913 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751342Ab0ASMAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:00:31 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jan 2010 07:00:30 EST
X-Sender-Authentication: net64
Date: Tue, 19 Jan 2010 12:53:45 +0100
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Subject: kernel cpufreq on intel core2quad
Message-Id: <20100119125345.e5d1c6a8.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.18.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

lately I tried to make use of the CPUFreq governor "ondemand". I tried two
boxes, one with Intel(R) Core(TM)2 Quad CPU Q6700 @ 2.66GHz, another with Intel
(R) Core(TM)2 Quad CPU Q9300 @ 2.50GHz both running kernel 2.6.32.4.
At first I thought there is something wrong with the second one (Q9300). It showed the following in /proc/cpuinfo:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz
stepping        : 7
cpu MHz         : 2000.000
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow vnmi flexpriority
bogomips        : 4987.51
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

All four cores are the same, so I leave the others for now.
As you can see it shows a cpu MHz of 2000.000. This looked suspicious to me, as the Q6700 showed this:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6700  @ 2.66GHz
stepping        : 11
cpu MHz         : 600.000
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow vnmi flexpriority
bogomips        : 5333.69
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

Which means only 600 MHz in idle on Q6700 compared to 2000 MHz on Q9300.

So I turned on debugging and that left me puzzled. 
See this on Q6700:

kernel: acpi-cpufreq: acpi_cpufreq_init  
kernel: acpi-cpufreq: acpi_cpufreq_early_init
kernel: cpufreq-core: trying to register driver acpi-cpufreq
kernel: cpufreq-core: adding CPU 0
kernel: acpi-cpufreq: acpi_cpufreq_cpu_init
kernel: acpi-cpufreq: HARDWARE addr space
kernel: freq-table: table entry 0: 1000000 kHz, 0 index
kernel: freq-table: table entry 1: 800000 kHz, 1 index
kernel: freq-table: table entry 2: 600000 kHz, 2 index
kernel: acpi-cpufreq: get_cur_freq_on_cpu (0)
kernel: acpi-cpufreq: get_cur_val = 100665893
kernel: acpi-cpufreq: cur freq = 1000000
kernel: acpi-cpufreq: CPU0 - ACPI performance management activated.
kernel: acpi-cpufreq:      *P0: 1000 MHz, 31000 mW, 10 uS
kernel: acpi-cpufreq:       P1: 800 MHz, 22000 mW, 10 uS
kernel: acpi-cpufreq:       P2: 600 MHz, 13000 mW, 10 uS
kernel: freq-table: setting show_table for cpu 0 to f71ca7e0
kernel: cpufreq-core: setting new policy for CPU 0: 600000 - 1000000 kHz
kernel: acpi-cpufreq: acpi_cpufreq_verify
kernel: freq-table: request for verification of policy (600000 - 1000000 kHz) for cpu 0
kernel: freq-table: verification lead to (600000 - 1000000 kHz) for cpu 0
kernel: acpi-cpufreq: acpi_cpufreq_verify
kernel: freq-table: request for verification of policy (600000 - 1000000 kHz) for cpu 0
kernel: freq-table: verification lead to (600000 - 1000000 kHz) for cpu 0
kernel: cpufreq-core: new min and max freqs are 600000 - 1000000 kHz
kernel: cpufreq-core: governor switch
kernel: cpufreq-core: __cpufreq_governor for CPU 0, event 1
kernel: cpufreq-core: governor: change or update limits
kernel: cpufreq-core: __cpufreq_governor for CPU 0, event 3
kernel: cpufreq-core: initialization complete

And on Q9300:

kernel: acpi-cpufreq: acpi_cpufreq_init
kernel: acpi-cpufreq: acpi_cpufreq_early_init
kernel: cpufreq-core: trying to register driver acpi-cpufreq
kernel: cpufreq-core: adding CPU 0
kernel: acpi-cpufreq: acpi_cpufreq_cpu_init
kernel: acpi-cpufreq: HARDWARE addr space
kernel: freq-table: table entry 0: 2500000 kHz, 0 index
kernel: freq-table: table entry 1: 2000000 kHz, 1 index
kernel: acpi-cpufreq: get_cur_freq_on_cpu (0)
kernel: acpi-cpufreq: get_cur_val = 100681504
kernel: acpi-cpufreq: cur freq = 2500000
kernel: acpi-cpufreq: CPU0 - ACPI performance management activated.
kernel: acpi-cpufreq:      *P0: 2500 MHz, 35000 mW, 10 uS
kernel: acpi-cpufreq:       P1: 2000 MHz, 16000 mW, 10 uS
kernel: freq-table: setting show_table for cpu 0 to ffff88020d80cb00
kernel: cpufreq-core: setting new policy for CPU 0: 2000000 - 2500000 kHz
kernel: acpi-cpufreq: acpi_cpufreq_verify
kernel: freq-table: request for verification of policy (2000000 - 2500000 kHz) for cpu 0
kernel: freq-table: verification lead to (2000000 - 2500000 kHz) for cpu 0
kernel: acpi-cpufreq: acpi_cpufreq_verify
kernel: freq-table: request for verification of policy (2000000 - 2500000 kHz) for cpu 0
kernel: freq-table: verification lead to (2000000 - 2500000 kHz) for cpu 0
kernel: cpufreq-core: new min and max freqs are 2000000 - 2500000 kHz
kernel: cpufreq-core: governor switch
kernel: cpufreq-core: __cpufreq_governor for CPU 0, event 1
kernel: cpufreq-core: governor: change or update limits
kernel: cpufreq-core: __cpufreq_governor for CPU 0, event 3
kernel: cpufreq-core: initialization complete

So, now it looks like the Q6700 is in fact somehow wrong setting max freq only to 1000 MHz, though being capable of 2660 MHz.
The Q9300 in comparison shows a correct max freq of 2500 MHz, but seems only being able to slow down to 2000 MHz.
Both boxes show correct cpu freq in /proc/cpuinfo if using the performance governor btw.

Am I right that the Q6700 setup has indeed severe problems, and that the Q9300 cannot go below 2000 MHz? 

-- 
Regards,
Stephan
