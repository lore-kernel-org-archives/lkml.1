Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbYE2Paa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbYE2Paa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYE2PaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:30:20 -0400
Received: from mail.thorsten-knabe.de ([212.60.139.226]:45044 "EHLO
	mail.thorsten-knabe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbYE2PaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:30:17 -0400
X-Greylist: delayed 1495 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 May 2008 11:30:14 EDT
Message-ID: <483EC624.90503@thorsten-knabe.de>
Date: Thu, 29 May 2008 17:05:08 +0200
From: Thorsten Knabe <linux@thorsten-knabe.de>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG] Linux 2.6.25.4 task_struct leak
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------020905070403040806020106"
X-Spam-Report: SpamAssassin@thorsten-knabe.de:
	Content analysis details:   (-2.6 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020905070403040806020106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[1.] One line summary of the problem:
Linux 2.6.25.4 x86_64 task_struct leak on host when running UML
2.6.23.16 compiled for i386

[2.] Full description of the problem/report:
I'm seeing a massive task_struct leak on vanilla Linux 2.6.25.4 x86_64
(64-bit) running User Mode Linux 2.6.23.16 kernels compiled for i386
(32-bit). It seems a task_struct leaks on the HOST for every process
that has been created and destroyed by an UML guest. The task_structs
remain allocated on the host even after the UML guests have been shut
down completely.
Other 32-bit applications do NOT leak task_structs.
Also there is no task_struct leak when running the same 32-bit UML
guests on a Linux 2.6.25.4 i386 (32-bit) host kernel.

[3.] Keywords (i.e., modules, networking, kernel):
task_struct leak, UML

[4.] Kernel information
[4.1.] Kernel version (from /proc/version):
Linux version 2.6.25.4 (tek@tek01) (gcc version 3.3.6 (Debian
1:3.3.6-15)) #2 SMP PREEMPT Sat May 24 21:46:37 CEST 2008

[4.2.] Kernel .config file:
Config attached!

[5.] Most recent kernel version which did not have the bug:
2.6.23.17 does not leak task_structs.
2.6.24 - 2.6.25.3 has not been tested
Running 2.6.23.16 i386 UML on a 2.6.25.4 i386 host does NOT leak
task_structs.
Running 64-bit UML guests has not been tested.

[6.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
No Ooops!

[7.] A small shell script or example program which triggers the
     problem (if possible)
Start 32-bit UML on 64-bit host, then shut it down again. Compare
/proc/slabinfo with number of running tasks/threads.
Before running UML guests, number of active task_structs in
/proc/slabinfo matches number of running tasks/threads on host.
After running and shutting down UML guest differ. I had >500000 active
task_structs in /proc/slabinfo with less than 500 tasks/threads running
on the host.

[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)
Linux tek01 2.6.25.4 #2 SMP PREEMPT Sat May 24 21:46:37 CEST 2008 x86_64
GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
reiserfsprogs          3.6.19
xfsprogs               2.8.11
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
oprofile               0.9.2
Sh-utils               5.97
udev                   105
Modules Loaded         nvidia rfcomm l2cap bluetooth nfs lockd nfs_acl
sunrpc af_packet ppdev lp nf_conntrack_ipv6 ip6t_REJECT ip6t_LOG
ip6table_filter ip6_tables ipt_MASQUERADE xt_tcpudp xt_state ipt_REJECT
ipt_LOG iptable_raw iptable_mangle iptable_nat iptable_filter dm_crypt
crypto_blkcipher dm_snapshot dm_mirror dm_mod deadline_iosched fuse
cryptoloop loop tun zaphfc zaptel crc_ccitt powernow_k8 freq_table
nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack
ip_tables x_tables w83627hf hwmon_vid eeprom i2c_viapro sg sr_mod sbp2
cx88_blackbird cx2341x usbhid snd_via82xx wm8775 gameport
snd_mpu401_uart tuner tea5767 tda8290 tda18271 tda827x tuner_xc2028
xc5000 snd_via82xx_modem snd_ac97_codec ac97_bus firmware_class
snd_seq_oss tda9887 tuner_simple mt20xx tea5761 snd_seq_midi cx88_alsa
snd_pcm_oss snd_mixer_oss snd_rawmidi snd_seq_midi_event snd_pcm snd_seq
firewire_ohci firewire_core cx8802 cx8800 cx88xx ir_common
compat_ioctl32 videodev v4l1_compat hisax snd_timer k8temp
snd_seq_device i2c_algo_bit tveeprom crc_itu_t isdn snd_page_alloc
v4l2_common i2c_core psmouse rtc snd hwmon ehci_hcd parport_pc parport
serio_raw pcspkr uhci_hcd soundcore btcx_risc videobuf_dma_sg
videobuf_core usbcore slhc skge ohci1394 ieee1394 thermal button
processor evdev

[8.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 35
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
stepping        : 2
cpu MHz         : 2200.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt lm 3dnowext 3dnow rep_good pni lahf_lm cmp_legacy
bogomips        : 4409.04
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 35
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
stepping        : 2
cpu MHz         : 2200.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt lm 3dnowext 3dnow rep_good pni lahf_lm cmp_legacy
bogomips        : 4405.71
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp


[8.3.] Module information (from /proc/modules):
Not relevant!

[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
Not relevant!

[8.5.] PCI information ('lspci -vvv' as root)
Not relevant!

[8.6.] SCSI information (from /proc/scsi/scsi)
Not relevant!

[8.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
[X.] Other notes, patches, fixes, workarounds:

Probably some kind of 64-bit kernel running 32-bit user-space
applications, that is only triggered by running UML.

Regards,
Thorsten

-- 
___
 |        | /                 E-Mail: linux@thorsten-knabe.de
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de

--------------020905070403040806020106
Content-Type: application/gzip;
 name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config.gz"

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
--------------020905070403040806020106--
