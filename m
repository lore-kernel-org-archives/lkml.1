Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbYE3PnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbYE3PnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYE3Pm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:42:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:11325 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYE3Pmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=h1mXNDnHwzIRkgcDpRwMWo4jvzYEseq31USCBuBzL7p3b+xSMDQEat1eyVvhMTIBOHHblhs44r0WluUELx01wuN/N8oyAjW4gzBEKH/ud5VVcbMX5zmgXRQ62AiwMx0Vv37F/j89liRmNBHsE1q0Z4QdiMBr3obp+DAFfWBtlN0=
Message-ID: <48402064.6030400@googlemail.com>
Date: Fri, 30 May 2008 17:42:28 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: linux-next@vger.kernel.org
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: linux-next: strange CPU calibration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo , Thomas ,

on 2.6.26-rc4-next-20080530 ( probably in earlier -next releases I didn't checked yet ) the CPU calibration is random 
wrong on my box with an Core2Quad CPU. The box is running x86_64 kernel.

After rebooting the box ( using 'reboot command' ) from 2.6.25 to 2.6.26-rc4-next-20080530 I get :

...

[4294014.566475] Calibrating delay using timer specific routine.. 5002.58 BogoMIPS (lpj=2501294)
[4294014.586558] Calibrating delay using timer specific routine.. 2822.66 BogoMIPS (lpj=1411331)
[4294014.668546] Calibrating delay using timer specific routine.. 2822.69 BogoMIPS (lpj=1411348)
[4294014.751533] Calibrating delay using timer specific routine.. 2822.68 BogoMIPS (lpj=1411343)

...

CPU0 is fine the other 3 cores wrong.

( full dmesg : http://frugalware.org/~crazy/next-calibration/2.6.26-rc4-next-20080530-dmesg_wrong_calibration_1 )


Now rebooting 2.6.26-rc4-next-20080530 -> 2.6.26-rc4-next-20080530 ( using shutdown -r now this time ) I get :

...

[4294014.566476] Calibrating delay using timer specific routine.. 5002.57 BogoMIPS (lpj=2501288)
[4294014.587558] Calibrating delay using timer specific routine.. 4999.71 BogoMIPS (lpj=2499858)
[4294014.660547] Calibrating delay using timer specific routine.. 6899.61 BogoMIPS (lpj=3449809)
[4294014.733536] Calibrating delay using timer specific routine.. 4999.73 BogoMIPS (lpj=2499865)

...

CPU0 , CPU1 , CPU3 fine and CPU2 only wrong.

( full dmesg: http://frugalware.org/~crazy/next-calibration/2.6.26-rc4-next-20080530-dmesg_wrong_calibration_2 )

Finally when I halt the box wait a bit and power up again I get all right :

...

[4294014.566475] Calibrating delay using timer specific routine.. 5002.60 BogoMIPS (lpj=2501300)
[4294014.586558] Calibrating delay using timer specific routine.. 4999.71 BogoMIPS (lpj=2499855)
[4294014.659547] Calibrating delay using timer specific routine.. 4999.73 BogoMIPS (lpj=2499865)
[4294014.732536] Calibrating delay using timer specific routine.. 4999.73 BogoMIPS (lpj=2499867)

...

( full dmesg : http://frugalware.org/~crazy/next-calibration/2.6.26-rc4-next-20080530-dmesg_OK_after_halt )

config used for this kernel : http://frugalware.org/~crazy/next-calibration/next-config

cpuinfo :


processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz
stepping	: 7
cpu MHz		: 2497.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips	: 5002.60
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz
stepping	: 7
cpu MHz		: 2497.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 4
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips	: 4999.71
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz
stepping	: 7
cpu MHz		: 2497.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips	: 4999.73
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz
stepping	: 7
cpu MHz		: 2497.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips	: 4999.73
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


I cannot reproduce this on linus tree ( I will do some more reboot and tests tomorrow against mainline tree just to be sure ).

Please let me know if you need more informations.

Best Regards,

Gabriel

