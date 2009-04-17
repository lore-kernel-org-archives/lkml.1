Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbZDQRD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbZDQRD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbZDQRDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:03:51 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63976 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZDQRDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:03:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=nl0pSQ+F08McwHpKecg1hJH5YaT7gsR9XXnP1odFUV7YwZLQoka7b6u/2yJWuqsObn
         0Ig+eD4ogqv9q52q0Xu7nFGBBioEVEMT3BQ39QjU6apNpDwKkYKGhGQsbYCCszK9dfF1
         kENgHbCiht6mV9rIJvCvkFGyZ6nQu8KW4Xngw=
MIME-Version: 1.0
Date: Fri, 17 Apr 2009 19:03:48 +0200
Message-ID: <8db1092f0904171003u462b9d90pe874cd63c7a22a1d@mail.gmail.com>
Subject: Spontaneous reboots since 2.6.29-rc*
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes I observed spontaneous reboots during booting kernel, after
this message:
[...]
[    0.024996] ... PM-Timer delta = 357949
[    0.024996] ... PM-Timer result ok
[    0.024996] ..... delta 1249983
[    0.024996] ..... mult: 53694522
[    0.024996] ..... calibration result: 199997
[    0.024996] ..... CPU clock speed is 1999.0972 MHz.
[    0.024996] ..... host bus clock speed is 199.0997 MHz.
[    0.024996] Booting processor 1 APIC 0x1 ip 0x6000

after this should be:
[    0.000999] Initializing CPU#1
[    0.000999] masked ExtINT on CPU#1
[    0.000999] Calibrating delay using timer specific routine..
4067.56 BogoMIPS (lpj=2033784)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 1024K


Also I found this message in dmesg:
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs


I only have two processors:
maciek@zlom:~$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Pentium(R) Dual  CPU  E2180  @ 2.00GHz
stepping        : 13
cpu MHz         : 1200.000
cache size      : 1024 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 2
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
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl est
tm2 ssse3 cx16 xtpr pdcm lahf_lm
bogomips        : 4423.96
clflush size    : 64
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Pentium(R) Dual  CPU  E2180  @ 2.00GHz
stepping        : 13
cpu MHz         : 1200.000
cache size      : 1024 KB
physical id     : 0
siblings        : 1
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl est
tm2 ssse3 cx16 xtpr pdcm lahf_lm
bogomips        : 4067.56
clflush size    : 64
power management:

I use latest bios. Unfortunately it happens only sometimes, so I
cannot try bisect.

Config:
http://unixy.pl/maciek/download/kernel/2.6.30-rc2/pc/config-2.6.30-rc2

Dmesg:
http://unixy.pl/maciek/download/kernel/2.6.30-rc2/pc/dmesg-2.6.30-rc2.txt

Regards

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
