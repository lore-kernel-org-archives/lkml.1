Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbXBUK1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbXBUK1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161176AbXBUK1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:27:13 -0500
Received: from hyrule.inforealm.org ([62.58.71.23]:55917 "EHLO
	hyrule.inforealm.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932775AbXBUK1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:27:10 -0500
X-Greylist: delayed 1423 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Feb 2007 05:27:09 EST
Date: Wed, 21 Feb 2007 11:03:22 +0100
From: Stef Epardaud <stef@epardaud.net>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: kernel oops 2.6.20 (ubuntu feisty) when inserting compact flash card
Message-ID: <20070221100322.GA19812@inforealm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.11+cvs20060403
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I got an oops when inserting my compact flash card in my laptop.
The laptop is a Dell X1, using the builtin compact flash reader, which I
understand works through PCMCIA.

My kernel is stock ubuntu latest unstable: Linux version 2.6.20-8-386
(root@vernadsky) (gcc version 4.1.2 20070129 (prerelease) (Ubuntu
4.1.1-31ubuntu2)) #2 Tue Feb 13 05:15:43 UTC 2007

The oops:
[ 3902.160000] pccard: PCMCIA card inserted into slot 0
[ 3902.160000] cs: memory probe 0xdfc00000-0xdfcfffff: excluding
0xdfc00000-0xdfc0ffff 0xdfcf0000-0xdfcfffff
[ 3902.168000] pcmcia: registering new device pcmcia0.0
[ 3902.344000] ata1: PATA max PIO0 cmd 0x100 ctl 0x10E bmdma 0x0 irq 3
[ 3902.344000] scsi1 : pata_pcmcia
[ 3902.516000] BUG: unable to handle kernel NULL pointer dereference at
virtual address 0000004d
[ 3902.516000]  printing eip:
[ 3902.516000] f8a2178c
[ 3902.516000] *pde = 00000000
[ 3902.516000] Oops: 0000 [#1]
[ 3902.516000] Modules linked in: pata_pcmcia binfmt_misc rfcomm l2cap
ppdev ipv6 nfs lockd sunrpc acpi_cpufreq cpufreq_userspace cpufreq_stats
cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative video
sbs i2c_ec i2c_core dock button battery container ac asus_acpi backlight
aes ieee80211_crypt_ccmp sbp2 parport_pc lp parport joydev tsdev pcmcia
sg snd_intel8x0 snd_ac97_codec sr_mod cdrom ac97_bus snd_pcm_oss
snd_mixer_oss pcspkr serio_raw snd_pcm ipw2200 rtc snd_seq_dummy
snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event hci_usb
ieee80211 ieee80211_crypt bluetooth psmouse iTCO_wdt snd_seq snd_timer
snd_seq_device iTCO_vendor_support intel_agp snd soundcore yenta_socket
rsrc_nonstatic pcmcia_core snd_page_alloc agpgart shpchp pci_hotplug
evdev ext3 jbd mbcache usb_storage ide_disk ata_piix ata_generic libata
scsi_mod libusual piix ohci1394 ieee1394 generic ehci_hcd tg3 uhci_hcd
usbcore raid10 raid456 xor raid1 raid0 multipath linear md_mod thermal
processor fan dm_mod fbcon tileblit font bitblit softcursor vesafb
capability commoncap af_packet
[ 3902.516000] CPU:    0
[ 3902.516000] EIP:    0060:[<f8a2178c>]    Not tainted VLI
[ 3902.516000] EFLAGS: 00010293   (2.6.20-8-386 #2)
[ 3902.516000] EIP is at ata_acpi_exec_tfs+0xfc/0x9e0 [libata]
[ 3902.516000] eax: 00000001   ebx: 00000000   ecx: e7068444   edx: ec0e223c
[ 3902.516000] esi: e70682bc   edi: ec0e2284   ebp: 0003000c   esp: e7b47d10
[ 3902.516000] ds: 007b   es: 007b   ss: 0068
[ 3902.516000] Process scsi_eh_1 (pid: 6336, ti=e7b46000 task=e8686550 task.ti=e7b46000)
[ 3902.516000] Stack: c012a8e9 e70682bc 00000202 00200200 00000286 e7b47d5c 00001d4a 00000246 
[ 3902.516000]        c0385420 e8686550 00000000 e7068444 00000000 e7068444 e70682bc ecffffff 
[ 3902.516000]        fafbfcfd e7068444 00000000 00000000 00000000 ffffffff 00000000 00000000 
[ 3902.516000] Call Trace:
[ 3902.516000]  [<c012a8e9>] flush_workqueue+0x29/0x40
[ 3902.516000]  [<f8a17f68>] ata_exec_internal+0x88/0xd0 [libata]
[ 3902.516000]  [<c01d83e6>] __delay+0x6/0x10
[ 3902.516000]  [<f8a17311>] ata_dev_configure+0x51/0x830 [libata]
[ 3902.516000]  [<f8a180a3>] ata_dev_read_id+0xf3/0x310 [libata]
[ 3902.516000]  [<f8a1fbdd>] ata_do_eh+0x100d/0x1960 [libata]
[ 3902.516000]  [<c012dc10>] autoremove_wake_function+0x0/0x50
[ 3902.516000]  [<c0117601>] __activate_task+0x21/0x40
[ 3902.516000]  [<f8a14910>] ata_std_softreset+0x0/0xe0 [libata]
[ 3902.516000]  [<f8a19430>] ata_std_prereset+0x0/0x180 [libata]
[ 3902.516000]  [<c012a898>] flush_cpu_workqueue+0x88/0xb0
[ 3902.516000]  [<c012dc10>] autoremove_wake_function+0x0/0x50
[ 3902.516000]  [<f8a17060>] ata_std_postreset+0x0/0xd0 [libata]
[ 3902.516000]  [<f8a14910>] ata_std_softreset+0x0/0xe0 [libata]
[ 3902.516000]  [<f8a1e0c3>] ata_bmdma_error_handler+0x33/0x40 [libata]
[ 3902.516000]  [<f8a17060>] ata_std_postreset+0x0/0xd0 [libata]
[ 3902.516000]  [<f8a20bd1>] ata_scsi_error+0x1f1/0x580 [libata]
[ 3902.516000]  [<f89f2dc0>] scsi_error_handler+0x0/0xb50 [scsi_mod]
[ 3902.516000]  [<f89f2e72>] scsi_error_handler+0xb2/0xb50 [scsi_mod]
[ 3902.516000]  [<c0117479>] __wake_up_common+0x39/0x60
[ 3902.516000]  [<f89f2dc0>] scsi_error_handler+0x0/0xb50 [scsi_mod]
[ 3902.516000]  [<c012d938>] kthread+0xa8/0xe0
[ 3902.516000]  [<c012d890>] kthread+0x0/0xe0
[ 3902.516000]  [<c01041e7>] kernel_thread_helper+0x7/0x10
[ 3902.516000]  =======================
[ 3902.516000] Code: 00 f6 46 0e 80 0f 85 13 07 00 00 83 7e 78 05 0f 84 52 03 00 00 8d 57 b8 c7 44 24 54 ff ff ff ff c7 44 24 58 00 00 00 00 8b 42 10 <0f> b6 40 4c 88 44 24 3f 8b 47 64 8b 5a 20 8d 54 24 54 8b af 28 
[ 3902.516000] EIP: [<f8a2178c>] ata_acpi_exec_tfs+0xfc/0x9e0 [libata] SS:ESP 0068:e7b47d10
[ 3902.516000]  <5>pccard: card ejected from slot 0

$ ./ver_linux 
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
 Linux fangorn 2.6.20-8-386 #2 Tue Feb 13 05:15:43 UTC 2007 i686
 GNU/Linux
  
  Gnu C                  4.1.2
  Gnu make               3.81
  binutils               2.17.50
  util-linux             2.12r
  mount                  2.12r
  module-init-tools      3.3-pre2
  e2fsprogs              1.40-WIP
  jfsutils               1.1.11
  reiserfsprogs          3.6.19
  reiser4progs           1.0.5
  xfsprogs               2.8.18
  pcmciautils            014
  pcmcia-cs              3.2.8
  PPP                    2.4.4
  Linux C Library        > libc.2.5
  Dynamic linker (ldd)   2.5
  Procps                 3.2.7
  Net-tools              1.60
  Console-tools          0.2.3
  Sh-utils               5.97
  udev                   103
  wireless-tools         28
  Modules Loaded         pata_pcmcia binfmt_misc rfcomm l2cap ppdev ipv6
  nfs lockd sunrpc acpi_cpufreq cpufreq_userspace cpufreq_stats
  cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative
  video sbs i2c_ec i2c_core dock button battery container ac asus_acpi
  backlight aes ieee80211_crypt_ccmp sbp2 parport_pc lp parport joydev
  tsdev pcmcia sg snd_intel8x0 snd_ac97_codec sr_mod cdrom ac97_bus
  snd_pcm_oss snd_mixer_oss pcspkr serio_raw snd_pcm ipw2200 rtc
  snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
  hci_usb ieee80211 ieee80211_crypt bluetooth psmouse iTCO_wdt snd_seq
  snd_timer snd_seq_device iTCO_vendor_support intel_agp snd soundcore
  yenta_socket rsrc_nonstatic pcmcia_core snd_page_alloc agpgart shpchp
  pci_hotplug evdev ext3 jbd mbcache usb_storage ide_disk ata_piix
  ata_generic libata scsi_mod libusual piix ohci1394 ieee1394 generic
  ehci_hcd tg3 uhci_hcd usbcore raid10 raid456 xor raid1 raid0 multipath
  linear md_mod thermal processor fan dm_mod fbcon tileblit font bitblit
  softcursor vesafb capability commoncap af_packet
 
$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 13
model name      : Intel(R) Pentium(R) M processor 1.10GHz
stepping        : 8
cpu MHz         : 600.000
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe nx est tm2
bogomips        : 1198.48
clflush size    : 64

$ cat /proc/modules 
pata_pcmcia 12170 2 - Loading 0xf906d000
binfmt_misc 11272 1 - Live 0xf9069000
rfcomm 37660 0 - Live 0xf9076000
l2cap 22276 5 rfcomm, Live 0xf9062000
ppdev 9220 0 - Live 0xf8f95000
ipv6 245728 14 - Live 0xf8fe3000
nfs 232428 1 - Live 0xf9028000
lockd 63112 2 nfs, Live 0xf8fa5000
sunrpc 155068 3 nfs,lockd, Live 0xf8fbc000
acpi_cpufreq 7564 1 - Live 0xf8f88000
cpufreq_userspace 4116 0 - Live 0xf8f8e000
cpufreq_stats 5508 0 - Live 0xf8f8b000
cpufreq_powersave 1792 0 - Live 0xf8cda000
cpufreq_ondemand 7676 1 - Live 0xf8f85000
freq_table 4740 3 acpi_cpufreq,cpufreq_stats,cpufreq_ondemand, Live
0xf8f7d000
cpufreq_conservative 6560 0 - Live 0xf8f7a000
video 15492 0 - Live 0xf8f80000
sbs 14752 0 - Live 0xf8f6e000
i2c_ec 4992 1 sbs, Live 0xf8f6b000
i2c_core 21776 1 i2c_ec, Live 0xf8f73000
dock 9208 0 - Live 0xf8f67000
button 7696 0 - Live 0xf8cdc000
battery 9860 0 - Live 0xf8cb6000
container 4352 0 - Live 0xf8cd5000
ac 5124 0 - Live 0xf8cc0000
asus_acpi 16412 0 - Live 0xf8f61000
backlight 6016 1 asus_acpi, Live 0xf8cbd000
aes 27712 2 - Live 0xf8ccd000
ieee80211_crypt_ccmp 7552 2 - Live 0xf8cba000
sbp2 23044 0 - Live 0xf8c08000
parport_pc 34980 0 - Live 0xf8cc3000
lp 11332 0 - Live 0xf8cb2000
parport 35272 3 ppdev,parport_pc,lp, Live 0xf8c5b000
joydev 9920 0 - Live 0xf8c57000
tsdev 7872 0 - Live 0xf8c1a000
pcmcia 38316 2 pata_pcmcia, Live 0xf8c8f000
sg 35484 0 - Live 0xf8c85000
snd_intel8x0 32796 3 - Live 0xf8c7b000
snd_ac97_codec 93856 1 snd_intel8x0, Live 0xf8c9a000
sr_mod 15908 0 - Live 0xf8c15000
cdrom 36512 1 sr_mod, Live 0xf8c71000
ac97_bus 2304 1 snd_ac97_codec, Live 0xf8b7a000
snd_pcm_oss 43264 0 - Live 0xf8c65000
snd_mixer_oss 16512 1 snd_pcm_oss, Live 0xf8c0f000
pcspkr 3072 0 - Live 0xf8afe000
serio_raw 6916 0 - Live 0xf8b7c000
snd_pcm 76680 4 snd_intel8x0,snd_ac97_codec,snd_pcm_oss, Live 0xf8c1e000
ipw2200 147016 0 - Live 0xf8c32000
rtc 13104 0 - Live 0xf8c01000
snd_seq_dummy 3844 0 - Live 0xf8ae0000
snd_seq_oss 31616 0 - Live 0xf8b68000
snd_seq_midi 8576 0 - Live 0xf8aef000
snd_rawmidi 24448 1 snd_seq_midi, Live 0xf8b71000
snd_seq_midi_event 7424 2 snd_seq_oss,snd_seq_midi, Live 0xf8add000
hci_usb 17052 2 - Live 0xf8ae9000
ieee80211 33480 1 ipw2200, Live 0xf8af4000
ieee80211_crypt 6144 2 ieee80211_crypt_ccmp,ieee80211, Live 0xf8a47000
bluetooth 50788 7 rfcomm,l2cap,hci_usb, Live 0xf8b5a000
psmouse 37512 0 - Live 0xf8b4f000
iTCO_wdt 10656 0 - Live 0xf8a9c000
snd_seq 49648 6
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live
0xf8b41000
snd_timer 22276 3 snd_pcm,snd_seq, Live 0xf8ae2000
snd_seq_device 8204 5
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live
0xf8aa3000
iTCO_vendor_support 3972 1 iTCO_wdt, Live 0xf8a4a000
intel_agp 23964 1 - Live 0xf8ac4000
snd 51716 14
snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device,
Live 0xf8acb000
soundcore 7520 1 snd, Live 0xf8aa0000
yenta_socket 26636 4 - Live 0xf8ab2000
rsrc_nonstatic 13184 1 yenta_socket, Live 0xf8a86000
pcmcia_core 39696 4 pata_pcmcia,pcmcia,yenta_socket,rsrc_nonstatic, Live
0xf8aa7000
snd_page_alloc 9992 2 snd_intel8x0,snd_pcm, Live 0xf8a8b000
agpgart 32176 2 intel_agp, Live 0xf8a91000
shpchp 33300 0 - Live 0xf8a50000
pci_hotplug 31160 1 shpchp, Live 0xf8a5b000
evdev 10112 4 - Live 0xf8a4c000
ext3 129416 1 - Live 0xf8a65000
jbd 53032 1 ext3, Live 0xf8a31000
mbcache 8196 1 ext3, Live 0xf8976000
usb_storage 70848 0 - Live 0xf898c000
ide_disk 16000 3 - Live 0xf8971000
ata_piix 15108 0 - Live 0xf8958000
ata_generic 7812 0 - Live 0xf8840000
libata 117400 3 pata_pcmcia,ata_piix,ata_generic, Live 0xf8a13000
scsi_mod 141580 5 sbp2,sg,sr_mod,usb_storage,libata, Live 0xf89ef000
libusual 16912 1 usb_storage, Live 0xf88ff000
piix 10244 0 [permanent], Live 0xf885c000
ohci1394 35376 0 - Live 0xf88f5000
ieee1394 297016 2 sbp2,ohci1394, Live 0xf89a5000
generic 5124 0 [permanent], Live 0xf8864000
ehci_hcd 32652 0 - Live 0xf88b4000
tg3 107396 0 - Live 0xf892d000
uhci_hcd 23820 0 - Live 0xf887a000
usbcore 131352 6 hci_usb,usb_storage,libusual,ehci_hcd,uhci_hcd, Live
0xf890b000
raid10 24576 0 - Live 0xf88a2000
raid456 123152 0 - Live 0xf88c3000
xor 15752 1 raid456, Live 0xf8889000
raid1 23936 0 - Live 0xf8882000
raid0 8704 0 - Live 0xf8876000
multipath 8832 0 - Live 0xf8860000
linear 6400 0 - Live 0xf883d000
md_mod 76948 7 raid10,raid456,raid1,raid0,multipath,linear, Live
0xf888e000
thermal 13704 0 - Live 0xf8843000
processor 22956 2 acpi_cpufreq,thermal, Live 0xf8855000
fan 4740 0 - Live 0xf8835000
dm_mod 57164 4 - Live 0xf8867000
fbcon 41760 0 - Live 0xf8849000
tileblit 2688 1 fbcon, Live 0xf882b000
font 8320 1 fbcon, Live 0xf8839000
bitblit 6016 1 fbcon, Live 0xf8832000
softcursor 2304 1 bitblit, Live 0xf882d000
vesafb 8196 0 - Live 0xf8819000
capability 5000 0 - Live 0xf8828000
commoncap 7296 1 capability, Live 0xf881d000
af_packet 20872 4 - Live 0xf8821000


$ cat /proc/ioports 
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0100-010f : pcmcia_socket0
0170-0177 : 0000:00:1f.1
01f0-01f7 : 0000:00:1f.1
01f0-01f7 : ide0
0376-0376 : 0000:00:1f.1
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ide0
04d0-04d1 : pnp 00:02
07b0-07bb : pnp 00:0c
07c0-07df : pnp 00:0c
0900-090f : pnp 00:08
0910-091f : pnp 00:08
0920-092f : pnp 00:08
0930-093b : pnp 00:0b
093c-093f : pnp 00:08
0940-097f : pnp 00:08
0bb0-0bbb : pnp 00:0c
0bc0-0bdf : pnp 00:0c
0cf8-0cff : PCI conf1
0fb0-0fbb : pnp 00:0c
0fc0-0fdf : pnp 00:0c
1000-107f : 0000:00:1f.0
  1000-1005 : motherboard
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
  1006-1007 : motherboard
    1006-1007 : pnp 00:03
  1008-100f : motherboard
    1008-100b : ACPI PM_TMR
  1020-1020 : ACPI PM2_CNT_BLK
  1028-102f : ACPI GPE0_BLK
  1060-107f : motherboard
    1060-107f : pnp 00:03
      1060-107f : iTCO_wdt
1080-10bf : 0000:00:1f.0
  1080-10bf : motherboard
    1080-10bf : pnp 00:03
10c0-10df : 0000:00:1f.3
  10c0-10df : motherboard
    10c0-10df : pnp 00:03
10e0-10ff : motherboard
  10e0-10e5 : ACPI CPU throttle
13b0-13bb : motherboard
  13b0-13bb : pnp 00:0c
13c0-13df : motherboard
  13c0-13df : pnp 00:0c
1400-14ff : PCI CardBus #03
17b0-17bb : motherboard
17c0-17df : motherboard
1800-18ff : PCI CardBus #03
1bb0-1bbb : motherboard
1bc0-1bdf : motherboard
1fb0-1fbb : motherboard
1fc0-1fdf : motherboard
23b0-23bb : motherboard
23c0-23df : motherboard
27b0-27bb : motherboard
27c0-27df : motherboard
2bb0-2bbb : motherboard
2bc0-2bdf : motherboard
2fb0-2fbb : motherboard
2fc0-2fdf : motherboard
33b0-33bb : motherboard
33c0-33df : motherboard
37b0-37bb : motherboard
37c0-37df : motherboard
3bb0-3bbb : motherboard
3bc0-3bdf : motherboard
3fb0-3fbb : motherboard
3fc0-3fdf : motherboard
43b0-43bb : motherboard
43c0-43df : motherboard
47b0-47bb : motherboard
47c0-47df : motherboard
4bb0-4bbb : motherboard
4bc0-4bdf : motherboard
4fb0-4fbb : motherboard
4fc0-4fdf : motherboard
53b0-53bb : motherboard
53c0-53df : motherboard
57b0-57bb : motherboard
57c0-57df : motherboard
5bb0-5bbb : motherboard
5bc0-5bdf : motherboard
5fb0-5fbb : motherboard
5fc0-5fdf : motherboard
63b0-63bb : motherboard
63c0-63df : motherboard
67b0-67bb : motherboard
67c0-67df : motherboard
6bb0-6bbb : motherboard
6bc0-6bdf : motherboard
6fb0-6fbb : motherboard
6fc0-6fdf : motherboard
73b0-73bb : motherboard
73c0-73df : motherboard
77b0-77bb : motherboard
77c0-77df : motherboard
7bb0-7bbb : motherboard
7bc0-7bdf : motherboard
7fb0-7fbb : motherboard
7fc0-7fdf : motherboard
83b0-83bb : motherboard
83c0-83df : motherboard
87b0-87bb : motherboard
87c0-87df : motherboard
8bb0-8bbb : motherboard
8bc0-8bdf : motherboard
8fb0-8fbb : motherboard
8fc0-8fdf : motherboard
93b0-93bb : motherboard
93c0-93df : motherboard
97b0-97bb : motherboard
97c0-97df : motherboard
9bb0-9bbb : motherboard
9bc0-9bdf : motherboard
9fb0-9fbb : motherboard
9fc0-9fdf : motherboard
a3b0-a3bb : motherboard
a3c0-a3df : motherboard
a7b0-a7bb : motherboard
a7c0-a7df : motherboard
abb0-abbb : motherboard
abc0-abdf : motherboard
afb0-afbb : motherboard
afc0-afdf : motherboard
b3b0-b3bb : motherboard
b3c0-b3df : motherboard
b7b0-b7bb : motherboard
b7c0-b7df : motherboard
bbb0-bbbb : motherboard
bbc0-bbdf : motherboard
bf20-bf3f : 0000:00:1d.3
  bf20-bf3f : uhci_hcd
bf40-bf5f : 0000:00:1d.2
  bf40-bf5f : uhci_hcd
bf60-bf7f : 0000:00:1d.1
  bf60-bf7f : uhci_hcd
bf80-bf9f : 0000:00:1d.0
  bf80-bf9f : uhci_hcd
bfa0-bfaf : 0000:00:1f.1
  bfa0-bfa7 : ide0
bfb0-bfbb : motherboard
bfc0-bfdf : motherboard
c3b0-c3bb : motherboard
c3c0-c3df : motherboard
c7b0-c7bb : motherboard
c7c0-c7df : motherboard
cbb0-cbbb : motherboard
cbc0-cbdf : motherboard
cfb0-cfbb : motherboard
cfc0-cfdf : motherboard
d3b0-d3bb : motherboard
d3c0-d3df : motherboard
d7b0-d7bb : motherboard
d7c0-d7df : motherboard
dbb0-dbbb : motherboard
dbc0-dbdf : motherboard
dfb0-dfbb : motherboard
dfc0-dfdf : motherboard
e3b0-e3bb : motherboard
e3c0-e3df : motherboard
e7b0-e7bb : motherboard
e7c0-e7df : motherboard
ebb0-ebbb : motherboard
ebc0-ebdf : motherboard
ec38-ec3f : 0000:00:02.0
ec40-ec7f : 0000:00:1e.2
  ec40-ec7f : Intel ICH6
ec80-ecff : 0000:00:1e.3
ed00-edff : 0000:00:1e.2
  ed00-edff : Intel ICH6
ee00-eeff : 0000:00:1e.3
efb0-efbb : motherboard
efc0-efdf : motherboard
f3b0-f3bb : motherboard
f3c0-f3df : motherboard
f400-f4fe : motherboard
  f400-f4fe : pnp 00:03
f7b0-f7bb : motherboard
f7c0-f7df : motherboard
fbb0-fbbb : motherboard
fbc0-fbdf : motherboard
ffb0-ffbb : motherboard
ffc0-ffdf : motherboard

$ cat /proc/iomem 
00000000-0009efff : System RAM
  00000000-00000000 : Crash kernel
0009f000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cf800-000cffff : Adapter ROM
000f0000-000fffff : System ROM
00100000-4f7d17ff : System RAM
  00100000-002dbfa2 : Kernel code
  002dbfa3-003b0433 : Kernel data
4f7d1800-4fffffff : reserved
60000000-63ffffff : PCI Bus #02
  60000000-63ffffff : PCI CardBus #03
64000000-67ffffff : PCI CardBus #03
c0000000-cfffffff : 0000:00:02.0
dfc00000-dfcfffff : PCI Bus #02
  dfc00000-dfc00fff : 0000:02:01.0
    dfc00000-dfc00fff : yenta_socket
  dfc10000-dfc10fff : pcmcia_socket0
  dfcfe700-dfcfe7ff : 0000:02:01.2
  dfcfe800-dfcfefff : 0000:02:01.1
    dfcfe800-dfcfefff : ohci1394
  dfcff000-dfcfffff : 0000:02:03.0
    dfcff000-dfcfffff : ipw2200
dfd00000-dfdfffff : PCI Bus #01
  dfdf0000-dfdfffff : 0000:01:00.0
    dfdf0000-dfdfffff : tg3
dfebfd00-dfebfdff : 0000:00:1e.2
  dfebfd00-dfebfdff : Intel ICH6
dfebfe00-dfebffff : 0000:00:1e.2
  dfebfe00-dfebffff : Intel ICH6
dfec0000-dfefffff : 0000:00:02.0
dff00000-dff7ffff : 0000:00:02.0
dff80000-dfffffff : 0000:00:02.1
e0000000-f0006fff : reserved
f0008000-f000bfff : reserved
fec00000-fec0ffff : reserved
fed20000-fee0ffff : reserved
ffa80800-ffa80bff : 0000:00:1d.7
  ffa80800-ffa80bff : ehci_hcd
ffb00000-ffffffff : reserved

$ lspci -vvv
00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML Express Processor to DRAM Controller (rev 03)
	Subsystem: Dell Unknown device 01a3
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller (rev 03) (prog-if 00 [VGA])
	Subsystem: Dell Unknown device 01a3
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at dff00000 (32-bit, non-prefetchable) [size=512K]
	Region 1: I/O ports at ec38 [size=8]
	Region 2: Memory at c0000000 (32-bit, prefetchable) [size=256M]
	Region 3: Memory at dfec0000 (32-bit, non-prefetchable) [size=256K]
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller (rev 03)
	Subsystem: Dell Unknown device 01a3
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: Memory at dff80000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express Port 1 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: dfd00000-dfdfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
		Link: Latency L0s <256ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 2, PowerLimit 6.500000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0100c  Data: 41b9
	Capabilities: [90] Subsystem: Gammagraphx, Inc. Unknown device 0000
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01a3
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at bf80 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01a3
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 18
	Region 4: I/O ports at bf60 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01a3
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 19
	Region 4: I/O ports at bf40 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01a3
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 17
	Region 4: I/O ports at bf20 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB2 EHCI Controller (rev 03) (prog-if 20 [EHCI])
	Subsystem: Dell Unknown device 01a3
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at ffa80800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d3) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=02, subordinate=06, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: dfc00000-dfcfffff
	Prefetchable memory behind bridge: 0000000060000000-0000000063ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Subsystem: Dell Unknown device 01a3

00:1e.2 Multimedia audio controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Audio Controller (rev 03)
	Subsystem: Dell Unknown device 01a3
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at ed00 [size=256]
	Region 1: I/O ports at ec40 [size=64]
	Region 2: Memory at dfebfe00 (32-bit, non-prefetchable) [size=512]
	Region 3: Memory at dfebfd00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1e.3 Modem: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Modem Controller (rev 03) (prog-if 00 [Generic])
	Subsystem: Conexant Unknown device 5423
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 18
	Region 0: I/O ports at ee00 [size=256]
	Region 1: I/O ports at ec80 [size=128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface Bridge (rev 03)
	Subsystem: Dell Unknown device 01a3
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Dell Unknown device 01a3
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at bfa0 [size=16]

00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus Controller (rev 03)
	Subsystem: Dell Unknown device 01a3
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 10
	Region 4: I/O ports at 10c0 [size=32]

01:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5751 Gigabit Ethernet PCI Express (rev 01)
	Subsystem: Dell Unknown device 01a3
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at dfdf0000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
		Address: 8954c6a7d6240ffc  Data: a149
	Capabilities: [d0] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s <4us, L1 unlimited
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
		Link: Latency L0s <2us, L1 <64us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [13c] Virtual Channel

02:01.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b3)
	Subsystem: Dell Unknown device 01a3
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 168
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at dfc00000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
	Memory window 0: 60000000-63fff000 (prefetchable)
	Memory window 1: 64000000-67fff000
	I/O window 0: 00001400-000014ff
	I/O window 1: 00001800-000018ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001

02:01.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 08) (prog-if 10 [OHCI])
	Subsystem: Dell Unknown device 01a3
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (500ns min, 1000ns max)
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at dfcfe800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME+

02:01.2 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 17) (prog-if 01)
	Subsystem: Dell Unknown device 01a3
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin C routed to IRQ 10
	Region 0: Memory at dfcfe700 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

02:03.0 Network controller: Intel Corporation PRO/Wireless 2200BG Network Connection (rev 05)
	Subsystem: Intel Corporation Unknown device 2721
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (750ns min, 6000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at dfcff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-

$ cat /proc/scsi/scsi 
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: SONY     Model: CDRW/DVD CRX835E Rev: KDKE
  Type:   CD-ROM                           ANSI SCSI revision: 02

-- 
Stéphane Epardaud
