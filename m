Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYHCKBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYHCKBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 06:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYHCKAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 06:00:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:16897 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbYHCKAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 06:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=I4+ebPoX6RSWTTVgyjjiSW51Ktdghzkl951/52LDpeaG2/ZImWxfFo9woEs5h0M0bT
         Q5EPdV+BX+MP/MLFFWxNytup07GTR7XWwWaPWl1sgxDbGHKwTHPPCupBRRLpYnxTy0za
         U3O/n3DMX8uKgbHZFsGGlrNA/ROf7WcZDUwMk=
Message-ID: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>
Date: Sun, 3 Aug 2008 03:00:50 -0700
From: "S K" <nospamnoham@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: cpufreq doesn't seem to work in Intel Q9300
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  I have an Intel Core 2 Quad and running kernel
2.6.25.11-97.fc9.i686. cpufreq doesn't seem to work. The cpufreq
scaling monitor in Gnome says CPU Freq scaling is not supported in my
CPU. The CPU can run at 2.0 and 2.5 GHz but mine always runs at 2.5
GHz in Linux.

So I checked  /sys and there is no cpufreq dir in /sys/...

# ls /sys/devices/system/cpu/
cpu0  cpu1  cpu2  cpu3  cpuidle  sched_mc_power_savings
# ls /sys/devices/system/cpu/cpuidle/
current_driver  current_governor_ro

I have no clue what cpuidle directory is for.

I added cpufreq.debug=7 in kernel boot params and saw the following in
the dmesg:

speedstep-smi: No supported Intel CPU detected.
cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
cpufreq-core: CPU 3: _PPC is 0 - frequency not limited
cpufreq-core: CPU 1: _PPC is 0 - frequency not limited
cpufreq-core: CPU 2: _PPC is 0 - frequency not limited
cpuidle: using governor ladder
cpuidle: using governor menu

I looked at arch/x86/kernel/cpu/cpufreq/speedstep-smi.c and it seems
to detect only Pentium IIIs.

Anyone know what files have the cpufreq code for Intel Core 2?
Does cpufreq support Intel Core 2 Quads? Especially the Q9300? If not,
anything I can do to help?

Thanks,
SK

# cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz
stepping	: 7
cpu MHz		: 2502.516
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx smx est tm2
ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips	: 5015.23
clflush size	: 64
<snipped the rest> - shows 3 more similar sections.
