Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0BJNeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 08:34:25 -0500
Received: from mail-yw0-f173.google.com ([209.85.211.173]:59481 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0BJNeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 08:34:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tm3/vr+fLcP+WP8SVVr0hI/U/wIn8b2zvCut8PsK+6xMYrQ39NaoX773R8TxF7LMh/
         K6QoQm5HqUzvI7TQ5z5PczkLZEFcHpSAaS8xEK/iHjHR1549Y2IfEjy3f/84BnYQdSrd
         fde30oCchqHtG/+ybRSiwzk8kYCpfUSuXL4Tk=
MIME-Version: 1.0
Date: Wed, 10 Feb 2010 13:28:19 +0000
Message-ID: <5e9233071002100528u72aef9c3g6ccac7872804a5ec@mail.gmail.com>
Subject: PROBLEM: heavy network traffic triggers system crash
From: Kovalev Igor <iakovalev@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6465196ffb9a3047f3f0198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6465196ffb9a3047f3f0198
Content-Type: text/plain; charset=ISO-8859-1

1. Summary: heavy network traffic triggers "recvmsg bug" and system crash

2. Have being running Ubuntu (9.04 to 9.10) on Toshiba Satellite
L40-139 laptop. Heavy network traffic systematically triggers a crash
(either kernel panic or segmentation fault). Among applications that
have triggered system crash are: firefox (all versions since 3.2.3);
system update manager, a Java-based application downloading via
http/ftp. Usually the problem appears while downloading at speed of
150kBytes/s or more within  20-30 min. Just before the moment of
crash, tons of messages like:
Feb  3 02:30:04 kovalev-home kernel: [35474.511460] recvmsg bug:
copied BFA5DAF9 seq BFA5E0A1
fill up system logs (preceeded with application warning).
The problem has been observed first with kernel 2.6.28-13 and persists
through 2.6.31-19, all have been installed from official Ubuntu
repositories. Network connection is via Atheros AR5007eg wireless
(reported as AR5001 by ath5k), with several different routers and
providers. Since Windows Vista had never crashed by similar network
traffic on this machine, this doesn't look like a hardware fault.

Examples of warning right before crash (syslog):
---------------
Feb  2 12:51:38 kovalev-home kernel: [76478.454177] WARNING: at
/build/buildd/linux-2.6.31/net/ipv4/tcp.c:1408
tcp_recvmsg+0xa49/0xb20()
Feb  2 12:51:38 kovalev-home kernel: [76478.454179] Hardware name: Satellite L40
Feb  2 12:51:38 kovalev-home kernel: [76478.454181] Modules linked in:
sbp2 xt_tcpudp aes_i586 aes_generic binfmt_misc ppdev nls_iso8859_1
nls_cp437 vfat fat joydev snd_hda_codec_analog arc4 ecb pcmcia
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss
snd_pcm snd_seq_dummy iptable_filter snd_seq_oss ip_tables x_tables
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device psmouse serio_raw yenta_socket rsrc_nonstatic
pcmcia_core snd shpchp ath5k mac80211 ath cfg80211 soundcore
snd_page_alloc asus_laptop led_class video1394 raw1394 lp parport
usbhid fbcon tileblit font bitblit softcursor 8139too 8139cp mii
ohci1394 ieee1394 i915 drm i2c_algo_bit intel_agp agpgart video output
Feb  2 12:51:38 kovalev-home kernel: [76478.454230] Pid: 2357, comm:
transmission Tainted: G        W  2.6.31-18-generic #55-Ubuntu
Feb  2 12:51:38 kovalev-home kernel: [76478.454233] Call Trace:
Feb  2 12:51:38 kovalev-home kernel: [76478.454237]  [<c014513d>]
warn_slowpath_common+0x6d/0xa0
Feb  2 12:51:38 kovalev-home kernel: [76478.454242]  [<c04d2439>] ?
tcp_recvmsg+0xa49/0xb20
Feb  2 12:51:38 kovalev-home kernel: [76478.454245]  [<c04d2439>] ?
tcp_recvmsg+0xa49/0xb20
Feb  2 12:51:38 kovalev-home kernel: [76478.454250]  [<c0145185>]
warn_slowpath_null+0x15/0x20
Feb  2 12:51:38 kovalev-home kernel: [76478.454254]  [<c04d2439>]
tcp_recvmsg+0xa49/0xb20
Feb  2 12:51:38 kovalev-home kernel: [76478.454259]  [<c0492433>]
sock_common_recvmsg+0x43/0x60
Feb  2 12:51:38 kovalev-home kernel: [76478.454263]  [<c04920ac>]
sock_aio_read+0x11c/0x130
Feb  2 12:51:38 kovalev-home kernel: [76478.454267]  [<c01e78fc>]
do_sync_read+0xbc/0x100
Feb  2 12:51:38 kovalev-home kernel: [76478.454272]  [<c015c1d0>] ?
autoremove_wake_function+0x0/0x40
Feb  2 12:51:38 kovalev-home kernel: [76478.454276]  [<c04f02c1>] ?
inet_ioctl+0x31/0xb0
Feb  2 12:51:38 kovalev-home kernel: [76478.454280]  [<c02cbb7f>] ?
security_file_permission+0xf/0x20
Feb  2 12:51:38 kovalev-home kernel: [76478.454284]  [<c01e799f>] ?
rw_verify_area+0x5f/0xe0
Feb  2 12:51:38 kovalev-home kernel: [76478.454287]  [<c0490940>] ?
sock_ioctl+0x0/0x260
Feb  2 12:51:38 kovalev-home kernel: [76478.454291]  [<c01e7fda>]
vfs_read+0x17a/0x190
Feb  2 12:51:38 kovalev-home kernel: [76478.454295]  [<c01f5651>] ?
do_vfs_ioctl+0x71/0x310
Feb  2 12:51:38 kovalev-home kernel: [76478.454299]  [<c0217e0d>] ?
sys_epoll_ctl+0x9d/0x240
Feb  2 12:51:38 kovalev-home kernel: [76478.454303]  [<c01e850d>]
sys_read+0x3d/0x70
Feb  2 12:51:38 kovalev-home kernel: [76478.454307]  [<c01033ac>]
syscall_call+0x7/0xb
Feb  2 12:51:38 kovalev-home kernel: [76478.454309] ---[ end trace
1d3e832a4fd8afb9 ]---
Feb  2 12:51:38 kovalev-home kernel: [76478.454312] recvmsg bug:
copied 7B0ADBE3 seq 7B0AE18B
---------------
Feb  3 02:52:43 kovalev-home kernel: [36833.898061] WARNING: at
/build/buildd/linux-2.6.31/net/ipv4/tcp.c:1470
tcp_recvmsg+0x9b6/0xb20()
Feb  3 02:52:43 kovalev-home kernel: [36833.898065] Hardware name: Satellite L40
Feb  3 02:52:43 kovalev-home kernel: [36833.898067] Modules linked in:
xt_tcpudp aes_i586 aes_generic binfmt_misc ppdev nls_iso8859_1
nls_cp437 vfat fat joydev snd_hda_codec_analog arc4 ecb pcmcia
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss
snd_pcm snd_seq_dummy snd_seq_oss iptable_filter ip_tables x_tables
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device psmouse serio_raw yenta_socket rsrc_nonstatic
pcmcia_core shpchp ath5k mac80211 ath cfg80211 snd soundcore
snd_page_alloc asus_laptop led_class video1394 raw1394 lp parport
usbhid fbcon tileblit font bitblit softcursor ohci1394 ieee1394
8139too 8139cp mii i915 drm i2c_algo_bit intel_agp agpgart video
output
Feb  3 02:52:43 kovalev-home kernel: [36833.898126] Pid: 22266, comm:
java Tainted: G        W  2.6.31-18-generic #55-Ubuntu
Feb  3 02:52:43 kovalev-home kernel: [36833.898129] Call Trace:
Feb  3 02:52:43 kovalev-home kernel: [36833.898136]  [<c014513d>]
warn_slowpath_common+0x6d/0xa0
Feb  3 02:52:43 kovalev-home kernel: [36833.898141]  [<c04d23a6>] ?
tcp_recvmsg+0x9b6/0xb20
Feb  3 02:52:43 kovalev-home kernel: [36833.898145]  [<c04d23a6>] ?
tcp_recvmsg+0x9b6/0xb20
Feb  3 02:52:43 kovalev-home kernel: [36833.898150]  [<c0145185>]
warn_slowpath_null+0x15/0x20
Feb  3 02:52:43 kovalev-home kernel: [36833.898154]  [<c04d23a6>]
tcp_recvmsg+0x9b6/0xb20
Feb  3 02:52:43 kovalev-home kernel: [36833.898159]  [<c0492433>]
sock_common_recvmsg+0x43/0x60
Feb  3 02:52:43 kovalev-home kernel: [36833.898163]  [<c04908c0>]
sock_recvmsg+0xf0/0x120
Feb  3 02:52:43 kovalev-home kernel: [36833.898167]  [<c01b346d>] ?
generic_file_buffered_write+0x5d/0x150
Feb  3 02:52:43 kovalev-home kernel: [36833.898173]  [<c015c1d0>] ?
autoremove_wake_function+0x0/0x40
Feb  3 02:52:43 kovalev-home kernel: [36833.898177]  [<c01b4e13>] ?
__generic_file_aio_write_nolock+0x1f3/0x510
Feb  3 02:52:43 kovalev-home kernel: [36833.898191]  [<f8e466e5>] ?
ath5k_tx_processq+0x2a5/0x340 [ath5k]
Feb  3 02:52:43 kovalev-home kernel: [36833.898196]  [<c01338bd>] ?
__enqueue_entity+0x9d/0xc0
Feb  3 02:52:43 kovalev-home kernel: [36833.898200]  [<c0490e33>]
sys_recvfrom+0xb3/0x130
Feb  3 02:52:43 kovalev-home kernel: [36833.898205]  [<c015fcdc>] ?
ktime_get_ts+0x4c/0x60
Feb  3 02:52:43 kovalev-home kernel: [36833.898209]  [<c015fd06>] ?
ktime_get+0x16/0x40
Feb  3 02:52:43 kovalev-home kernel: [36833.898213]  [<c0573f61>] ?
_spin_unlock_bh+0x11/0x20
Feb  3 02:52:43 kovalev-home kernel: [36833.898217]  [<c0492c04>] ?
release_sock+0x94/0xa0
Feb  3 02:52:43 kovalev-home kernel: [36833.898221]  [<c04d1642>] ?
tcp_ioctl+0x72/0x170
Feb  3 02:52:43 kovalev-home kernel: [36833.898225]  [<c04d15d0>] ?
tcp_ioctl+0x0/0x170
Feb  3 02:52:43 kovalev-home kernel: [36833.898230]  [<c0512881>] ?
inet6_ioctl+0x31/0xd0
Feb  3 02:52:43 kovalev-home kernel: [36833.898233]  [<c04909a8>] ?
sock_ioctl+0x68/0x260
Feb  3 02:52:43 kovalev-home kernel: [36833.898236]  [<c0490ee6>]
sys_recv+0x36/0x40
Feb  3 02:52:43 kovalev-home kernel: [36833.898240]  [<c0491cf0>]
sys_socketcall+0x190/0x270
Feb  3 02:52:43 kovalev-home kernel: [36833.898245]  [<c0165341>] ?
do_gettimeofday+0x11/0x40
Feb  3 02:52:43 kovalev-home kernel: [36833.898249]  [<c01033ac>]
syscall_call+0x7/0xb
Feb  3 02:52:43 kovalev-home kernel: [36833.898252] ---[ end trace
d1a4a3665ef673d0 ]---
--------

3. SYSTEM CONFIGURATION

Ubuntu 9.10; Linux kernel 2.6.31-18 (currently 2.6.31-19.56) and Gnome 2.28.1

Networking (running via wlan0):
eth0      Link encap:Ethernet  HWaddr 00:1a:92:fc:ad:97
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
          Interrupt:16 Base address:0xd800

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:183847 errors:0 dropped:0 overruns:0 frame:0
          TX packets:183847 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:46933290 (46.9 MB)  TX bytes:46933290 (46.9 MB)

wlan0     Link encap:Ethernet  HWaddr 00:1b:9e:4a:2e:f8
          inet addr:192.168.1.65  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::21b:9eff:fe4a:2ef8/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:5432610 errors:0 dropped:0 overruns:0 frame:0
          TX packets:5681225 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:156835732 (156.8 MB)  TX bytes:60892985 (60.8 MB)

wmaster0  Link encap:UNSPEC  HWaddr
00-1B-9E-4A-2E-F8-34-61-00-00-00-00-00-00-00-00
          UP RUNNING  MTU:0  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

iwconfig output:
wlan0     IEEE 802.11bg  ESSID:"BTHomeHub2-HKZ2"
          Mode:Managed  Frequency:2.457 GHz  Access Point: 00:24:17:C7:72:3B
          Bit Rate=54 Mb/s   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption
key:CC35-06B9-0F61-D80D-01EA-582C-2887-81AA-B663-D88C-8A79-B717-E020-7AEF-C85F-5A06
[2]
          Power Management:off
          Link Quality=58/70  Signal level=-52 dBm  Noise level=-102 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

7.2. /proc/cpuinfo:
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 22
model name	: Intel(R) Celeron(R) M CPU        520  @ 1.60GHz
stepping	: 1
cpu MHz		: 1595.985
cache size	: 1024 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss tm pbe nx lm constant_tsc
up arch_perfmon pebs bts pni dtes64 monitor ds_cpl tm2 ssse3 cx16 xtpr
pdcm lahf_lm
bogomips	: 3191.97
clflush size	: 64
power management:

7.3. /proc/modules
udf 80900 0 - Live 0xf8a93000
crc_itu_t 1852 1 udf, Live 0xf8165000
isofs 31620 0 - Live 0xf85a5000
sbp2 22888 1 - Live 0xf94d1000
aes_i586 8124 1 - Live 0xf85f7000
aes_generic 27484 1 aes_i586, Live 0xf85b0000
binfmt_misc 8356 1 - Live 0xf817c000
ppdev 6688 0 - Live 0xf8094000
nls_iso8859_1 3740 1 - Live 0xf8226000
nls_cp437 5372 1 - Live 0xf8208000
vfat 10716 1 - Live 0xf8174000
fat 51452 1 vfat, Live 0xf8582000
snd_hda_codec_analog 59292 1 - Live 0xf89ea000
arc4 1660 2 - Live 0xf8a3f000
ecb 2524 2 - Live 0xf8a36000
snd_hda_intel 26920 2 - Live 0xf8a26000
snd_hda_codec 75708 2 snd_hda_codec_analog,snd_hda_intel, Live 0xf8a04000
snd_hwdep 7200 1 snd_hda_codec, Live 0xf8591000
snd_pcm_oss 37920 0 - Live 0xf84ea000
snd_mixer_oss 16028 1 snd_pcm_oss, Live 0xf8278000
video1394 15452 0 - Live 0xf8272000
snd_pcm 75296 3 snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xf85e2000
snd_seq_dummy 2656 0 - Live 0xf816e000
snd_seq_oss 28576 0 - Live 0xf8215000
snd_seq_midi 6432 0 - Live 0xf80f8000
joydev 10240 0 - Live 0xf8159000
snd_rawmidi 22208 1 snd_seq_midi, Live 0xf8147000
snd_seq_midi_event 6940 2 snd_seq_oss,snd_seq_midi, Live 0xf80b4000
raw1394 25308 0 - Live 0xf827e000
snd_seq 50224 6
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live
0xf8228000
snd_timer 22276 2 snd_pcm,snd_seq, Live 0xf820d000
snd_seq_device 6920 5
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live
0xf80fb000
iptable_filter 3100 0 - Live 0xf8091000
snd 59204 16 snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device,
Live 0xf8287000
ip_tables 11692 1 iptable_filter, Live 0xf8142000
pcmcia 36808 0 - Live 0xf809e000
ath5k 124260 0 - Live 0xf80bf000
soundcore 7264 1 snd, Live 0xf808d000
psmouse 56500 0 - Live 0xf8e53000
mac80211 181140 1 ath5k, Live 0xf8e0c000
ath 8060 1 ath5k, Live 0xf8dce000
snd_page_alloc 9156 2 snd_hda_intel,snd_pcm, Live 0xf8dc1000
cfg80211 93052 3 ath5k,mac80211,ath, Live 0xf8da2000
yenta_socket 24296 1 - Live 0xf8d64000
rsrc_nonstatic 11644 1 yenta_socket, Live 0xf8d51000
pcmcia_core 36528 3 pcmcia,yenta_socket,rsrc_nonstatic, Live 0xf8d3c000
asus_laptop 17400 0 - Live 0xf8d24000
shpchp 32272 0 - Live 0xf8d0e000
led_class 4096 2 ath5k,asus_laptop, Live 0xf8cfa000
lp 8964 0 - Live 0xf8cee000
x_tables 16544 1 ip_tables, Live 0xf8cde000
serio_raw 5280 0 - Live 0xf8cbf000
parport 35340 2 ppdev,lp, Live 0xf8cac000
usbhid 38208 0 - Live 0xf8595000
fbcon 36640 72 - Live 0xf84f6000
tileblit 2460 1 fbcon, Live 0xf84e7000
font 8124 1 fbcon, Live 0xf84df000
bitblit 5372 1 fbcon, Live 0xf8178000
softcursor 1756 1 bitblit, Live 0xf8171000
i915 221320 3 - Live 0xf82a4000
drm 159584 3 i915, Live 0xf8236000
i2c_algo_bit 5760 1 i915, Live 0xf815e000
ohci1394 29900 2 video1394, Live 0xf814f000
ieee1394 86596 4 sbp2,video1394,raw1394,ohci1394, Live 0xf80e0000
8139too 22620 0 - Live 0xf80b7000
8139cp 19260 0 - Live 0xf8097000
mii 5212 2 8139too,8139cp, Live 0xf8039000
intel_agp 27484 2 i915, Live 0xf80ab000
agpgart 34988 2 drm,intel_agp, Live 0xf8044000
video 19380 1 i915, Live 0xf803d000
output 2780 1 video, Live 0xf8020000

7.4. /proc/ioports
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
0170-0177 : 0000:00:1f.2
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.2
  01f0-01f7 : ata_piix
0250-025f : pnp 00:08
  0250-025f : pnp 00:0a
0376-0376 : 0000:00:1f.2
  0376-0376 : ata_piix
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.2
  03f6-03f6 : ata_piix
0400-041f : pnp 00:08
  0400-041f : pnp 00:0a
0480-04bf : 0000:00:1f.0
  0480-04bf : pnp 00:08
04d0-04d1 : pnp 00:08
0800-087f : 0000:00:1f.0
  0800-087f : pnp 00:08
    0800-0803 : ACPI PM1a_EVT_BLK
    0804-0805 : ACPI PM1a_CNT_BLK
    0808-080b : ACPI PM_TMR
    0810-0815 : ACPI CPU throttle
    0820-0820 : ACPI PM2_CNT_BLK
    0828-082f : ACPI GPE0_BLK
0cf8-0cff : PCI conf1
d000-dfff : PCI Bus 0000:06
  d000-d0ff : PCI CardBus 0000:07
  d400-d4ff : PCI CardBus 0000:07
  d800-d8ff : 0000:06:07.0
    d800-d8ff : 8139too
e400-e41f : 0000:00:1d.3
  e400-e41f : uhci_hcd
e480-e49f : 0000:00:1d.2
  e480-e49f : uhci_hcd
e800-e81f : 0000:00:1d.1
  e800-e81f : uhci_hcd
e880-e89f : 0000:00:1d.0
  e880-e89f : uhci_hcd
ec00-ec07 : 0000:00:02.0
ffa0-ffaf : 0000:00:1f.2
  ffa0-ffaf : ata_piix

/proc/iomem
00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cf000-000cffff : Adapter ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-3f7bffff : System RAM
  00100000-00575c47 : Kernel code
  00575c48-0078d407 : Kernel data
  0081a000-008a809f : Kernel bss
3f7c0000-3f7cdfff : ACPI Tables
3f7ce000-3f7fffff : ACPI Non-volatile Storage
3f800000-3fffffff : RAM buffer
40000000-43ffffff : PCI Bus 0000:06
  40000000-43ffffff : PCI CardBus 0000:07
44000000-440fffff : PCI Bus 0000:03
  44000000-440fffff : PCI Bus 0000:04
    44000000-44003fff : 0000:04:00.0
    44004000-440047ff : 0000:04:00.0
      44004000-440047ff : ohci1394
48000000-4bffffff : PCI CardBus 0000:07
d0000000-dfffffff : 0000:00:02.0
e0000000-e3ffffff : PCI MMCONFIG 0 [00-3f]
  e0000000-e3ffffff : pnp 00:0b
fec00000-fec00fff : IOAPIC 0
fec18000-fec1ffff : pnp 00:0a
fec20000-fec27fff : pnp 00:0a
fed00000-fed003ff : HPET 0
fed13000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:08
fed20000-fed3ffff : pnp 00:08
fed40000-fed8ffff : pnp 00:08
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:0a
ff100000-ff1fffff : PCI Bus 0000:02
  ff1f0000-ff1fffff : 0000:02:00.0
    ff1f0000-ff1fffff : ath5k
ff300000-ff3fffff : PCI Bus 0000:06
  ff300000-ff300fff : 0000:06:01.0
    ff300000-ff300fff : yenta_socket
  ff3ffc00-ff3ffcff : 0000:06:07.0
    ff3ffc00-ff3ffcff : 8139too
ff580000-ff5fffff : 0000:00:02.1
ff63bc00-ff63bfff : 0000:00:1d.7
  ff63bc00-ff63bfff : ehci_hcd
ff63c000-ff63ffff : 0000:00:1b.0
  ff63c000-ff63ffff : ICH HD audio
ff640000-ff67ffff : 0000:00:02.0
ff680000-ff6fffff : 0000:00:02.0
ff780000-ffffffff : reserved
  ffb00000-ffbfffff : pnp 00:08
  fff80000-ffffffff : pnp 00:08

7.5. PCI information attached (pci.info)

7.6. /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: TOSHIBA MK1237GS Rev: DL13
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: PIONEER  Model: DVD-RW  DVR-K17A Rev: 3.52
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: JMicron  Model: HDD              Rev:
  Type:   Direct-Access-RBC                ANSI  SCSI revision: 04

--0016e6465196ffb9a3047f3f0198
Content-Type: application/x-info; name="pci.info"
Content-Disposition: attachment; filename="pci.info"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

MDA6MDAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gTW9iaWxlIDk0NUdNL1BNL0dN
UywgOTQzLzk0MEdNTCBhbmQgOTQ1R1QgRXhwcmVzcyBNZW1vcnkgQ29udHJvbGxlciBIdWIgKHJl
diAwMykKCVN1YnN5c3RlbTogVG9zaGliYSBBbWVyaWNhIEluZm8gU3lzdGVtcyBEZXZpY2UgZmY0
MAoJQ29udHJvbDogSS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FT
bm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czog
Q2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxU
QWJvcnQtIDxNQWJvcnQrID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAKCUNhcGFiaWxp
dGllczogW2UwXSBWZW5kb3IgU3BlY2lmaWMgSW5mb3JtYXRpb24gPD8+CglLZXJuZWwgZHJpdmVy
IGluIHVzZTogYWdwZ2FydC1pbnRlbAoJS2VybmVsIG1vZHVsZXM6IGludGVsLWFncAoKMDA6MDIu
MCBWR0EgY29tcGF0aWJsZSBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiBNb2JpbGUgOTQ1
R00vR01TLCA5NDMvOTQwR01MIEV4cHJlc3MgSW50ZWdyYXRlZCBHcmFwaGljcyBDb250cm9sbGVy
IChyZXYgMDMpCglTdWJzeXN0ZW06IFRvc2hpYmEgQW1lcmljYSBJbmZvIFN5c3RlbXMgRGV2aWNl
IGZmNDAKCUNvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0g
VkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0
dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0
LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRl
cnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTYKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZmY2ODAw
MDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9NTEyS10KCVJlZ2lvbiAxOiBJL08g
cG9ydHMgYXQgZWMwMCBbc2l6ZT04XQoJUmVnaW9uIDI6IE1lbW9yeSBhdCBkMDAwMDAwMCAoMzIt
Yml0LCBwcmVmZXRjaGFibGUpIFtzaXplPTI1Nk1dCglSZWdpb24gMzogTWVtb3J5IGF0IGZmNjQw
MDAwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTI1NktdCglDYXBhYmlsaXRpZXM6
IFs5MF0gTWVzc2FnZSBTaWduYWxsZWQgSW50ZXJydXB0czogTWFzay0gNjRiaXQtIFF1ZXVlPTAv
MCBFbmFibGUtCgkJQWRkcmVzczogMDAwMDAwMDAgIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczog
W2QwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSSsgRDEt
IEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0sRDNob3QtLEQzY29sZC0pCgkJU3Rh
dHVzOiBEMCBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJS2VybmVsIGRyaXZlciBp
biB1c2U6IGk5MTUKCUtlcm5lbCBtb2R1bGVzOiBpOTE1CgowMDowMi4xIERpc3BsYXkgY29udHJv
bGxlcjogSW50ZWwgQ29ycG9yYXRpb24gTW9iaWxlIDk0NUdNL0dNUy9HTUUsIDk0My85NDBHTUwg
RXhwcmVzcyBJbnRlZ3JhdGVkIEdyYXBoaWNzIENvbnRyb2xsZXIgKHJldiAwMykKCVN1YnN5c3Rl
bTogVG9zaGliYSBBbWVyaWNhIEluZm8gU3lzdGVtcyBEZXZpY2UgZmY0MAoJQ29udHJvbDogSS9P
KyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBT
dGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURG
LSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQt
ID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZmY1
ODAwMDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9NTEyS10KCUNhcGFiaWxpdGll
czogW2QwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSSsg
RDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0sRDNob3QtLEQzY29sZC0pCgkJ
U3RhdHVzOiBEMCBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoKMDA6MWIuMCBBdWRp
byBkZXZpY2U6IEludGVsIENvcnBvcmF0aW9uIDgyODAxRyAoSUNINyBGYW1pbHkpIEhpZ2ggRGVm
aW5pdGlvbiBBdWRpbyBDb250cm9sbGVyIChyZXYgMDIpCglTdWJzeXN0ZW06IFRvc2hpYmEgQW1l
cmljYSBJbmZvIFN5c3RlbXMgRGV2aWNlIGZmNDAKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0
ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlIt
IEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFy
RXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlIt
IElOVHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6IDMyIGJ5dGVzCglJbnRlcnJ1cHQ6
IHBpbiBBIHJvdXRlZCB0byBJUlEgMjEKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZmY2M2MwMDAgKDY0
LWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9MTZLXQoJQ2FwYWJpbGl0aWVzOiBbNTBdIFBv
d2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1
eEN1cnJlbnQ9NTVtQSBQTUUoRDArLEQxLSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBE
MCBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbNjBdIE1l
c3NhZ2UgU2lnbmFsbGVkIEludGVycnVwdHM6IE1hc2stIDY0Yml0KyBRdWV1ZT0wLzAgRW5hYmxl
LQoJCUFkZHJlc3M6IDAwMDAwMDAwMDAwMDAwMDAgIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczog
WzcwXSBFeHByZXNzICh2MSkgUm9vdCBDb21wbGV4IEludGVncmF0ZWQgRW5kcG9pbnQsIE1TSSAw
MAoJCURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRS0gRkxSZXNldC0KCQlEZXZDdGw6CVJlcG9y
dCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KCQkJ
Umx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcCsKCQkJTWF4UGF5bG9h
ZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJyLSBVbmNv
cnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQZW5kLQoJCUxua0NhcDoJ
UG9ydCAjMCwgU3BlZWQgdW5rbm93biwgV2lkdGggeDAsIEFTUE0gdW5rbm93biwgTGF0ZW5jeSBM
MCA8NjRucywgTDEgPDF1cwoJCQlDbG9ja1BNLSBTdXByaXNlLSBMTEFjdFJlcC0gQndOb3QtCgkJ
TG5rQ3RsOglBU1BNIERpc2FibGVkOyBEaXNhYmxlZC0gUmV0cmFpbi0gQ29tbUNsay0KCQkJRXh0
U3luY2gtIENsb2NrUE0tIEF1dFdpZERpcy0gQldJbnQtIEF1dEJXSW50LQoJCUxua1N0YToJU3Bl
ZWQgdW5rbm93biwgV2lkdGggeDAsIFRyRXJyLSBUcmFpbi0gU2xvdENsay0gRExBY3RpdmUtIEJX
TWdtdC0gQUJXTWdtdC0KCUNhcGFiaWxpdGllczogWzEwMF0gVmlydHVhbCBDaGFubmVsIDw/PgoJ
Q2FwYWJpbGl0aWVzOiBbMTMwXSBSb290IENvbXBsZXggTGluayA8Pz4KCUtlcm5lbCBkcml2ZXIg
aW4gdXNlOiBIREEgSW50ZWwKCUtlcm5lbCBtb2R1bGVzOiBzbmQtaGRhLWludGVsCgowMDoxYy4w
IFBDSSBicmlkZ2U6IEludGVsIENvcnBvcmF0aW9uIDgyODAxRyAoSUNINyBGYW1pbHkpIFBDSSBF
eHByZXNzIFBvcnQgMSAocmV2IDAyKQoJQ29udHJvbDogSS9PLSBNZW0tIEJ1c01hc3RlcisgU3Bl
Y0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUisgRmFzdEIy
Qi0gRGlzSU5UeCsKCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERF
VlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0K
CUxhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTogMzIgYnl0ZXMKCUJ1czogcHJpbWFyeT0wMCwg
c2Vjb25kYXJ5PTAxLCBzdWJvcmRpbmF0ZT0wMSwgc2VjLWxhdGVuY3k9MAoJSS9PIGJlaGluZCBi
cmlkZ2U6IDAwMDBmMDAwLTAwMDAwZmZmCglNZW1vcnkgYmVoaW5kIGJyaWRnZTogZmZmMDAwMDAt
MDAwZmZmZmYKCVByZWZldGNoYWJsZSBtZW1vcnkgYmVoaW5kIGJyaWRnZTogMDAwMDAwMDBmZmYw
MDAwMC0wMDAwMDAwMDAwMGZmZmZmCglTZWNvbmRhcnkgc3RhdHVzOiA2Nk1Iei0gRmFzdEIyQi0g
UGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0KyA8U0VSUi0gPFBF
UlItCglCcmlkZ2VDdGw6IFBhcml0eS0gU0VSUisgTm9JU0EtIFZHQS0gTUFib3J0LSA+UmVzZXQt
IEZhc3RCMkItCgkJUHJpRGlzY1Rtci0gU2VjRGlzY1Rtci0gRGlzY1RtclN0YXQtIERpc2NUbXJT
RVJSRW4tCglDYXBhYmlsaXRpZXM6IFs0MF0gRXhwcmVzcyAodjEpIFJvb3QgUG9ydCAoU2xvdCsp
LCBNU0kgMDAKCQlEZXZDYXA6CU1heFBheWxvYWQgMTI4IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0
ZW5jeSBMMHMgdW5saW1pdGVkLCBMMSB1bmxpbWl0ZWQKCQkJRXh0VGFnLSBSQkUtIEZMUmVzZXQt
CgkJRGV2Q3RsOglSZXBvcnQgZXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRhbC0g
VW5zdXBwb3J0ZWQtCgkJCVJseGRPcmQtIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25v
b3AtCgkJCU1heFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVxIDEyOCBieXRlcwoJCURldlN0
YToJQ29yckVyci0gVW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBwUmVxLSBBdXhQd3IrIFRyYW5z
UGVuZC0KCQlMbmtDYXA6CVBvcnQgIzEsIFNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8MjU2bnMsIEwxIDw0dXMKCQkJQ2xvY2tQTS0gU3VwcmlzZS0gTExB
Y3RSZXArIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2Fi
bGVkLSBSZXRyYWluLSBDb21tQ2xrKwoJCQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBC
V0ludC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MCwgVHJFcnIt
IFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZS0gQldNZ210LSBBQldNZ210LQoJCVNsdENhcDoJQXR0
bkJ0bi0gUHdyQ3RybC0gTVJMLSBBdHRuSW5kLSBQd3JJbmQtIEhvdFBsdWcrIFN1cnBpc2UrCgkJ
CVNsb3QgIyAgMCwgUG93ZXJMaW1pdCAwLjAwMDAwMDsgSW50ZXJsb2NrLSBOb0NvbXBsLQoJCVNs
dEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JGbHQtIE1STC0gUHJlc0RldC0gQ21kQ3BsdC0gSFBJ
cnEtIExpbmtDaGctCgkJCUNvbnRyb2w6IEF0dG5JbmQgVW5rbm93biwgUHdySW5kIFVua25vd24s
IFBvd2VyLSBJbnRlcmxvY2stCgkJU2x0U3RhOglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBN
UkwtIENtZENwbHQtIFByZXNEZXQtIEludGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0
LSBMaW5rU3RhdGUtCgkJUm9vdEN0bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJy
RmF0YWwtIFBNRUludEVuYS0gQ1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJv
b3RTdGE6IFBNRSBSZXFJRCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCglDYXBhYmlsaXRp
ZXM6IFs4MF0gTWVzc2FnZSBTaWduYWxsZWQgSW50ZXJydXB0czogTWFzay0gNjRiaXQtIFF1ZXVl
PTAvMCBFbmFibGUrCgkJQWRkcmVzczogZmVlMDEwMGMgIERhdGE6IDQxNjEKCUNhcGFiaWxpdGll
czogWzkwXSBTdWJzeXN0ZW06IFRvc2hpYmEgQW1lcmljYSBJbmZvIFN5c3RlbXMgRGV2aWNlIGZm
NDAKCUNhcGFiaWxpdGllczogW2EwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdz
OiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQxLSxEMi0sRDNo
b3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1F
LQoJQ2FwYWJpbGl0aWVzOiBbMTAwXSBWaXJ0dWFsIENoYW5uZWwgPD8+CglDYXBhYmlsaXRpZXM6
IFsxODBdIFJvb3QgQ29tcGxleCBMaW5rIDw/PgoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHBjaWVw
b3J0LWRyaXZlcgoJS2VybmVsIG1vZHVsZXM6IHNocGNocAoKMDA6MWMuMSBQQ0kgYnJpZGdlOiBJ
bnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUcgKElDSDcgRmFtaWx5KSBQQ0kgRXhwcmVzcyBQb3J0IDIg
KHJldiAwMikKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lO
Vi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlIrIEZhc3RCMkItIERpc0lOVHgrCglT
dGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFi
b3J0LSA8VEFib3J0LSA8TUFib3J0KyA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBD
YWNoZSBMaW5lIFNpemU6IDMyIGJ5dGVzCglCdXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0wMiwg
c3Vib3JkaW5hdGU9MDIsIHNlYy1sYXRlbmN5PTAKCUkvTyBiZWhpbmQgYnJpZGdlOiAwMDAwZjAw
MC0wMDAwMGZmZgoJTWVtb3J5IGJlaGluZCBicmlkZ2U6IGZmMTAwMDAwLWZmMWZmZmZmCglQcmVm
ZXRjaGFibGUgbWVtb3J5IGJlaGluZCBicmlkZ2U6IDAwMDAwMDAwZmZmMDAwMDAtMDAwMDAwMDAw
MDBmZmZmZgoJU2Vjb25kYXJ5IHN0YXR1czogNjZNSHotIEZhc3RCMkItIFBhckVyci0gREVWU0VM
PWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPFNFUlItIDxQRVJSLQoJQnJpZGdlQ3Rs
OiBQYXJpdHktIFNFUlIrIE5vSVNBLSBWR0EtIE1BYm9ydC0gPlJlc2V0LSBGYXN0QjJCLQoJCVBy
aURpc2NUbXItIFNlY0Rpc2NUbXItIERpc2NUbXJTdGF0LSBEaXNjVG1yU0VSUkVuLQoJQ2FwYWJp
bGl0aWVzOiBbNDBdIEV4cHJlc3MgKHYxKSBSb290IFBvcnQgKFNsb3QrKSwgTVNJIDAwCgkJRGV2
Q2FwOglNYXhQYXlsb2FkIDEyOCBieXRlcywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIHVubGlt
aXRlZCwgTDEgdW5saW1pdGVkCgkJCUV4dFRhZy0gUkJFLSBGTFJlc2V0LQoJCURldkN0bDoJUmVw
b3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJ
CQlSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wLQoJCQlNYXhQYXls
b2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSAxMjggYnl0ZXMKCQlEZXZTdGE6CUNvcnJFcnIrIFVu
Y29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4UHdyKyBUcmFuc1BlbmQtCgkJTG5rQ2Fw
OglQb3J0ICMyLCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEsIExhdGVuY3kg
TDAgPDI1Nm5zLCBMMSA8NHVzCgkJCUNsb2NrUE0tIFN1cHJpc2UtIExMQWN0UmVwKyBCd05vdC0K
CQlMbmtDdGw6CUFTUE0gTDBzIEwxIEVuYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0
cmFpbi0gQ29tbUNsaysKCQkJRXh0U3luY2gtIENsb2NrUE0tIEF1dFdpZERpcy0gQldJbnQtIEF1
dEJXSW50LQoJCUxua1N0YToJU3BlZWQgMi41R1QvcywgV2lkdGggeDEsIFRyRXJyLSBUcmFpbi0g
U2xvdENsaysgRExBY3RpdmUrIEJXTWdtdC0gQUJXTWdtdC0KCQlTbHRDYXA6CUF0dG5CdG4tIFB3
ckN0cmwtIE1STC0gQXR0bkluZC0gUHdySW5kLSBIb3RQbHVnKyBTdXJwaXNlKwoJCQlTbG90ICMg
IDAsIFBvd2VyTGltaXQgMC4wMDAwMDA7IEludGVybG9jay0gTm9Db21wbC0KCQlTbHRDdGw6CUVu
YWJsZTogQXR0bkJ0bi0gUHdyRmx0LSBNUkwtIFByZXNEZXQtIENtZENwbHQtIEhQSXJxLSBMaW5r
Q2hnLQoJCQlDb250cm9sOiBBdHRuSW5kIFVua25vd24sIFB3ckluZCBVbmtub3duLCBQb3dlci0g
SW50ZXJsb2NrLQoJCVNsdFN0YToJU3RhdHVzOiBBdHRuQnRuLSBQb3dlckZsdC0gTVJMLSBDbWRD
cGx0LSBQcmVzRGV0KyBJbnRlcmxvY2stCgkJCUNoYW5nZWQ6IE1STC0gUHJlc0RldCsgTGlua1N0
YXRlKwoJCVJvb3RDdGw6IEVyckNvcnJlY3RhYmxlLSBFcnJOb24tRmF0YWwtIEVyckZhdGFsLSBQ
TUVJbnRFbmEtIENSU1Zpc2libGUtCgkJUm9vdENhcDogQ1JTVmlzaWJsZS0KCQlSb290U3RhOiBQ
TUUgUmVxSUQgMDAwMCwgUE1FU3RhdHVzLSBQTUVQZW5kaW5nLQoJQ2FwYWJpbGl0aWVzOiBbODBd
IE1lc3NhZ2UgU2lnbmFsbGVkIEludGVycnVwdHM6IE1hc2stIDY0Yml0LSBRdWV1ZT0wLzAgRW5h
YmxlKwoJCUFkZHJlc3M6IGZlZTAxMDBjICBEYXRhOiA0MTY5CglDYXBhYmlsaXRpZXM6IFs5MF0g
U3Vic3lzdGVtOiBUb3NoaWJhIEFtZXJpY2EgSW5mbyBTeXN0ZW1zIERldmljZSBmZjQwCglDYXBh
YmlsaXRpZXM6IFthMF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xr
LSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQzaG90KyxEM2Nv
bGQrKQoJCVN0YXR1czogRDAgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFi
aWxpdGllczogWzEwMF0gVmlydHVhbCBDaGFubmVsIDw/PgoJQ2FwYWJpbGl0aWVzOiBbMTgwXSBS
b290IENvbXBsZXggTGluayA8Pz4KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydC1kcml2
ZXIKCUtlcm5lbCBtb2R1bGVzOiBzaHBjaHAKCjAwOjFjLjIgUENJIGJyaWRnZTogSW50ZWwgQ29y
cG9yYXRpb24gODI4MDFHIChJQ0g3IEZhbWlseSkgUENJIEV4cHJlc3MgUG9ydCAzIChyZXYgMDIp
CglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNu
b29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSKyBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBD
YXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRB
Ym9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGlu
ZSBTaXplOiAzMiBieXRlcwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MDMsIHN1Ym9yZGlu
YXRlPTA1LCBzZWMtbGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGYwMDAtMDAwMDBm
ZmYKCU1lbW9yeSBiZWhpbmQgYnJpZGdlOiA0NDAwMDAwMC00NDBmZmZmZgoJUHJlZmV0Y2hhYmxl
IG1lbW9yeSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGZmZjAwMDAwLTAwMDAwMDAwMDAwZmZmZmYK
CVNlY29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQrIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFyaXR5
LSBTRVJSKyBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlEaXNjVG1y
LSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFiaWxpdGllczog
WzQwXSBFeHByZXNzICh2MSkgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJCURldkNhcDoJTWF4
UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyB1bmxpbWl0ZWQsIEwx
IHVubGltaXRlZAoJCQlFeHRUYWctIFJCRS0gRkxSZXNldC0KCQlEZXZDdGw6CVJlcG9ydCBlcnJv
cnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KCQkJUmx4ZE9y
ZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJTWF4UGF5bG9hZCAxMjgg
Ynl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJyLSBVbmNvcnJFcnIt
IEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQZW5kLQoJCUxua0NhcDoJUG9ydCAj
MywgU3BlZWQgMi41R1QvcywgV2lkdGggeDEsIEFTUE0gTDBzIEwxLCBMYXRlbmN5IEwwIDwxdXMs
IEwxIDw0dXMKCQkJQ2xvY2tQTS0gU3VwcmlzZS0gTExBY3RSZXArIEJ3Tm90LQoJCUxua0N0bDoJ
QVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrLQoJ
CQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3Rh
OglTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2
ZSsgQldNZ210LSBBQldNZ210LQoJCVNsdENhcDoJQXR0bkJ0bi0gUHdyQ3RybC0gTVJMLSBBdHRu
SW5kLSBQd3JJbmQtIEhvdFBsdWcrIFN1cnBpc2UrCgkJCVNsb3QgIyAgMCwgUG93ZXJMaW1pdCAw
LjAwMDAwMDsgSW50ZXJsb2NrLSBOb0NvbXBsLQoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQ
d3JGbHQtIE1STC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnEtIExpbmtDaGctCgkJCUNvbnRyb2w6
IEF0dG5JbmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJU2x0
U3RhOglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNEZXQrIElu
dGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUtCgkJUm9vdEN0bDog
RXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUludEVuYS0gQ1JTVmlz
aWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBNRSBSZXFJRCAwMDAwLCBQ
TUVTdGF0dXMtIFBNRVBlbmRpbmctCglDYXBhYmlsaXRpZXM6IFs4MF0gTWVzc2FnZSBTaWduYWxs
ZWQgSW50ZXJydXB0czogTWFzay0gNjRiaXQtIFF1ZXVlPTAvMCBFbmFibGUrCgkJQWRkcmVzczog
ZmVlMDEwMGMgIERhdGE6IDQxNzEKCUNhcGFiaWxpdGllczogWzkwXSBTdWJzeXN0ZW06IFRvc2hp
YmEgQW1lcmljYSBJbmZvIFN5c3RlbXMgRGV2aWNlIGZmNDAKCUNhcGFiaWxpdGllczogW2EwXSBQ
b3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBB
dXhDdXJyZW50PTBtQSBQTUUoRDArLEQxLSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBE
MCBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbMTAwXSBW
aXJ0dWFsIENoYW5uZWwgPD8+CglDYXBhYmlsaXRpZXM6IFsxODBdIFJvb3QgQ29tcGxleCBMaW5r
IDw/PgoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHBjaWVwb3J0LWRyaXZlcgoJS2VybmVsIG1vZHVs
ZXM6IHNocGNocAoKMDA6MWQuMCBVU0IgQ29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gODI4
MDFHIChJQ0g3IEZhbWlseSkgVVNCIFVIQ0kgQ29udHJvbGxlciAjMSAocmV2IDAyKQoJU3Vic3lz
dGVtOiBUb3NoaWJhIEFtZXJpY2EgSW5mbyBTeXN0ZW1zIERldmljZSBmZjQwCglDb250cm9sOiBJ
L08rIE1lbS0gQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnIt
IFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXAtIDY2TUh6LSBV
REYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFi
b3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1cHQ6IHBpbiBBIHJv
dXRlZCB0byBJUlEgMjMKCVJlZ2lvbiA0OiBJL08gcG9ydHMgYXQgZTg4MCBbc2l6ZT0zMl0KCUtl
cm5lbCBkcml2ZXIgaW4gdXNlOiB1aGNpX2hjZAoKMDA6MWQuMSBVU0IgQ29udHJvbGxlcjogSW50
ZWwgQ29ycG9yYXRpb24gODI4MDFHIChJQ0g3IEZhbWlseSkgVVNCIFVIQ0kgQ29udHJvbGxlciAj
MiAocmV2IDAyKQoJU3Vic3lzdGVtOiBUb3NoaWJhIEFtZXJpY2EgSW5mbyBTeXN0ZW1zIERldmlj
ZSBmZjQwCglDb250cm9sOiBJL08rIE1lbS0gQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYt
IFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3Rh
dHVzOiBDYXAtIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFi
b3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJ
bnRlcnJ1cHQ6IHBpbiBCIHJvdXRlZCB0byBJUlEgMTkKCVJlZ2lvbiA0OiBJL08gcG9ydHMgYXQg
ZTgwMCBbc2l6ZT0zMl0KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiB1aGNpX2hjZAoKMDA6MWQuMiBV
U0IgQ29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFHIChJQ0g3IEZhbWlseSkgVVNC
IFVIQ0kgQ29udHJvbGxlciAjMyAocmV2IDAyKQoJU3Vic3lzdGVtOiBUb3NoaWJhIEFtZXJpY2Eg
SW5mbyBTeXN0ZW1zIERldmljZSBmZjQwCglDb250cm9sOiBJL08rIE1lbS0gQnVzTWFzdGVyKyBT
cGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0
QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXAtIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBhckVyci0g
REVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElO
VHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1cHQ6IHBpbiBDIHJvdXRlZCB0byBJUlEgMTgKCVJlZ2lv
biA0OiBJL08gcG9ydHMgYXQgZTQ4MCBbc2l6ZT0zMl0KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiB1
aGNpX2hjZAoKMDA6MWQuMyBVU0IgQ29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFH
IChJQ0g3IEZhbWlseSkgVVNCIFVIQ0kgQ29udHJvbGxlciAjNCAocmV2IDAyKQoJU3Vic3lzdGVt
OiBUb3NoaWJhIEFtZXJpY2EgSW5mbyBTeXN0ZW1zIERldmljZSBmZjQwCglDb250cm9sOiBJL08r
IE1lbS0gQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0
ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXAtIDY2TUh6LSBVREYt
IEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0
LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1cHQ6IHBpbiBEIHJvdXRl
ZCB0byBJUlEgMjIKCVJlZ2lvbiA0OiBJL08gcG9ydHMgYXQgZTQwMCBbc2l6ZT0zMl0KCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiB1aGNpX2hjZAoKMDA6MWQuNyBVU0IgQ29udHJvbGxlcjogSW50ZWwg
Q29ycG9yYXRpb24gODI4MDFHIChJQ0g3IEZhbWlseSkgVVNCMiBFSENJIENvbnRyb2xsZXIgKHJl
diAwMikgKHByb2ctaWYgMjApCglTdWJzeXN0ZW06IFRvc2hpYmEgQW1lcmljYSBJbmZvIFN5c3Rl
bXMgRGV2aWNlIGZmNDAKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0g
TWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlIrIEZhc3RCMkItIERpc0lO
VHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9bWVk
aXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVu
Y3k6IDAKCUludGVycnVwdDogcGluIEEgcm91dGVkIHRvIElSUSAyMwoJUmVnaW9uIDA6IE1lbW9y
eSBhdCBmZjYzYmMwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0xS10KCUNhcGFi
aWxpdGllczogWzUwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGst
IERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTM3NW1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNj
b2xkKykKCQlTdGF0dXM6IEQwIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBh
YmlsaXRpZXM6IFs1OF0gRGVidWcgcG9ydDogQkFSPTEgb2Zmc2V0PTAwYTAKCUtlcm5lbCBkcml2
ZXIgaW4gdXNlOiBlaGNpX2hjZAoKMDA6MWUuMCBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlv
biA4MjgwMSBNb2JpbGUgUENJIEJyaWRnZSAocmV2IGUyKSAocHJvZy1pZiAwMSkKCUNvbnRyb2w6
IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVy
ci0gU3RlcHBpbmctIFNFUlIrIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHot
IFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFi
b3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglCdXM6IHByaW1hcnk9MDAsIHNl
Y29uZGFyeT0wNiwgc3Vib3JkaW5hdGU9MGEsIHNlYy1sYXRlbmN5PTMyCglJL08gYmVoaW5kIGJy
aWRnZTogMDAwMGQwMDAtMDAwMGRmZmYKCU1lbW9yeSBiZWhpbmQgYnJpZGdlOiBmZjMwMDAwMC1m
ZjNmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9yeSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMDQwMDAw
MDAwLTAwMDAwMDAwNDNmZmZmZmYKCVNlY29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCKyBQ
YXJFcnItIERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPFNFUlItIDxQ
RVJSLQoJQnJpZGdlQ3RsOiBQYXJpdHktIFNFUlIrIE5vSVNBLSBWR0EtIE1BYm9ydC0gPlJlc2V0
LSBGYXN0QjJCLQoJCVByaURpc2NUbXItIFNlY0Rpc2NUbXItIERpc2NUbXJTdGF0LSBEaXNjVG1y
U0VSUkVuLQoJQ2FwYWJpbGl0aWVzOiBbNTBdIFN1YnN5c3RlbTogVG9zaGliYSBBbWVyaWNhIElu
Zm8gU3lzdGVtcyBEZXZpY2UgZmY0MAoKMDA6MWYuMCBJU0EgYnJpZGdlOiBJbnRlbCBDb3Jwb3Jh
dGlvbiA4MjgwMUdCTSAoSUNINy1NKSBMUEMgSW50ZXJmYWNlIEJyaWRnZSAocmV2IDAyKQoJU3Vi
c3lzdGVtOiBUb3NoaWJhIEFtZXJpY2EgSW5mbyBTeXN0ZW1zIERldmljZSBmZjQwCglDb250cm9s
OiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJF
cnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6
LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8
TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglDYXBhYmlsaXRpZXM6IFtl
MF0gVmVuZG9yIFNwZWNpZmljIEluZm9ybWF0aW9uIDw/PgoJS2VybmVsIG1vZHVsZXM6IGlUQ09f
d2R0LCBpbnRlbC1ybmcKCjAwOjFmLjIgSURFIGludGVyZmFjZTogSW50ZWwgQ29ycG9yYXRpb24g
ODI4MDFHQk0vR0hNIChJQ0g3IEZhbWlseSkgU0FUQSBJREUgQ29udHJvbGxlciAocmV2IDAyKSAo
cHJvZy1pZiA4MCBbTWFzdGVyXSkKCVN1YnN5c3RlbTogVG9zaGliYSBBbWVyaWNhIEluZm8gU3lz
dGVtcyBEZXZpY2UgZmY0MAoJQ29udHJvbDogSS9PKyBNZW0tIEJ1c01hc3RlcisgU3BlY0N5Y2xl
LSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlz
SU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1IeisgVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1t
ZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0
ZW5jeTogMAoJSW50ZXJydXB0OiBwaW4gQiByb3V0ZWQgdG8gSVJRIDE5CglSZWdpb24gMDogSS9P
IHBvcnRzIGF0IDAxZjAgW3NpemU9OF0KCVJlZ2lvbiAxOiBJL08gcG9ydHMgYXQgMDNmNCBbc2l6
ZT0xXQoJUmVnaW9uIDI6IEkvTyBwb3J0cyBhdCAwMTcwIFtzaXplPThdCglSZWdpb24gMzogSS9P
IHBvcnRzIGF0IDAzNzQgW3NpemU9MV0KCVJlZ2lvbiA0OiBJL08gcG9ydHMgYXQgZmZhMCBbc2l6
ZT0xNl0KCUNhcGFiaWxpdGllczogWzcwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZs
YWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0s
RDNob3QrLEQzY29sZC0pCgkJU3RhdHVzOiBEMCBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAg
UE1FLQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IGF0YV9waWl4CgowMjowMC4wIEV0aGVybmV0IGNv
bnRyb2xsZXI6IEF0aGVyb3MgQ29tbXVuaWNhdGlvbnMgSW5jLiBBUjUwMDEgV2lyZWxlc3MgTmV0
d29yayBBZGFwdGVyIChyZXYgMDEpCglTdWJzeXN0ZW06IEFza2V5IENvbXB1dGVyIENvcnAuIERl
dmljZSA3MTI4CglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJ
TlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJ
U3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRB
Ym9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwg
Q2FjaGUgTGluZSBTaXplOiAzMiBieXRlcwoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJR
IDE3CglSZWdpb24gMDogTWVtb3J5IGF0IGZmMWYwMDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFi
bGUpIFtzaXplPTY0S10KCUNhcGFiaWxpdGllczogWzQwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNp
b24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTM3NW1BIFBNRShE
MC0sRDEtLEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIFBNRS1FbmFibGUtIERTZWw9
MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs1MF0gTWVzc2FnZSBTaWduYWxsZWQgSW50
ZXJydXB0czogTWFzay0gNjRiaXQtIFF1ZXVlPTAvMCBFbmFibGUtCgkJQWRkcmVzczogMDAwMDAw
MDAgIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczogWzYwXSBFeHByZXNzICh2MSkgTGVnYWN5IEVu
ZHBvaW50LCBNU0kgMDAKCQlEZXZDYXA6CU1heFBheWxvYWQgMTI4IGJ5dGVzLCBQaGFudEZ1bmMg
MCwgTGF0ZW5jeSBMMHMgPDUxMm5zLCBMMSA8NjR1cwoJCQlFeHRUYWctIEF0dG5CdG4tIEF0dG5J
bmQtIFB3ckluZC0gUkJFLSBGTFJlc2V0LQoJCURldkN0bDoJUmVwb3J0IGVycm9yczogQ29ycmVj
dGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3JkKyBFeHRUYWct
IFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wLQoJCQlNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4
UmVhZFJlcSA1MTIgYnl0ZXMKCQlEZXZTdGE6CUNvcnJFcnIrIFVuY29yckVycisgRmF0YWxFcnIr
IFVuc3VwcFJlcSsgQXV4UHdyLSBUcmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICMwLCBTcGVlZCAy
LjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEsIExhdGVuY3kgTDAgPDUxMm5zLCBMMSA8NjR1
cwoJCQlDbG9ja1BNLSBTdXByaXNlLSBMTEFjdFJlcC0gQndOb3QtCgkJTG5rQ3RsOglBU1BNIEww
cyBMMSBFbmFibGVkOyBSQ0IgMTI4IGJ5dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrKwoJ
CQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3Rh
OglTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2
ZS0gQldNZ210LSBBQldNZ210LQoJQ2FwYWJpbGl0aWVzOiBbOTBdIE1TSS1YOiBFbmFibGUtIE1h
c2stIFRhYlNpemU9MQoJCVZlY3RvciB0YWJsZTogQkFSPTAgb2Zmc2V0PTAwMDAwMDAwCgkJUEJB
OiBCQVI9MCBvZmZzZXQ9MDAwMDAwMDAKCUNhcGFiaWxpdGllczogWzEwMF0gQWR2YW5jZWQgRXJy
b3IgUmVwb3J0aW5nIDw/PgoJQ2FwYWJpbGl0aWVzOiBbMTQwXSBWaXJ0dWFsIENoYW5uZWwgPD8+
CglLZXJuZWwgZHJpdmVyIGluIHVzZTogYXRoNWsKCUtlcm5lbCBtb2R1bGVzOiBhdGg1awoKMDM6
MDAuMCBQQ0kgYnJpZGdlOiBUZXhhcyBJbnN0cnVtZW50cyBYSU8yMDAwKEEpL1hJTzIyMDAoQSkg
UENJIEV4cHJlc3MtdG8tUENJIEJyaWRnZSAocmV2IDAzKQoJQ29udHJvbDogSS9PLSBNZW0rIEJ1
c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WKyBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0g
U0VSUisgRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJC
LSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8
UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTogMzIgYnl0ZXMKCUJ1czog
cHJpbWFyeT0wMywgc2Vjb25kYXJ5PTA0LCBzdWJvcmRpbmF0ZT0wNCwgc2VjLWxhdGVuY3k9NjQK
CUkvTyBiZWhpbmQgYnJpZGdlOiAwMDAwZjAwMC0wMDAwMGZmZgoJTWVtb3J5IGJlaGluZCBicmlk
Z2U6IDQ0MDAwMDAwLTQ0MGZmZmZmCglQcmVmZXRjaGFibGUgbWVtb3J5IGJlaGluZCBicmlkZ2U6
IDAwMDAwMDAwZmZmMDAwMDAtMDAwMDAwMDAwMDBmZmZmZgoJU2Vjb25kYXJ5IHN0YXR1czogNjZN
SHorIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFi
b3J0KyA8U0VSUi0gPFBFUlItCglCcmlkZ2VDdGw6IFBhcml0eSsgU0VSUisgTm9JU0EtIFZHQS0g
TUFib3J0LSA+UmVzZXQtIEZhc3RCMkItCgkJUHJpRGlzY1Rtci0gU2VjRGlzY1Rtci0gRGlzY1Rt
clN0YXQtIERpc2NUbXJTRVJSRW4tCglDYXBhYmlsaXRpZXM6IFs1MF0gUG93ZXIgTWFuYWdlbWVu
dCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxKyBEMisgQXV4Q3VycmVudD0wbUEg
UE1FKEQwLSxEMS0sRDItLEQzaG90LSxEM2NvbGQtKQoJCVN0YXR1czogRDAgUE1FLUVuYWJsZS0g
RFNlbD0wIERTY2FsZT0wIFBNRS0KCQlCcmlkZ2U6IFBNLSBCMysKCUNhcGFiaWxpdGllczogWzYw
XSBNZXNzYWdlIFNpZ25hbGxlZCBJbnRlcnJ1cHRzOiBNYXNrLSA2NGJpdCsgUXVldWU9MC80IEVu
YWJsZS0KCQlBZGRyZXNzOiAwMDAwMDAwMDAwMDAwMDAwICBEYXRhOiAwMDAwCglDYXBhYmlsaXRp
ZXM6IFs4MF0gU3Vic3lzdGVtOiBEZXZpY2UgNTY3ODoxMjM0CglDYXBhYmlsaXRpZXM6IFs5MF0g
RXhwcmVzcyAodjEpIFBDSS9QQ0ktWCBCcmlkZ2UsIE1TSSAwMAoJCURldkNhcDoJTWF4UGF5bG9h
ZCA1MTIgYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyA8NjRucywgTDEgPDF1cwoJCQlF
eHRUYWctIEF0dG5CdG4tIEF0dG5JbmQtIFB3ckluZC0gUkJFLSBGTFJlc2V0LQoJCURldkN0bDoJ
UmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVk
LQoJCQlSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wKyBCckNvbmZS
dHJ5LQoJCQlNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSA1MTIgYnl0ZXMKCQlEZXZT
dGE6CUNvcnJFcnItIFVuY29yckVycisgRmF0YWxFcnItIFVuc3VwcFJlcSsgQXV4UHdyKyBUcmFu
c1BlbmQtCgkJTG5rQ2FwOglQb3J0ICMwLCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBM
MHMgTDEsIExhdGVuY3kgTDAgPDY0bnMsIEwxIDwxdXMKCQkJQ2xvY2tQTS0gU3VwcmlzZS0gTExB
Y3RSZXAtIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgRGlzYWJsZWQtIFJldHJhaW4t
IENvbW1DbGstCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0lu
dC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RD
bGsrIERMQWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCglDYXBhYmlsaXRpZXM6IFsxMDBdIEFkdmFu
Y2VkIEVycm9yIFJlcG9ydGluZyA8Pz4KCUtlcm5lbCBtb2R1bGVzOiBzaHBjaHAKCjA0OjAwLjAg
RmlyZVdpcmUgKElFRUUgMTM5NCk6IFRleGFzIEluc3RydW1lbnRzIFhJTzIyMDAoQSkgSUVFRS0x
Mzk0YS0yMDAwIENvbnRyb2xsZXIgKFBIWS9MaW5rKSAocmV2IDAxKSAocHJvZy1pZiAxMCkKCVN1
YnN5c3RlbTogRGV2aWNlIDU2Nzg6MTIzNAoJQ29udHJvbDogSS9PLSBNZW0rIEJ1c01hc3Rlcisg
U3BlY0N5Y2xlLSBNZW1XSU5WKyBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFz
dEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1IeisgVURGLSBGYXN0QjJCLSBQYXJFcnIt
IERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJ
TlR4LQoJTGF0ZW5jeTogNjQgKDUwMG5zIG1pbiwgMTAwMG5zIG1heCksIENhY2hlIExpbmUgU2l6
ZTogMzIgYnl0ZXMKCUludGVycnVwdDogcGluIEEgcm91dGVkIHRvIElSUSAxOAoJUmVnaW9uIDA6
IE1lbW9yeSBhdCA0NDAwNDAwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0yS10K
CVJlZ2lvbiAxOiBNZW1vcnkgYXQgNDQwMDAwMDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkg
W3NpemU9MTZLXQoJQ2FwYWJpbGl0aWVzOiBbNDRdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAy
CgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMSsgRDIrIEF1eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEr
LEQyKyxEM2hvdCssRDNjb2xkLSkKCQlTdGF0dXM6IEQwIFBNRS1FbmFibGUtIERTZWw9MCBEU2Nh
bGU9MCBQTUUrCglLZXJuZWwgZHJpdmVyIGluIHVzZTogb2hjaTEzOTQKCUtlcm5lbCBtb2R1bGVz
OiBmaXJld2lyZS1vaGNpLCBvaGNpMTM5NAoKMDY6MDEuMCBDYXJkQnVzIGJyaWRnZTogUmljb2gg
Q28gTHRkIFJMNWM0NzYgSUkgKHJldiBiYSkKCVN1YnN5c3RlbTogVG9zaGliYSBBbWVyaWNhIElu
Zm8gU3lzdGVtcyBEZXZpY2UgZmY0MAoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3Bl
Y0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIy
Qi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERF
VlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4
LQoJTGF0ZW5jeTogMTY4CglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTcKCVJlZ2lv
biAwOiBNZW1vcnkgYXQgZmYzMDAwMDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9
NEtdCglCdXM6IHByaW1hcnk9MDYsIHNlY29uZGFyeT0wNywgc3Vib3JkaW5hdGU9MGEsIHNlYy1s
YXRlbmN5PTE3NgoJTWVtb3J5IHdpbmRvdyAwOiA0MDAwMDAwMC00M2ZmZjAwMCAocHJlZmV0Y2hh
YmxlKQoJTWVtb3J5IHdpbmRvdyAxOiA0ODAwMDAwMC00YmZmZjAwMAoJSS9PIHdpbmRvdyAwOiAw
MDAwZDAwMC0wMDAwZDBmZgoJSS9PIHdpbmRvdyAxOiAwMDAwZDQwMC0wMDAwZDRmZgoJQnJpZGdl
Q3RsOiBQYXJpdHktIFNFUlItIElTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gMTZiSW50KyBQb3N0
V3JpdGUrCgkxNi1iaXQgbGVnYWN5IGludGVyZmFjZSBwb3J0cyBhdCAwMDAxCglLZXJuZWwgZHJp
dmVyIGluIHVzZTogeWVudGFfY2FyZGJ1cwoJS2VybmVsIG1vZHVsZXM6IHllbnRhX3NvY2tldAoK
MDY6MDcuMCBFdGhlcm5ldCBjb250cm9sbGVyOiBSZWFsdGVrIFNlbWljb25kdWN0b3IgQ28uLCBM
dGQuIFJUTC04MTM5LzgxMzlDLzgxMzlDKyAocmV2IDEwKQoJU3Vic3lzdGVtOiBUb3NoaWJhIEFt
ZXJpY2EgSW5mbyBTeXN0ZW1zIERldmljZSBmZjQwCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJS
LSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBh
ckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBF
UlItIElOVHgtCglMYXRlbmN5OiA2NCAoODAwMG5zIG1pbiwgMTYwMDBucyBtYXgpCglJbnRlcnJ1
cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTYKCVJlZ2lvbiAwOiBJL08gcG9ydHMgYXQgZDgwMCBb
c2l6ZT0yNTZdCglSZWdpb24gMTogTWVtb3J5IGF0IGZmM2ZmYzAwICgzMi1iaXQsIG5vbi1wcmVm
ZXRjaGFibGUpIFtzaXplPTI1Nl0KCUNhcGFiaWxpdGllczogWzUwXSBQb3dlciBNYW5hZ2VtZW50
IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDErIEQyKyBBdXhDdXJyZW50PTM3NW1B
IFBNRShEMC0sRDErLEQyKyxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIFBNRS1FbmFibGUt
IERTZWw9MCBEU2NhbGU9MCBQTUUtCglLZXJuZWwgZHJpdmVyIGluIHVzZTogODEzOXRvbwoJS2Vy
bmVsIG1vZHVsZXM6IGVwbCwgODEzOXRvbywgODEzOWNwCgo=
--0016e6465196ffb9a3047f3f0198--
