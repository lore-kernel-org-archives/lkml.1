Return-Path: <linux-kernel-owner+w=401wt.eu-S1750824Ab0AZMVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750824Ab0AZMVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203Ab0AZMVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:21:44 -0500
Received: from helix.bns.it ([81.88.225.36]:35905 "EHLO helix.bns.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab0AZMVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:21:41 -0500
X-Greylist: delayed 1238 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2010 07:21:40 EST
Message-ID: <4B5ED90E.6060304@officineinformatiche.net>
Date: Tue, 26 Jan 2010 12:59:10 +0100
From: Fabio Bas - Officine Informatiche 
	<fabio.bas@officineinformatiche.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100121 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: freeze on ppp connection (using an usb "key" modem)
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:

The kernel freezes when a ppp connection gets estabilished using my usb
key modem.

[2.] Full description of the problem/report:

I'm using a "Vodafone Mobile Connect" (the real producer is "Option" and
the model is "K3760 HSPA USB STICK", FCC ID: NCMOGI0411) usb modem to
create a ppp connection to the Internet.
I connect the usb stick, call "usb_modeswitch" (this is needed to flip
the device from "memory storage" mode to "modem" mode), and then run
"pppd call vodafone".
The connection will tipically work for 10secs to 1 minute, then the
system will look up hard:
- video show a still image
- keyboard leds doesn't switch their state (caps lock, num lock, ...
doesn't work)
- the cpu fan start rotating at full speed.
- No disk/network/other activity at all
I need to "pull the plug" to force a shutdown.

[3.] Keywords (i.e., modules, networking, kernel):

ppp usb stick

[4.] Kernel version (from /proc/version):

root@ambassador:~# cat /proc/version
Linux version 2.6.32.5 (root@midas64) (gcc version 4.4.3 (GCC) ) #2 SMP
Sat Jan 23 14:39:21 CST 2010

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)

No Oops, but this is the kernel log:

Jan 26 12:19:30 ambassador pppd[3893]: pppd 2.4.4 started by root, uid 0
Jan 26 12:19:31 ambassador chat[3896]: send (ATZ^M)
Jan 26 12:19:31 ambassador chat[3896]: expect (OK^M^J)
Jan 26 12:19:31 ambassador chat[3896]: ATZ^M^M
Jan 26 12:19:31 ambassador chat[3896]: OK^M
Jan 26 12:19:31 ambassador chat[3896]:  -- got it
Jan 26 12:19:31 ambassador chat[3896]: send (AT+CGDCONT=1,"IP","internet"^M)
Jan 26 12:19:32 ambassador chat[3896]: expect (OK^M^J)
Jan 26 12:19:32 ambassador chat[3896]: AT+CGDCONT=1,"IP","internet"^M^M
Jan 26 12:19:32 ambassador chat[3896]: OK^M
Jan 26 12:19:32 ambassador chat[3896]:  -- got it
Jan 26 12:19:32 ambassador chat[3896]: send (ATDT*99***1#^M)
Jan 26 12:19:32 ambassador chat[3896]: expect (CONNECT)
Jan 26 12:19:32 ambassador chat[3896]: ATDT*99***1#^M^M
Jan 26 12:19:32 ambassador chat[3896]: CONNECT
Jan 26 12:19:32 ambassador chat[3896]:  -- got it
Jan 26 12:19:32 ambassador chat[3896]: send (^M)
Jan 26 12:19:32 ambassador chat[3896]: expect (^M^J)
Jan 26 12:19:32 ambassador chat[3896]:  7200000^M
Jan 26 12:19:32 ambassador chat[3896]:  -- got it
Jan 26 12:19:32 ambassador pppd[3893]: Serial connection established.
Jan 26 12:19:32 ambassador pppd[3893]: Using interface ppp0
Jan 26 12:19:32 ambassador pppd[3893]: Connect: ppp0 <--> /dev/ttyHS3
Jan 26 12:19:33 ambassador kernel: PPP BSD Compression module registered
Jan 26 12:19:33 ambassador kernel: PPP Deflate Compression module registered
Jan 26 12:19:34 ambassador kernel: scsi 17:0:0:0: Direct-Access
ZCOption HSUPA Modem           PQ: 0 ANSI: 2
Jan 26 12:19:34 ambassador kernel: sd 17:0:0:0: Attached scsi generic
sg2 type 0
Jan 26 12:19:34 ambassador kernel: sd 17:0:0:0: [sdb] 3964928 512-byte
logical blocks: (2.03 GB/1.89 GiB)
Jan 26 12:19:35 ambassador kernel: sd 17:0:0:0: [sdb] Write Protect is off
Jan 26 12:19:35 ambassador kernel:  sdb: sdb1
Jan 26 12:19:35 ambassador kernel: sd 17:0:0:0: [sdb] Attached SCSI
removable disk
Jan 26 12:19:37 ambassador logger: ACPI group battery / action BAT1 is
not defined
Jan 26 12:19:37 ambassador pppd[3893]: local  IP address 83.225.84.161
Jan 26 12:19:37 ambassador pppd[3893]: remote IP address 10.64.64.64
Jan 26 12:19:37 ambassador pppd[3893]: primary   DNS address 83.224.66.138
Jan 26 12:19:37 ambassador pppd[3893]: secondary DNS address 83.224.65.143
Jan 26 12:20:07 ambassador logger: ACPI group battery / action BAT1 is
not defined
Jan 26 12:20:23 ambassador kernel: CPU 1:
Jan 26 12:20:23 ambassador kernel: Pid: 2302, comm: X Not tainted
2.6.32.5 #2 Satellite A210
Jan 26 12:20:23 ambassador kernel: RIP: 0010:[<ffffffff81051e17>]
[<ffffffff81051e17>] __do_softirq+0x67/0x1d0
Jan 26 12:20:23 ambassador kernel: RSP: 0018:ffff880001903ee0  EFLAGS:
00000246
Jan 26 12:20:23 ambassador kernel: RAX: 000000000000dfc0 RBX:
ffff880001903f40 RCX: 0000000000000020
Jan 26 12:20:23 ambassador kernel: RDX: 00000000000ef7b4 RSI:
0000000000002fc8 RDI: 0000000000000380
Jan 26 12:20:23 ambassador kernel: RBP: ffffffff8100c113 R08:
ffff88000190cce0 R09: 0000025c25318890
Jan 26 12:20:23 ambassador kernel: R10: 0000000000000000 R11:
0000000000000000 R12: ffff880001903e60
Jan 26 12:20:23 ambassador kernel: R13: 0000000000000001 R14:
0000000000000286 R15: 0000000000000202
Jan 26 12:20:23 ambassador kernel: FS:  00007f97089ee740(0000)
GS:ffff880001900000(0000) knlGS:0000000000000000
Jan 26 12:20:23 ambassador kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Jan 26 12:20:23 ambassador kernel: CR2: 00007f027c4af000 CR3:
0000000072cc2000 CR4: 00000000000006e0
Jan 26 12:20:23 ambassador kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jan 26 12:20:23 ambassador kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jan 26 12:20:26 ambassador kernel: CPU 1:
Jan 26 12:20:26 ambassador kernel: Pid: 0, comm: swapper Not tainted
2.6.32.5 #2 Satellite A210
Jan 26 12:20:26 ambassador kernel: RIP: 0010:[<ffffffffa0249d84>]
[<ffffffffa0249d84>] ppp_xmit_process+0x4b4/0x5d0 [ppp_generic]
Jan 26 12:20:26 ambassador kernel: RSP: 0018:ffff880001903830  EFLAGS:
00000247
Jan 26 12:20:26 ambassador kernel: RAX: ffff88007da0ae80 RBX:
ffff8800019038a0 RCX: 000000000000000a
Jan 26 12:20:26 ambassador kernel: RDX: 000000000000d3d3 RSI:
0000000000000286 RDI: ffff880020c2ae1c
Jan 26 12:20:26 ambassador kernel: RBP: ffffffff8100c113 R08:
0000000000388c80 R09: ffff88007eda8950
Jan 26 12:20:26 ambassador kernel: R10: 0000000000000038 R11:
000000005ef0a038 R12: ffff8800019037b0
Jan 26 12:20:26 ambassador kernel: R13: ffff88005ef2ec00 R14:
0000000000000021 R15: 0000000000000000
Jan 26 12:20:26 ambassador kernel: FS:  00007f4be2ace780(0000)
GS:ffff880001900000(0000) knlGS:0000000000000000
Jan 26 12:20:26 ambassador kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Jan 26 12:20:26 ambassador kernel: CR2: 00007f02767e1000 CR3:
000000006eab6000 CR4: 00000000000006e0
Jan 26 12:20:26 ambassador kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jan 26 12:20:26 ambassador kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400

[6.] A small shell script or example program which triggers the
     problem (if possible)

doesn't apply

[7.] Environment

Toshiba Satellite A210, running Slackware64-current (glibc-2.11.1,
ppp-2.4.4).

[7.1.] Software (add the output of the ver_linux script here)

bash-3.1# ./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux ambassador 2.6.32.5 #2 SMP Sat Jan 23 14:39:21 CST 2010 x86_64 AMD
Turion(tm) 64 X2 Mobile Technology TL-64 AuthenticAMD GNU/Linux


Gnu C                  4.4.3
Gnu make               3.81
binutils               2.18.50.0.9.20080822
util-linux             2.14.2
mount                  support
module-init-tools      3.6
e2fsprogs              1.41.8
jfsutils               1.1.14
reiserfsprogs          3.6.21
xfsprogs               3.0.1
pcmciautils            015
quota-tools            3.17.
PPP                    2.4.4
Linux C Library        2.11.1
Dynamic linker (ldd)   2.11.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.15
oprofile               0.9.4
Sh-utils               7.4
wireless-tools         29
Modules Loaded         radeon ttm drm_kms_helper drm i2c_algo_bit
vboxnetadp vboxnetflt vboxdrv snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6
cpufreq_ondemand powernow_k8 freq_table agpgart ppdev lp parport_pc
parport usbhid hid fuse ath5k mac80211 ath snd_hda_codec_atihdmi
cfg80211 snd_hda_codec_realtek wlan_scan_sta ath_rate_sample uvcvideo
snd_hda_intel snd_hda_codec joydev videodev v4l1_compat
v4l2_compat_ioctl32 ohci_hcd ath_pci ssb yenta_socket pcmcia snd_hwdep
sdhci_pci rsrc_nonstatic r8169 wlan snd_pcm sdhci video ohci1394
ehci_hcd ieee1394 processor tifm_7xx1 i2c_piix4 mmc_core tifm_core
snd_timer ath_hal rtc_cmos led_class psmouse mii thermal battery
pcmcia_core ac i2c_core rtc_core rtc_lib evdev snd button thermal_sys
output k8temp soundcore hwmon serio_raw snd_page_alloc rfkill sg reiserfs


[7.2.] Processor information (from /proc/cpuinfo):

root@ambassador:~# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 104
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-64
stepping        : 2
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt rdtscp lm 3dnowext 3dnow rep_good extd_apicid pni cx16 lahf_lm
cmp_legacy svm extapic cr8_legacy 3dnowprefetch
bogomips        : 1595.97
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 104
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-64
stepping        : 2
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt rdtscp lm 3dnowext 3dnow rep_good extd_apicid pni cx16 lahf_lm
cmp_legacy svm extapic cr8_legacy 3dnowprefetch
bogomips        : 1595.97
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps

[7.3.] Module information (from /proc/modules):

root@ambassador:~# cat /proc/modules
hso 32145 0 - Live 0xffffffffa0205000
usb_storage 42412 0 - Live 0xffffffffa019a000
radeon 567035 2 - Live 0xffffffffa07d9000
ttm 37476 1 radeon, Live 0xffffffffa0125000
drm_kms_helper 22633 1 radeon, Live 0xffffffffa00a8000
drm 156921 5 radeon,ttm,drm_kms_helper, Live 0xffffffffa07b0000
i2c_algo_bit 5175 1 radeon, Live 0xffffffffa003b000
vboxnetadp 5041 0 - Live 0xffffffffa07ac000
vboxnetflt 12143 0 - Live 0xffffffffa07a3000
vboxdrv 1729142 2 vboxnetadp,vboxnetflt, Live 0xffffffffa05ec000
snd_seq_dummy 1487 0 - Live 0xffffffffa05e6000
snd_seq_oss 29927 0 - Live 0xffffffffa05d7000
snd_seq_midi_event 5620 1 snd_seq_oss, Live 0xffffffffa05d0000
snd_seq 52132 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live
0xffffffffa05ba000
snd_seq_device 5427 3 snd_seq_dummy,snd_seq_oss,snd_seq, Live
0xffffffffa05b3000
snd_pcm_oss 39783 0 - Live 0xffffffffa05a2000

snd_mixer_oss 15851 1 snd_pcm_oss, Live 0xffffffffa0598000

ipv6 276011 12 - Live 0xffffffffa0541000

cpufreq_ondemand 8373 1 - Live 0xffffffffa0538000

powernow_k8 11198 1 - Live 0xffffffffa052a000

freq_table 2475 2 cpufreq_ondemand,powernow_k8, Live 0xffffffffa051c000

agpgart 29509 2 ttm,drm, Live 0xffffffffa050c000

ppdev 5988 0 - Live 0xffffffffa0505000

lp 9333 0 - Live 0xffffffffa04fc000

parport_pc 21139 0 - Live 0xffffffffa04ef000

parport 29923 3 ppdev,lp,parport_pc, Live 0xffffffffa04e0000

usbhid 37029 0 - Live 0xffffffffa04cf000

hid 75251 1 usbhid, Live 0xffffffffa04b5000

fuse 59591 1 - Live 0xffffffffa049d000

ath5k 128418 0 - Live 0xffffffffa0474000

mac80211 166039 1 ath5k, Live 0xffffffffa043e000

ath 8480 1 ath5k, Live 0xffffffffa0436000

snd_hda_codec_atihdmi 2731 1 - Live 0xffffffffa0430000

cfg80211 124475 3 ath5k,mac80211,ath, Live 0xffffffffa0405000

snd_hda_codec_realtek 250563 1 - Live 0xffffffffa03b9000

wlan_scan_sta 12987 0 - Live 0xffffffffa03af000

ath_rate_sample 11940 1 - Live 0xffffffffa03a7000

uvcvideo 60854 0 - Live 0xffffffffa0391000

snd_hda_intel 21256 3 - Live 0xffffffffa0384000

snd_hda_codec 63311 3
snd_hda_codec_atihdmi,snd_hda_codec_realtek,snd_hda_intel, Live
0xffffffffa036a000
joydev 10162 0 - Live 0xffffffffa0362000

videodev 35895 1 uvcvideo, Live 0xffffffffa0353000

v4l1_compat 15152 2 uvcvideo,videodev, Live 0xffffffffa034a000

v4l2_compat_ioctl32 11097 1 videodev, Live 0xffffffffa0342000

ohci_hcd 23681 0 - Live 0xffffffffa0336000

ath_pci 198264 0 - Live 0xffffffffa02fb000

ssb 47693 1 ohci_hcd, Live 0xffffffffa02e7000
yenta_socket 21509 1 - Live 0xffffffffa02da000
pcmcia 31289 1 ssb, Live 0xffffffffa02cb000
snd_hwdep 6424 1 snd_hda_codec, Live 0xffffffffa02c3000
sdhci_pci 6182 0 - Live 0xffffffffa02bc000
rsrc_nonstatic 9021 1 yenta_socket, Live 0xffffffffa02b4000
r8169 37738 0 - Live 0xffffffffa02a3000
wlan 222698 4 wlan_scan_sta,ath_rate_sample,ath_pci, Live 0xffffffffa025d000
snd_pcm 71548 3 snd_pcm_oss,snd_hda_intel,snd_hda_codec, Live
0xffffffffa0241000
sdhci 15886 1 sdhci_pci, Live 0xffffffffa0237000
video 18469 0 - Live 0xffffffffa022b000
ohci1394 28617 0 - Live 0xffffffffa021e000
ehci_hcd 35982 0 - Live 0xffffffffa020f000
ieee1394 74328 1 ohci1394, Live 0xffffffffa01f0000
processor 30266 1 powernow_k8, Live 0xffffffffa01e0000
tifm_7xx1 4474 0 - Live 0xffffffffa01d9000
i2c_piix4 8789 0 - Live 0xffffffffa01d1000
mmc_core 54004 2 ssb,sdhci, Live 0xffffffffa01ba000
tifm_core 5098 1 tifm_7xx1, Live 0xffffffffa01b2000
snd_timer 19154 2 snd_seq,snd_pcm, Live 0xffffffffa01a7000
ath_hal 422300 3 ath_rate_sample,ath_pci, Live 0xffffffffa0130000
rtc_cmos 9192 0 - Live 0xffffffffa0120000
led_class 2753 2 ath5k,sdhci, Live 0xffffffffa011a000
psmouse 50316 0 - Live 0xffffffffa0105000
mii 3882 1 r8169, Live 0xffffffffa00ff000
thermal 12362 0 - Live 0xffffffffa00f5000
battery 9884 0 - Live 0xffffffffa00ec000
pcmcia_core 29052 4 ssb,yenta_socket,pcmcia,rsrc_nonstatic, Live
0xffffffffa00dc000
ac 3171 0 - Live 0xffffffffa00d6000
i2c_core 18846 5 radeon,drm,i2c_algo_bit,videodev,i2c_piix4, Live
0xffffffffa00ca000
rtc_core 14599 1 rtc_cmos, Live 0xffffffffa00bf000
rtc_lib 1922 1 rtc_core, Live 0xffffffffa00b9000
evdev 9187 11 - Live 0xffffffffa00b0000
snd 57024 17
snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer,
Live 0xffffffffa0098000
button 4957 0 - Live 0xffffffffa0091000
thermal_sys 13964 3 video,processor,thermal, Live 0xffffffffa0087000
output 1964 1 video, Live 0xffffffffa0081000
k8temp 3457 0 - Live 0xffffffffa007b000
soundcore 5743 1 snd, Live 0xffffffffa0073000
hwmon 1449 2 thermal_sys,k8temp, Live 0xffffffffa006d000
serio_raw 4526 0 - Live 0xffffffffa0066000
snd_page_alloc 7081 2 snd_hda_intel,snd_pcm, Live 0xffffffffa005f000
rfkill 15762 2 hso,cfg80211, Live 0xffffffffa0054000
sg 25797 0 - Live 0xffffffffa0046000
reiserfs 231961 3 - Live 0xffffffffa0000000


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

root@ambassador:~# cat /proc/ioports


0000-001f : dma1


0020-0021 : pic1


0040-0043 : timer0


0050-0053 : timer1


0060-0060 : keyboard


0064-0064 : keyboard


0070-0071 : rtc0


0080-008f : dma page reg


00a0-00a1 : pic2


00c0-00df : dma2


00f0-00ff : fpu


0170-0177 : 0000:00:14.1


  0170-0177 : pata_atiixp


01f0-01f7 : 0000:00:14.1


  01f0-01f7 : pata_atiixp


0220-022f : pnp 00:08


0376-0376 : 0000:00:14.1


  0376-0376 : pata_atiixp


03c0-03df : vesafb


03f6-03f6 : 0000:00:14.1


  03f6-03f6 : pata_atiixp


040b-040b : pnp 00:08


04d0-04d1 : pnp 00:08


04d6-04d6 : pnp 00:08


0530-0537 : pnp 00:08


087f-087f : pnp 00:08


0c00-0c01 : pnp 00:08
0c14-0c14 : pnp 00:08
0c50-0c52 : pnp 00:08
0c6c-0c6c : pnp 00:08
0c6f-0c6f : pnp 00:08
0cd0-0cd1 : pnp 00:08
0cd2-0cd3 : pnp 00:08
0cd4-0cd5 : pnp 00:08
0cd6-0cd7 : pnp 00:08
0cd8-0cdf : pnp 00:08
0cf8-0cff : PCI conf1
0f40-0f47 : pnp 00:08
1080-1080 : pnp 00:08
2000-2fff : PCI Bus 0000:08
3000-3fff : PCI Bus 0000:1a
  3000-30ff : PCI CardBus 0000:1b
  3400-34ff : PCI CardBus 0000:1b
8000-805f : pnp 00:08
  8000-8003 : ACPI PM1a_EVT_BLK
  8004-8005 : ACPI PM1a_CNT_BLK
  8008-800b : ACPI PM_TMR
  8010-8015 : ACPI CPU throttle
  8020-8027 : ACPI GPE0_BLK
8104-8107 : ACPI PM1b_EVT_BLK
8200-8200 : ACPI PM2_CNT_BLK
8400-840f : 0000:00:12.0
  8400-840f : ahci
8410-841f : 0000:00:14.0
  8410-8417 : piix4_smbus
8420-842f : 0000:00:14.1
  8420-842f : pata_atiixp
8430-8433 : 0000:00:12.0
  8430-8433 : ahci
8434-8437 : 0000:00:12.0
  8434-8437 : ahci
8438-843f : 0000:00:12.0
  8438-843f : ahci
8440-8447 : 0000:00:12.0
  8440-8447 : ahci
9000-9fff : PCI Bus 0000:01
  9000-90ff : 0000:01:00.0
a000-afff : PCI Bus 0000:0e
  a000-a0ff : 0000:0e:00.0
    a000-a0ff : r8169
fd60-fddf : pnp 00:08

root@ambassador:~# cat /proc/iomem


00000000-0009dbff : System RAM


0009dc00-0009ffff : reserved


000d2000-000fffff : reserved


00100000-7fe6ffff : System RAM


  01000000-013e46ab : Kernel code


  013e46ac-015f1aaf : Kernel data


  01689000-01710183 : Kernel bss


7fe70000-7fe82fff : ACPI Tables


7fe83000-7fe84fff : ACPI Non-volatile Storage


7fe85000-7fffffff : reserved


80000000-83ffffff : PCI Bus 0000:1a


  80000000-83ffffff : PCI CardBus 0000:1b


84000000-841fffff : PCI Bus 0000:08


84200000-843fffff : PCI Bus 0000:08


84400000-844fffff : PCI Bus 0000:0e


  84400000-8441ffff : 0000:0e:00.0


88000000-8bffffff : PCI CardBus 0000:1b


cf5f6800-cf5f68ff : 0000:00:13.5


  cf5f6800-cf5f68ff : ehci_hcd


cf5f6c00-cf5f6fff : 0000:00:12.0


  cf5f6c00-cf5f6fff : ahci


cf5f7000-cf5f7fff : 0000:00:13.4


  cf5f7000-cf5f7fff : ohci_hcd
cf5f8000-cf5f8fff : 0000:00:13.3
  cf5f8000-cf5f8fff : ohci_hcd
cf5f9000-cf5f9fff : 0000:00:13.2
  cf5f9000-cf5f9fff : ohci_hcd
cf5fa000-cf5fafff : 0000:00:13.1
  cf5fa000-cf5fafff : ohci_hcd
cf5fb000-cf5fbfff : 0000:00:13.0
  cf5fb000-cf5fbfff : ohci_hcd
cf5fc000-cf5fffff : 0000:00:14.2
  cf5fc000-cf5fffff : ICH HD audio
cf800000-cf8fffff : PCI Bus 0000:0e
  cf8ff000-cf8fffff : 0000:0e:00.0
    cf8ff000-cf8fffff : r8169
cfa00000-cfafffff : PCI Bus 0000:1a
  cfaf9400-cfaf94ff : 0000:1a:04.3
    cfaf9400-cfaf94ff : mmc0
  cfaf9800-cfaf9fff : 0000:1a:04.1
    cfaf9800-cfaf9fff : ohci1394
  cfafa000-cfafafff : 0000:1a:04.2
    cfafa000-cfafafff : tifm_7xx1
  cfafb000-cfafbfff : 0000:1a:04.0
    cfafb000-cfafbfff : yenta_socket
  cfafc000-cfafffff : 0000:1a:04.1
cfc00000-cfcfffff : PCI Bus 0000:14
  cfcf0000-cfcfffff : 0000:14:00.0
    cfcf0000-cfcfffff : ath
cfe00000-cfefffff : PCI Bus 0000:01
  cfe00000-cfe1ffff : 0000:01:00.0
  cfeec000-cfeeffff : 0000:01:00.1
    cfeec000-cfeeffff : ICH HD audio
  cfef0000-cfefffff : 0000:01:00.0
d0000000-dfffffff : PCI Bus 0000:01
  d0000000-dfffffff : 0000:01:00.0
    d0000000-d0ffffff : vesafb
e0000000-efffffff : reserved
  e0000000-e1afffff : PCI MMCONFIG 0 [00-1a]
fec00000-fec0ffff : reserved
  fec00000-fec00fff : IOAPIC 0
fed00000-fed003ff : HPET 2
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:01
fff00000-ffffffff : reserved
  fff00000-ffffffff : pnp 00:09


[7.5.] PCI information ('lspci -vvv' as root)

root@ambassador:~# lspci -vvv


00:00.0 Host bridge: ATI Technologies Inc RS690 Host Bridge


        Subsystem: Toshiba America Info Systems Device ff00


        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-

        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-

        Latency: 64



00:02.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI
Express Graphics Port 0) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes

        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0

        I/O behind bridge: 00009000-00009fff

        Memory behind bridge: cfe00000-cfefffff

        Prefetchable memory behind bridge:
00000000d0000000-00000000dfffffff

        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-

                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

        Capabilities: [50] Power Management version 3

                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

        Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00

                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag+ RBE+ FLReset-

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+

                        MaxPayload 128 bytes, MaxReadReq 128 bytes

                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep+ BwNot-

                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled-
Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surpise-
                        Slot #  2, PowerLimit 75.000000; Interlock-
NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Off, PwrInd Off, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState-

                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-

                RootSta: PME ReqID 0000, PMEStatus- PMEPending-

        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-

                Address: fee0300c  Data: 4151

        Capabilities: [b0] Subsystem: Toshiba America Info Systems
Device ff00
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+

        Capabilities: [100] Virtual Channel <?>

        Kernel driver in use: pcieport

        Kernel modules: shpchp


00:05.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI
Express Port 1) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes

        Bus: primary=00, secondary=08, subordinate=0d, sec-latency=0

        I/O behind bridge: 00002000-00002fff

        Memory behind bridge: 84000000-841fffff

        Prefetchable memory behind bridge:
0000000084200000-00000000843fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-

                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

        Capabilities: [50] Power Management version 3

                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

        Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00

                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag+ RBE+ FLReset-

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+

                        MaxPayload 128 bytes, MaxReadReq 128 bytes

                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
                LnkCap: Port #247, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep+ BwNot-

                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surpise+
                        Slot #  4, PowerLimit 25.000000; Interlock-
NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Off, PwrInd Off, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-

                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-

                RootSta: PME ReqID 0000, PMEStatus- PMEPending-

        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-

                Address: fee0300c  Data: 4159

        Capabilities: [b0] Subsystem: Toshiba America Info Systems
Device ff00
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+

        Capabilities: [100] Virtual Channel <?>

        Kernel driver in use: pcieport

        Kernel modules: shpchp


00:06.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI
Express Port 2) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes

        Bus: primary=00, secondary=0e, subordinate=0e, sec-latency=0

        I/O behind bridge: 0000a000-0000afff

        Memory behind bridge: cf800000-cf8fffff

        Prefetchable memory behind bridge:
0000000084400000-00000000844fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-

                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

        Capabilities: [50] Power Management version 3

                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

        Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00

                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag+ RBE+ FLReset-

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+

                        MaxPayload 128 bytes, MaxReadReq 128 bytes

                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
                LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep+ BwNot-

                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surpise-
                        Slot #  6, PowerLimit 25.000000; Interlock-
NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Off, PwrInd Off, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState-

                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-

                RootSta: PME ReqID 0000, PMEStatus- PMEPending-

        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-

                Address: fee0300c  Data: 4161

        Capabilities: [b0] Subsystem: Toshiba America Info Systems
Device ff00
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+

        Capabilities: [100] Virtual Channel <?>

        Kernel driver in use: pcieport

        Kernel modules: shpchp


00:07.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI
Express Port 3) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes

        Bus: primary=00, secondary=14, subordinate=14, sec-latency=0

        I/O behind bridge: 0000f000-00000fff

        Memory behind bridge: cfc00000-cfcfffff

        Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-

                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

        Capabilities: [50] Power Management version 3

                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

        Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00

                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag+ RBE+ FLReset-

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+

                        MaxPayload 128 bytes, MaxReadReq 128 bytes

                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
                LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep+ BwNot-

                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surpise-
                        Slot #  6, PowerLimit 25.000000; Interlock-
NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Off, PwrInd Off, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState-

                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-

                RootSta: PME ReqID 0000, PMEStatus- PMEPending-

        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-

                Address: fee0300c  Data: 4169

        Capabilities: [b0] Subsystem: Toshiba America Info Systems
Device ff00
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+

        Capabilities: [100] Virtual Channel <?>

        Kernel driver in use: pcieport

        Kernel modules: shpchp


00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
(prog-if 01 [AHCI 1.0])
        Subsystem: Toshiba America Info Systems Device ff00

        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64

        Interrupt: pin A routed to IRQ 22

        Region 0: I/O ports at 8440 [size=8]

        Region 1: I/O ports at 8434 [size=4]

        Region 2: I/O ports at 8438 [size=8]

        Region 3: I/O ports at 8430 [size=4]

        Region 4: I/O ports at 8400 [size=16]

        Region 5: Memory at cf5f6c00 (32-bit, non-prefetchable)
[size=1K]
        Capabilities: [60] Power Management version 2

                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

        Kernel driver in use: ahci


00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0) (prog-if
10 [OHCI])
        Subsystem: Toshiba America Info Systems Device ff00

        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 32 bytes

        Interrupt: pin A routed to IRQ 16

        Region 0: Memory at cf5fb000 (32-bit, non-prefetchable)
[size=4K]
        Kernel driver in use: ohci_hcd

        Kernel modules: ohci-hcd


00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1) (prog-if
10 [OHCI])
        Subsystem: Toshiba America Info Systems Device ff00

        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 32 bytes

        Interrupt: pin B routed to IRQ 17

        Region 0: Memory at cf5fa000 (32-bit, non-prefetchable)
[size=4K]
        Kernel driver in use: ohci_hcd

        Kernel modules: ohci-hcd


00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2) (prog-if
10 [OHCI])
        Subsystem: Toshiba America Info Systems Device ff00

        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 32 bytes

        Interrupt: pin C routed to IRQ 18

        Region 0: Memory at cf5f9000 (32-bit, non-prefetchable)
[size=4K]
        Kernel driver in use: ohci_hcd

        Kernel modules: ohci-hcd


00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3) (prog-if
10 [OHCI])
        Subsystem: Toshiba America Info Systems Device ff00

        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 32 bytes

        Interrupt: pin B routed to IRQ 17

        Region 0: Memory at cf5f8000 (32-bit, non-prefetchable)
[size=4K]
        Kernel driver in use: ohci_hcd

        Kernel modules: ohci-hcd


00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4) (prog-if
10 [OHCI])
        Subsystem: Toshiba America Info Systems Device ff00

        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 32 bytes

        Interrupt: pin C routed to IRQ 18

        Region 0: Memory at cf5f7000 (32-bit, non-prefetchable)
[size=4K]
        Kernel driver in use: ohci_hcd

        Kernel modules: ohci-hcd


00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
(prog-if 20 [EHCI])
        Subsystem: Toshiba America Info Systems Device ff00

        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes

        Interrupt: pin D routed to IRQ 19

        Region 0: Memory at cf5f6800 (32-bit, non-prefetchable)
[size=256]
        Capabilities: [c0] Power Management version 2

                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

                Bridge: PM- B3+

        Capabilities: [e4] Debug port: BAR=1 offset=00e0

        Kernel driver in use: ehci_hcd

        Kernel modules: ehci-hcd


00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
        Subsystem: Toshiba America Info Systems Device ff00
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Region 0: I/O ports at 8410 [size=16]

        Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+

        Kernel driver in use: piix4_smbus

        Kernel modules: i2c-piix4


00:14.1 IDE interface: ATI Technologies Inc SB600 IDE (prog-if 8a
[Master SecP PriP])
        Subsystem: Toshiba America Info Systems Device ff00

        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64

        Interrupt: pin A routed to IRQ 16

        Region 0: I/O ports at 01f0 [size=8]

        Region 1: I/O ports at 03f4 [size=1]

        Region 2: I/O ports at 0170 [size=8]

        Region 3: I/O ports at 0374 [size=1]

        Region 4: I/O ports at 8420 [size=16]

        Kernel driver in use: pata_atiixp


00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
        Subsystem: Toshiba America Info Systems Device ff08
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 32 bytes

        Interrupt: pin ? routed to IRQ 16

        Region 0: Memory at cf5fc000 (64-bit, non-prefetchable)
[size=16K]
        Capabilities: [50] Power Management version 2

                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

        Kernel driver in use: HDA Intel

        Kernel modules: snd-hda-intel


00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
        Subsystem: Toshiba America Info Systems Device ff00
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0


00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64

        Bus: primary=00, secondary=1a, subordinate=1e, sec-latency=64

        I/O behind bridge: 00003000-00003fff

        Memory behind bridge: cfa00000-cfafffff

        Prefetchable memory behind bridge: 80000000-83ffffff

        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-


00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: [80] HyperTransport: Host or Secondary Interface

                Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+
Slave- <EOCErr- DUL-
                Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO-
<CRCErr=8 IsocEn- LSEn+ ExtCTL- 64b-
                Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut-
LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
                Revision ID: 1.02

                Link Frequency: 800MHz

                Link Error: <Prot- <Ovfl- <EOC- CTLTm-

                Link Frequency Capability: 200MHz+ 300MHz- 400MHz+
500MHz- 600MHz+ 800MHz+ 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA-
UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Address Map
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
DRAM Controller
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: [f0] Secure device <?>

        Kernel driver in use: k8temp

        Kernel modules: k8temp


01:00.0 VGA compatible controller: ATI Technologies Inc M76 [Radeon
Mobility HD 2600 Series] (prog-if 00 [VGA controller])
        Subsystem: Toshiba America Info Systems Device ff00

        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes

        Interrupt: pin A routed to IRQ 18

        Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]

        Region 1: I/O ports at 9000 [size=256]

        Region 2: Memory at cfef0000 (32-bit, non-prefetchable)
[size=64K]
        [virtual] Expansion ROM at cfe00000 [disabled] [size=128K]

        Capabilities: [50] Power Management version 3

                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

        Capabilities: [58] Express (v1) Legacy Endpoint, MSI 00

                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+

                        MaxPayload 128 bytes, MaxReadReq 128 bytes

                DevSta: CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-

                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled-
Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+

                Address: 0000000000000000  Data: 0000

        Capabilities: [100] Vendor Specific Information <?>


01:00.1 Audio device: ATI Technologies Inc RV630/M76 audio device
[Radeon HD 2600 Series]
        Subsystem: ATI Technologies Inc RV630/M76 audio device [Radeon
HD 2600 Series]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes

        Interrupt: pin B routed to IRQ 19

        Region 0: Memory at cfeec000 (32-bit, non-prefetchable)
[size=16K]
        Capabilities: [50] Power Management version 3

                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

        Capabilities: [58] Express (v1) Legacy Endpoint, MSI 00

                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+

                        MaxPayload 128 bytes, MaxReadReq 128 bytes

                DevSta: CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-

                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled-
Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+

                Address: 0000000000000000  Data: 0000

        Capabilities: [100] Vendor Specific Information <?>

        Kernel driver in use: HDA Intel

        Kernel modules: snd-hda-intel


0e:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 01)
        Subsystem: Toshiba America Info Systems Device ff00

        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes

        Interrupt: pin A routed to IRQ 28

        Region 0: I/O ports at a000 [size=256]

        Region 2: Memory at cf8ff000 (64-bit, non-prefetchable)
[size=4K]
        [virtual] Expansion ROM at 84400000 [disabled] [size=128K]

        Capabilities: [40] Power Management version 2

                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

        Capabilities: [48] Vital Product Data

                Unknown small resource type 05, will not decode more.

        Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+

                Address: 00000000fee0300c  Data: 4199

        Capabilities: [60] Express (v1) Endpoint, MSI 00

                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<128ns, L1 unlimited
                        ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+

                        MaxPayload 128 bytes, MaxReadReq 128 bytes

                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s,
Latency L0 unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot-

                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [84] Vendor Specific Information <?>

        Capabilities: [100] Advanced Error Reporting

                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap-
ChkEn-
        Capabilities: [12c] Virtual Channel <?>

        Capabilities: [148] Device Serial Number 02-00-00-00-10-ec-81-36

        Capabilities: [154] Power Budgeting <?>

        Kernel driver in use: r8169

        Kernel modules: r8169


14:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless
Network Adapter (rev 01)
        Subsystem: Askey Computer Corp. Device 7128

        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes

        Interrupt: pin A routed to IRQ 19

        Region 0: Memory at cfcf0000 (64-bit, non-prefetchable)
[size=64K]
        Capabilities: [40] Power Management version 2

                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-

                Address: 00000000  Data: 0000

        Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00

                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-

                        MaxPayload 128 bytes, MaxReadReq 512 bytes

                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot-

                LnkCtl: ASPM L1 Enabled; RCB 128 bytes Disabled-
Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [90] MSI-X: Enable- Count=1 Masked-

                Vector table: BAR=0 offset=00000000

                PBA: BAR=0 offset=00000000

        Capabilities: [100] Advanced Error Reporting

                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+
ChkEn-
        Capabilities: [140] Virtual Channel <?>

        Kernel driver in use: ath_pci

        Kernel modules: ath_pci, ath5k


1a:04.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
        Subsystem: Toshiba America Info Systems Device ff00
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168, Cache Line Size: 64 bytes

        Interrupt: pin A routed to IRQ 20

        Region 0: Memory at cfafb000 (32-bit, non-prefetchable)
[size=4K]
        Bus: primary=1a, secondary=1b, subordinate=1e, sec-latency=176

        Memory window 0: 80000000-83fff000 (prefetchable)

        Memory window 1: 88000000-8bfff000

        I/O window 0: 00003000-000030ff

        I/O window 1: 00003400-000034ff

        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+
PostWrite+
        16-bit legacy interface ports at 0001
        Kernel driver in use: yenta_cardbus
        Kernel modules: yenta_socket

1a:04.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant
IEEE 1394 Host Controller (prog-if 10 [OHCI])
        Subsystem: Toshiba America Info Systems Device ff00
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (500ns min, 1000ns max), Cache Line Size: 32 bytes
        Interrupt: pin B routed to IRQ 21
        Region 0: Memory at cfaf9800 (32-bit, non-prefetchable) [size=2K]
        Region 1: Memory at cfafc000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
        Kernel driver in use: ohci1394
        Kernel modules: ohci1394

1a:04.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia
Card Reader (SD/MMC/MS/MS PRO/xD)
        Subsystem: Toshiba America Info Systems Device ff00
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (1750ns min, 1000ns max), Cache Line Size: 32 bytes
        Interrupt: pin C routed to IRQ 22
        Region 0: Memory at cfafa000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: tifm_7xx1
        Kernel modules: tifm_7xx1

1a:04.3 SD Host controller: Texas Instruments PCIxx12 SDA Standard
Compliant SD Host Controller (prog-if 01)
        Subsystem: Toshiba America Info Systems Device ff00
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (1750ns min, 1000ns max), Cache Line Size: 32 bytes
        Interrupt: pin C routed to IRQ 22
        Region 0: Memory at cfaf9400 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: sdhci-pci
        Kernel modules: sdhci-pci

[7.6.] SCSI information (from /proc/scsi/scsi)

root@ambassador:~# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Hitachi HTS54252 Rev: BBFO
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: MATSHITA Model: DVD-RAM UJ-850S  Rev: 1.40
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi17 Channel: 00 Id: 00 Lun: 00
  Vendor: ZCOption Model: HSUPA Modem      Rev:
  Type:   Direct-Access                    ANSI  SCSI revision: 02

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

root@ambassador:~# lsusb -v -s 001:005


Bus 001 Device 005: ID 0af0:7501 Option
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  idVendor           0x0af0 Option
  idProduct          0x7501
  bcdDevice            0.00
  iManufacturer           2 Option N.V.
  iProduct                1 Globetrotter HSUPA Modem
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          269
    bNumInterfaces         11
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x06  EP 6 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        6
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x87  EP 7 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x07  EP 7 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        7
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x88  EP 8 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x08  EP 8 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        8
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x89  EP 9 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x09  EP 9 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        9
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8a  EP 10 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               5
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8b  EP 11 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x0a  EP 10 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber       10
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x0b  EP 11 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8c  EP 12 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

[X.] Other notes, patches, fixes, workarounds:

The last working kernel i'm aware of is kernel 2.6.30, the first showing
the problem 2.6.32.2

