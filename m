Return-Path: <linux-kernel-owner+w=401wt.eu-S936362AbXG2VQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936362AbXG2VQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934891AbXG2VQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:16:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:33969 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934233AbXG2VQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=mI+FT4l3fgTc5E256t6HbCziVUSqPjLxWhEPjkJt1bui7HifbJ5Hd+OUY7h1wxbbKSWbMv0ZMQ9mmDWkUPsDk8Stdq5D6udw2BjE9JnWN6oWNlh0tLUBXGqj+yACoG3W+xSNnhN5QrRtTWQcr8QMgTgTHCunzgp7e7AOHWCokCw=
Message-ID: <46AD03BD.7040203@gmail.com>
Date: Sun, 29 Jul 2007 15:16:45 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070621)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: cpufreq scaling appears not to work on overclocked systems
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is not new, but exists as far back as 2.6.17.  I haven't reported
it before because I figured that surely someone else had noticed it, but
since it's still unfixed and I cannot find any mention of it on LKML,
here we go.

I'm running a Core2 Duo 1.86GHz overclocked to 2.56GHz.  Everything is
normal with cpufreq scaling disabled.  With cpufreq scaling enabled in
the kernel, using any governor, /proc/cpuinfo indicates a maximum of the
rated frequency rather than the actual frequency.

Here it is under 100% utilization, with userspace governor and powernowd:

berck@luna:~$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping        : 6
cpu MHz         : 1862.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 5134.39
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping        : 6
cpu MHz         : 1862.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 5131.64
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

At idle it drops down to 1596.000 MHz reported.  At boot the kernel
doest report the correct frequency (2564.907), which agrees with the
bogomips reported by /proc/cpuinfo as well.

I haven't done any benchmarking to try to determine if perhaps freq
scaling works as it should and just the reported frequency is incorrect.

Berck
