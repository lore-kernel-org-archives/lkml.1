Return-Path: <linux-kernel-owner+w=401wt.eu-S1161393AbXBGRWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161393AbXBGRWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161395AbXBGRWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:22:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:64054 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161393AbXBGRWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:22:30 -0500
From: Emmeran Seehuber <rototor@rototor.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.18.2: sporadic SATA port resets (Broadcom BCM5785 (HT1000))
Date: Wed, 7 Feb 2007 18:17:12 +0100
User-Agent: KMail/1.9.6
X-Face: r$Dk&6(PFBkz"O(d4nE<ZXvpygmFFB%`/+1FHeQCFD|K1tY#:C3t"=?utf-8?q?wW2zb=27QD=3FYWE=26liV=5E=0A=09h!=26-=7C=5DT=2E=5BRlcZ=7DN=7E4A0z?=
 =?utf-8?q?4syfMw=5E=26gH=24M?=,fWc+P@GWh1Ja)'J5]In}-=d<
 =?utf-8?q?tj=3A+oV-=23*D=27Bi=0A=094DR=5DF=7CEZH=5EjC/O?=)(Oe<Fc+`f}2^M14u<gK_mw4_wF$xn"~bF!BKsdTiaMs)"
 =?utf-8?q?=3D=5DxT8aC=5FS=3D=0A=09RA=3ATsO?="hfoHvOa%8'u0/6RLTL=-}>=S;uWHI5DiU)YUUnED+B784<x\2*,VR^E>
 =?utf-8?q?3=5Bz=7CIJ=7B=0A=09ftYrhFwU1=26?=<.=`'*vh@
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_cmgyFRDCgerKXQH"
Message-Id: <200702071817.17006.rototor@rototor.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:d84d732d8ddd2281dac05c143a411240
X-Provags-ID2: V01U2FsdGVkX18o1G9lM8mOib1CTN9nPY/eRsZnb7mIGLR1DPM/FkUl9pWb5jBQTC4aR0Wc1NozLT9wbPZMPvenbFOLaLplMbkw7bDY/tgJS9Sj6Q2/5gLWAg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_cmgyFRDCgerKXQH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi there,

we`ve got a database server machine running a 2.6.18.2 vanilla kernel on 
Debian Etch. The database is MySQL 5. Everything works fine, but sometimes 
the server "lags", i.e. it doesn`t respond for 30 seconds. We`ve now 
investigated the problem and found this messages in syslog (and dmesg):

15:55:44 omega11 kernel: ata1: port is slow to respond, please be patient
15:55:44 omega11 kernel: ata1: soft resetting port
15:55:44 omega11 kernel: ata1: port is slow to respond, please be patient
15:55:44 omega11 kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 
300)
15:55:44 omega11 kernel: ATA: abnormal status 0xD0 on port 0xFFFFC2000000401C
15:55:44 omega11 last message repeated 5 times
15:55:44 omega11 kernel: ata1.00: qc timeout (cmd 0xec)
15:55:44 omega11 kernel: ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
15:55:44 omega11 kernel: ata1: failed to recover some devices, retrying in 5 
secs
15:55:44 omega11 kernel: ata1: hard resetting port
15:55:44 omega11 kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 
300)
15:55:44 omega11 kernel: ata1.00: configured for UDMA/133
15:55:44 omega11 kernel: ata1: EH complete
15:55:44 omega11 kernel: SCSI device sda: 293046768 512-byte hdwr sectors 
(150040 MB)
15:55:44 omega11 kernel: sda: Write Protect is off
15:55:44 omega11 kernel: SCSI device sda: drive cache: write back

We`ve got this messages up to 5 times a day since as far as our syslogs reach. 

It seems no kind of queuing is used:
# cat /sys/block/sda/device/queue_type
none
# cat /sys/block/sda/device/queue_depth
1

The server is up for 91 days now and has low to medium load (depending on 
daytime). Since it`s a production server located in a datacenter, we can`t 
just test some random kernel on it :(

Does somebody have a glue whats going on here? Could it be a hardware failure? 
We have an identical machine using the same kernel. It`s used as a webserver. 
There also this messages shows up, but not that often (10 times in 91 days 
uptime). If it is a hardware failure, then both machines would been affected 
by the same hardware problem.

What can we do to fix this problem? Is it known? 

I`ve found many posts related to SATA problems, but none seemed to be about 
this problem.

Do you need additional information?

Thanks

cu,
  Emmy

P.S.: Please CC me, since i`m not subscribed.

--Boundary-00=_cmgyFRDCgerKXQH
Content-Type: text/plain;
  name="lspci.txt"
Content-Transfer-Encoding: 7bit

00:01.0 PCI bridge: Broadcom HT1000 PCI/PCI-X bridge
00:02.0 Host bridge: Broadcom HT1000 Legacy South Bridge
00:02.1 IDE interface: Broadcom HT1000 Legacy IDE controller
00:02.2 ISA bridge: Broadcom HT1000 LPC Bridge
00:03.0 USB Controller: Broadcom HT1000 USB Controller (rev 01)
00:03.1 USB Controller: Broadcom HT1000 USB Controller (rev 01)
00:03.2 USB Controller: Broadcom HT1000 USB Controller (rev 01)
00:04.0 Ethernet controller: Intel Corporation 82541GI/PI Gigabit Ethernet Controller (rev 05)
00:05.0 Ethernet controller: Intel Corporation 82541GI/PI Gigabit Ethernet Controller (rev 05)
00:06.0 VGA compatible controller: XGI - Xabre Graphics Inc Volari Z7
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:0d.0 PCI bridge: Broadcom HT1000 PCI/PCI-X bridge (rev c0)
01:0e.0 RAID bus controller: Broadcom BCM5785 (HT1000) SATA Native SATA Mode

--Boundary-00=_cmgyFRDCgerKXQH
Content-Type: application/x-gzip;
  name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="config.gz"

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
CwEAjNgTirmpAAA=

--Boundary-00=_cmgyFRDCgerKXQH
Content-Type: text/plain;
  name="cpuinfo.txt"
Content-Transfer-Encoding: 7bit

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 33
model name      : Dual Core AMD Opteron(tm) Processor 275
stepping        : 2
cpu MHz         : 2194.616
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni lahf_lm cmp_legacy
bogomips        : 4390.69
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 33
model name      : Dual Core AMD Opteron(tm) Processor 275
stepping        : 2
cpu MHz         : 2194.616
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni lahf_lm cmp_legacy
bogomips        : 4390.11
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

processor       : 2
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 33
model name      : Dual Core AMD Opteron(tm) Processor 275
stepping        : 2
cpu MHz         : 2194.616
cache size      : 1024 KB
physical id     : 1
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni lahf_lm cmp_legacy
bogomips        : 4393.11
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

processor       : 3
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 33
model name      : Dual Core AMD Opteron(tm) Processor 275
stepping        : 2
cpu MHz         : 2194.616
cache size      : 1024 KB
physical id     : 1
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni lahf_lm cmp_legacy
bogomips        : 4393.51
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp


--Boundary-00=_cmgyFRDCgerKXQH--
