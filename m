Return-Path: <linux-kernel-owner+w=401wt.eu-S1422801AbXDRKPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422801AbXDRKPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422811AbXDRKPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:15:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:46201 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422772AbXDRKPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:15:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tA5OLu32FXI4Ev0r0TueJUKHuIebHrmPFDn04U8PwVubQKUc34tWY2hTzLiDwxagax41j0yEy8t6o+fvV0X54zFjQOov2HL37CWBCzbRDpqGOEH0y5tbtycSg14Dmdpl0JwFSmat9t5NHBqTjlU5gTjTuZ877V1p/EF4FMafbh0=
Message-ID: <b93822910704180315u35c2f2f9i72c7a2dd5e4a17e8@mail.gmail.com>
Date: Wed, 18 Apr 2007 12:15:31 +0200
From: "Stefan Prechtel" <stefan.prechtel@googlemail.com>
To: "Mircea Bardac" <dev.list@mircea.bardac.net>
Subject: Re: CPU off-on-off: lost CPU management?
Cc: linux-kernel@vger.kernel.org, "Rusty Russell" <rusty@rustycorp.com.au>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Ashok Raj" <ashok.raj@intel.com>
In-Reply-To: <200704081923.35312.dev.list@mircea.bardac.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704081923.35312.dev.list@mircea.bardac.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have the same "problems" with CPU-Hotplug. Whenever I turn off the
second core and turn it back on, /proc/cpuinfo shows that the second
core is on, but at a different speed.

# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-60
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
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm
extapic cr8legacy ts fid vid ttp tm stc
bogomips        : 1596.96
clflush size    : 64

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-60
stepping        : 2
cpu MHz         : 1995.071
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm
extapic cr8legacy ts fid vid ttp tm stc
bogomips        : 3990.71
clflush size    : 64



dmesg shows the following after resume from s2disk (only the first
time, then "CPU: Vendor unknown../Your system my be unstable" doesn't
appear):


Disabling non-boot CPUs ...
Cannot set affinity for irq 0
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU1 is down
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.61 BogoMIPS (lpj=1995306)
CPU: Vendor unknown, using generic init.
CPU: Your system may be unstable.
CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000
00002001 00000000 0000001f
CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000000
00002001 00000000 0000001f
CPU1: AuthenticAMD AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 02
CPU1 is up
Switched to high resolution mode on CPU 1


But I don't noticed a shorter batterylife or more cpu hotness, so I
think the second core is running at the same speed as CPU0 and
/proc/cpuinfo (and possibly other files) doesn't update correctly.


Regards,
Stefan



2007/4/8, Mircea Bardac <dev.list@mircea.bardac.net>:
> Hi everyone,
>
> After reading "CPU offline but power consumption increased?" lkml thread I
> wanted to test CPU on-off on my Turion 64 X2.
>
> I found out something strange, related to the way CPU is turned off and back
> on. I don't know if this is a kernel bug, but looks pretty suspicious.
>
>
> **** The initial situation, both cores running at 1.6 GHz, full info displayed
> **** /proc/cpuinfo
>
> # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 72
> model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
> stepping        : 2
> cpu MHz         : 1600.000
> cache size      : 512 KB
> physical id     : 0
> siblings        : 2
> core id         : 0
> cpu cores       : 2
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm
> 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8legacy ts fid vid ttp tm
> stc
> bogomips        : 3195.47
> clflush size    : 64
>
> processor       : 1
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 72
> model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
> stepping        : 2
> cpu MHz         : 1600.000
> cache size      : 512 KB
> physical id     : 0
> siblings        : 2
> core id         : 1
> cpu cores       : 2
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm
> 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8legacy ts fid vid ttp tm
> stc
> bogomips        : 3195.47
> clflush size    : 64
>
>
>
> **** The initial situation, both cores running at 1.6 GHz, full info displayed
> **** cpufreq-info
>
> # cpufreq-info
> cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
> Report errors and bugs to linux@brodo.de, please.
> analyzing CPU 0:
>   driver: powernow-k8
>   CPUs which need to switch frequency at the same time: 0 1
>   hardware limits: 800 MHz - 1.60 GHz
>   available frequency steps: 1.60 GHz, 800 MHz
>   available cpufreq governors: powersave, performance
>   current policy: frequency should be within 800 MHz and 1.60 GHz.
>                   The governor "performance" may decide which speed to use
>                   within this range.
>   current CPU frequency is 1.60 GHz (asserted by call to hardware).
> analyzing CPU 1:
>   driver: powernow-k8
>   CPUs which need to switch frequency at the same time: 0 1
>   hardware limits: 800 MHz - 1.60 GHz
>   available frequency steps: 1.60 GHz, 800 MHz
>   available cpufreq governors: powersave, performance
>   current policy: frequency should be within 800 MHz and 1.60 GHz.
>                   The governor "performance" may decide which speed to use
>                   within this range.
>   current CPU frequency is 1.60 GHz (asserted by call to hardware).
>
>
>
> **** 2nd core is shut down
>
> # echo 0 > /sys/devices/system/cpu/cpu1/online
>
>
>
> **** Only 2nd core is now running, at 800 MHz, half bogomips
> **** /proc/cpuinfo
>
> # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 72
> model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
> stepping        : 2
> cpu MHz         : 800.000
> cache size      : 512 KB
> physical id     : 0
> siblings        : 1
> core id         : 0
> cpu cores       : 1
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm
> 3dnowext 3dnow up pni cx16 lahf_lm cmp_legacy svm cr8legacy ts fid vid ttp tm
> stc
> bogomips        : 1597.73
> clflush size    : 64
>
>
>
> **** Only 2nd core is now running, at 800 MHz, half bogomips
> **** cpufreq-info
>
> # cpufreq-info
> cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
> Report errors and bugs to linux@brodo.de, please.
> analyzing CPU 0:
>   driver: powernow-k8
>   CPUs which need to switch frequency at the same time: 0
>   hardware limits: 800 MHz - 1.60 GHz
>   available frequency steps: 1.60 GHz, 800 MHz
>   available cpufreq governors: powersave, performance
>   current policy: frequency should be within 800 MHz and 1.60 GHz.
>                   The governor "performance" may decide which speed to use
>                   within this range.
>   current CPU frequency is 800 MHz (asserted by call to hardware).
>
>
>
> **** Turning 2nd core back on
>
> # echo 1 > /sys/devices/system/cpu/cpu1/online
>
>
>
> **** /proc/cpuinfo shows again info about 2nd core
> **** but some details are missing about 2nd core, such as "cache size"
> **** (others might also be missing) - this makes me think something might not
> **** be working right (cache not used maybe?)
> **** Bogomips is still half (I'm not sure if this is directly proportional
> **** with CPU frequency or with number of cores)
>
> # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 72
> model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
> stepping        : 2
> cpu MHz         : 800.000
> cache size      : 512 KB
> physical id     : 0
> siblings        : 1
> core id         : 0
> cpu cores       : 1
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm
> 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8legacy ts fid vid ttp tm
> stc
> bogomips        : 1597.73
> clflush size    : 64
>
> processor       : 1
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 72
> model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
> stepping        : 2
> cpu MHz         : 1596.093
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm
> 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8legacy ts fid vid ttp tm
> stc
> bogomips        : 1596.01
> clflush size    : 64
>
>
> **** cpufreq-info shows info only about 1st core
>
> # cpufreq-info
> cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
> Report errors and bugs to linux@brodo.de, please.
> analyzing CPU 0:
>   driver: powernow-k8
>   CPUs which need to switch frequency at the same time: 0
>   hardware limits: 800 MHz - 1.60 GHz
>   available frequency steps: 1.60 GHz, 800 MHz
>   available cpufreq governors: powersave, performance
>   current policy: frequency should be within 800 MHz and 1.60 GHz.
>                   The governor "performance" may decide which speed to use
>                   within this range.
>   current CPU frequency is 800 MHz (asserted by call to hardware).
> analyzing CPU 1:
>   no or unknown cpufreq driver is active on this CPU
>
>
>
> **** reloading powernow-k8 driver, to check if cpufreq-info gets back working
>
> # rmmod powernow-k8
>
> # modprobe powernow-k8
> FATAL: Error inserting powernow_k8
> (/lib/modules/2.6.20-ARCH/kernel/arch/i386/kernel/cpu/cpufreq/powernow-k8.ko):
> No such device
>
>
> Many thanks,
> Mircea
>
> --
> http://mircea.bardac.net
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
