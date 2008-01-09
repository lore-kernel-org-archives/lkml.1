Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbYAIMXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbYAIMXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbYAIMWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:22:47 -0500
Received: from rosi.naasa.net ([212.8.0.13]:57242 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbYAIMWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:22:43 -0500
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Wed, 9 Jan 2008 13:22:33 +0100
User-Agent: KMail/1.9.7
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200801071151.11200.lists@naasa.net> <200801090713.15655.lists@naasa.net> <399880302.13852@ustc.edu.cn>
In-Reply-To: <399880302.13852@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_LyLhHJMffvMBTyp"
Message-Id: <200801091322.35133.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_LyLhHJMffvMBTyp
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Am Mittwoch, 9. Januar 2008 schrieb Fengguang Wu:

Thank your for the hint with the filesystems!

> Thank you for the clue. However I cannot reproduce the bug on
> ext2/2.6.24-rc7. Can you provide more details? Thank you.

I attached some more information. I'm using the ata_piix driver for my PATA 
disk and cdrom drive and booted with hpet=force. Kernel 2.6.23.X has been 
patched with the -hrt patches to enable the hidden hpet time on the ICH4-M 
chipset. I just rebooted the notebook and mounted /tmp again as ext2 and now 
the iowait problem is back. Seems to be reproducible on my computer. What 
additional information do you need?

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605


--Boundary-00=_LyLhHJMffvMBTyp
Content-Type: text/plain;
  charset="iso-8859-1";
  name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci"

00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller (rev 03)
00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP Controller (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 81)
00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 01)
00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 01)
00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)
00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 01)
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon R250 [Mobility FireGL 9000] (rev 02)
02:00.0 CardBus bridge: Texas Instruments PCI1520 PC card Cardbus Controller (rev 01)
02:00.1 CardBus bridge: Texas Instruments PCI1520 PC card Cardbus Controller (rev 01)
02:01.0 Ethernet controller: Intel Corporation 82540EP Gigabit Ethernet Controller (Mobile) (rev 03)
02:02.0 Ethernet controller: Atheros Communications, Inc. AR5211 802.11ab NIC (rev 01)

--Boundary-00=_LyLhHJMffvMBTyp
Content-Type: text/plain;
  charset="iso-8859-1";
  name="lsmod"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lsmod"

Module                  Size  Used by
radeon                112644  2 
drm                    73684  3 radeon
binfmt_misc            10568  1 
rfcomm                 35924  1 
l2cap                  22660  5 rfcomm
bluetooth              51872  4 rfcomm,l2cap
snd_rtctimer            3616  1 
nfsd                  201652  13 
auth_rpcgss            39492  1 nfsd
exportfs                4544  1 nfsd
af_packet              20292  4 
autofs4                20356  2 
ipt_MASQUERADE          3328  3 
iptable_nat             6660  1 
nf_nat                 17948  2 ipt_MASQUERADE,iptable_nat
nf_conntrack_ipv4      16328  11 iptable_nat
xt_state                2304  9 
ipt_LOG                 5632  9 
xt_limit                2432  9 
ipt_REJECT              4288  2 
xt_mark                 1728  2 
xt_tcpudp               2944  12 
xt_mac                  1728  38 
iptable_filter          2752  1 
xt_MARK                 2048  3 
xt_multiport            2880  8 
iptable_mangle          2560  1 
ip_tables              12168  3 iptable_nat,iptable_filter,iptable_mangle
x_tables               13828  12 ipt_MASQUERADE,iptable_nat,xt_state,ipt_LOG,xt_limit,ipt_REJECT,xt_mark,xt_tcpudp,xt_mac,xt_MARK,xt_multiport,ip_tables
nf_conntrack_ftp        8224  0 
nf_conntrack           61200  6 ipt_MASQUERADE,iptable_nat,nf_nat,nf_conntrack_ipv4,xt_state,nf_conntrack_ftp
cpufreq_userspace       3800  0 
cpufreq_stats           4868  0 
cpufreq_powersave       1600  0 
nfs                   227136  0 
lockd                  59576  3 nfsd,nfs
nfs_acl                 3264  2 nfsd,nfs
sunrpc                169308  11 nfsd,auth_rpcgss,nfs,lockd,nfs_acl
deflate                 3520  0 
zlib_deflate           17960  1 deflate
zlib_inflate           15488  1 deflate
twofish                 6592  0 
twofish_common         36416  1 twofish
camellia               28736  0 
serpent                18368  0 
blowfish                8128  0 
des_generic            16128  0 
cbc                     4288  0 
ecb                     3328  0 
aes_generic            26536  0 
aes_i586               32436  0 
geode_aes               5700  0 
blkcipher               6404  3 cbc,ecb,geode_aes
xcbc                    5384  0 
sha256_generic         11008  0 
sha1_generic            2432  0 
md5                     3840  0 
crypto_null             2368  0 
hmac                    4352  0 
crypto_hash             2048  2 xcbc,hmac
cryptomgr               3520  0 
crypto_algapi          16256  19 deflate,twofish,camellia,serpent,blowfish,des_generic,cbc,ecb,aes_generic,aes_i586,geode_aes,blkcipher,xcbc,sha256_generic,sha1_generic,md5,crypto_null,hmac,cryptomgr
af_key                 35536  0 
nls_utf8                1920  1 
ntfs                   92900  1 
nls_base                7040  2 nls_utf8,ntfs
ext2                   65160  1 
fuse                   44948  1 
ebtable_broute          1984  0 
bridge                 49112  1 ebtable_broute
llc                     7128  1 bridge
ebtable_nat             2176  0 
ebtable_filter          2176  0 
ebtables               17024  3 ebtable_broute,ebtable_nat,ebtable_filter
deadline_iosched        5376  0 
as_iosched             12488  0 
ircomm_tty             22728  0 
ircomm                 12868  1 ircomm_tty
tun                    10816  0 
acpi_cpufreq            6732  1 
sbs                    14024  0 
sbshc                   6656  1 sbs
joydev                 11008  0 
snd_intel8x0           31260  2 
snd_intel8x0m          16588  4 
snd_ac97_codec         92644  2 snd_intel8x0,snd_intel8x0m
ac97_bus                1920  1 snd_ac97_codec
snd_pcm_oss            43040  0 
snd_pcm                75976  6 snd_intel8x0,snd_intel8x0m,snd_ac97_codec,snd_pcm_oss
snd_mixer_oss          15552  1 snd_pcm_oss
irtty_sir               5952  0 
sir_dev                13508  1 irtty_sir
nsc_ircc               17040  0 
irda                  108680  4 ircomm_tty,ircomm,sir_dev,nsc_ircc
crc_ccitt               1984  1 irda
snd_seq_oss            29460  0 
parport_pc             36092  0 
parport                33544  1 parport_pc
snd_seq_midi            8800  0 
snd_rawmidi            23200  1 snd_seq_midi
8250_pnp                9472  0 
snd_seq_midi_event      6656  2 snd_seq_oss,snd_seq_midi
snd_seq                48732  6 snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              21572  3 snd_rtctimer,snd_pcm,snd_seq
snd_seq_device          7820  4 snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
yenta_socket           24268  2 
rsrc_nonstatic         11584  1 yenta_socket
pcmcia                 36660  0 
firmware_class          9216  1 pcmcia
snd                    50644  22 snd_intel8x0,snd_intel8x0m,snd_ac97_codec,snd_pcm_oss,snd_pcm,snd_mixer_oss,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
pcmcia_core            36688  3 yenta_socket,rsrc_nonstatic,pcmcia
serio_raw               6404  0 
pcspkr                  2624  0 
psmouse                36176  0 
soundcore               7364  1 snd
snd_page_alloc         10184  3 snd_intel8x0,snd_intel8x0m,snd_pcm
8250_pci               22912  0 
8250                   21880  2 8250_pnp,8250_pci
serial_core            20480  1 8250
i2c_i801                8272  0 
rng_core                4804  0 
iTCO_wdt               11616  0 
iTCO_vendor_support     3652  1 iTCO_wdt
battery                13252  0 
ac                      5892  0 
power_supply            9604  3 sbs,battery,ac
video                  18192  0 
output                  3456  1 video
button                  8080  0 
intel_agp              22868  1 
agpgart                30896  2 drm,intel_agp
evdev                  10752  7 
ext3                  121032  2 
jbd                    44116  1 ext3
mbcache                 8192  2 ext2,ext3
sg                     32800  0 
sr_mod                 15396  0 
cdrom                  32604  1 sr_mod
sd_mod                 25680  6 
ata_generic             7172  0 
usbhid                 40100  0 
hid                    26628  1 usbhid
ff_memless              5128  1 usbhid
ata_piix               17476  5 
floppy                 51632  0 
pata_acpi               6976  0 
e1000                 109824  0 
libata                144016  3 ata_generic,ata_piix,pata_acpi
scsi_mod              140948  4 sg,sr_mod,sd_mod,libata
ehci_hcd               31372  0 
uhci_hcd               22668  0 
usbcore               131256  4 usbhid,ehci_hcd,uhci_hcd
thermal                15580  0 
processor              28016  3 acpi_cpufreq,thermal
fan                     4356  0 
unix                   27220  1085 
cpufreq_conservative     6752  0 
cpufreq_ondemand        7608  1 
freq_table              4100  3 cpufreq_stats,acpi_cpufreq,cpufreq_ondemand
thinkpad_acpi          49296  0 
hwmon                   3092  1 thinkpad_acpi
nvram                   8136  1 thinkpad_acpi
fbcon                  37976  72 
tileblit                2368  1 fbcon
font                    8320  1 fbcon
bitblit                 5184  1 fbcon
softcursor              2112  1 bitblit
radeonfb               97392  1 
fb                     45768  5 fbcon,tileblit,bitblit,softcursor,radeonfb
fb_ddc                  2432  1 radeonfb
backlight               4932  3 video,thinkpad_acpi,radeonfb
i2c_algo_bit            5828  1 radeonfb
cfbcopyarea             3264  1 radeonfb
i2c_core               22224  4 i2c_i801,radeonfb,fb_ddc,i2c_algo_bit
cfbimgblt               2624  1 radeonfb
cfbfillrect             3392  1 radeonfb

--Boundary-00=_LyLhHJMffvMBTyp
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

river
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for hkey
thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle HKEY for hkey
thinkpad_acpi: wan_init: wan is not supported, status 0xf7ed8e5c
thinkpad_acpi: ibm_init: probing for video
thinkpad_acpi: video_init: initializing video subdriver
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for vid
thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle \_SB.PCI0.AGP.VID for vid
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for vid2
thinkpad_acpi: drv_acpi_handle_init: ACPI handle for vid2 not found
thinkpad_acpi: video_init: video is supported, mode 3
thinkpad_acpi: ibm_init: video installed
thinkpad_acpi: ibm_init: probing for light
thinkpad_acpi: light_init: initializing light subdriver
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for ledb
thinkpad_acpi: drv_acpi_handle_init: ACPI handle for ledb not found
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for lght
thinkpad_acpi: drv_acpi_handle_init: ACPI handle for lght not found
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for cmos
thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle \UCMS for cmos
thinkpad_acpi: light_init: light is supported
thinkpad_acpi: ibm_init: light installed
thinkpad_acpi: ibm_init: probing for bay
thinkpad_acpi: bay_init: initializing bay subdriver
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for bay
thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle \_SB.PCI0.IDE0.SCND.MSTR for bay
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for bay_ej
thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle _EJ0 for bay_ej
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for bay2
thinkpad_acpi: drv_acpi_handle_init: ACPI handle for bay2 not found
thinkpad_acpi: bay_init: bay 1: status supported, eject supported; bay 2: status not supported, eject not supported
thinkpad_acpi: setup_acpi_notify: setting up ACPI notify for bay
thinkpad_acpi: ibm_init: bay installed
thinkpad_acpi: ibm_init: probing for cmos
thinkpad_acpi: cmos_init: initializing cmos commands subdriver
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for cmos
thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle \UCMS for cmos
thinkpad_acpi: cmos_init: cmos commands are supported
thinkpad_acpi: ibm_init: cmos installed
thinkpad_acpi: ibm_init: probing for led
thinkpad_acpi: led_init: initializing LED subdriver
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for led
thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle LED for led
thinkpad_acpi: led_init: LED commands are supported, mode 3
thinkpad_acpi: ibm_init: led installed
thinkpad_acpi: ibm_init: probing for beep
thinkpad_acpi: beep_init: initializing beep subdriver
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for beep
thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle BEEP for beep
thinkpad_acpi: beep_init: beep is supported
thinkpad_acpi: ibm_init: beep installed
thinkpad_acpi: ibm_init: probing for thermal
thinkpad_acpi: thermal_init: initializing thermal subdriver
thinkpad_acpi: thermal_init: thermal is supported, mode 3
thinkpad_acpi: ibm_init: thermal installed
thinkpad_acpi: ibm_init: probing for ecdump
thinkpad_acpi: ibm_init: ecdump installed
thinkpad_acpi: ibm_init: probing for brightness
thinkpad_acpi: brightness_init: initializing brightness subdriver
thinkpad_acpi: brightness_init: selected brightness_mode=3
thinkpad_acpi: brightness_init: brightness is supported
thinkpad_acpi: ibm_init: brightness installed
thinkpad_acpi: ibm_init: probing for volume
thinkpad_acpi: ibm_init: volume installed
thinkpad_acpi: ibm_init: probing for fan
thinkpad_acpi: fan_init: initializing fan subdriver
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for fans
thinkpad_acpi: drv_acpi_handle_init: ACPI handle for fans not found
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for gfan
thinkpad_acpi: drv_acpi_handle_init: ACPI handle for gfan not found
thinkpad_acpi: drv_acpi_handle_init: trying to locate ACPI handle for sfan
thinkpad_acpi: drv_acpi_handle_init: ACPI handle for sfan not found
thinkpad_acpi: fan_init: fan is supported, modes 2, 2
thinkpad_acpi: ibm_init: fan installed
input: ThinkPad Extra Buttons as /class/input/input1
NET: Registered protocol family 1
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU] (supports 8 throttling states)
Marking TSC unstable due to: TSC halts in idle.
Time: hpet clocksource has been installed.
ACPI: Thermal Zone [THM0] (50 C)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001820
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
SCSI subsystem initialized
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001840
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
libata version 3.00 loaded.
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 11, io mem 0xc0000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
e1000: 0000:02:01.0: e1000_validate_option: PHY Smart Power Down Enabled
e1000: 0000:02:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:16:41:10:19:11
usb 2-1: new low speed USB device using uhci_hcd and address 2
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ACPI: PCI interrupt for device 0000:00:1f.1 disabled
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1860 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1868 irq 15
usb 2-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech Optical USB Mouse as /class/input/input2
input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.1-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
ata1.00: ATA-7: SAMSUNG HM160JC, AP100-16, max UDMA/100
ata1.00: 312581808 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2.00: ATAPI: UJDA745 DVD/CDRW, 1.06, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM160JC  AP10 PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            MATSHITA UJDA745 DVD/CDRW 1.06 PQ: 0 ANSI: 5
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Driver 'sr' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: [sda] Attached SCSI disk
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
Attempting manual resume
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Linux agpgart interface v0.102
agpgart: Detected an Intel 855PM Chipset.
agpgart: AGP aperture is 256M @ 0xd0000000
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input4
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [SLPB]
input: Video Bus as /class/input/input6
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH4-M TCO device (Version=1, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
intel_rng: FWH not detected
ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI interrupt for device 0000:00:1f.6 disabled
input: PC Speaker as /class/input/input7
Yenta: CardBus bridge found at 0000:02:00.0 [1014:0512]
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:00.0, mfunc 0x01d21022, devctl 0x64
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0x4000 - 0x8fff
cs: IO port probe 0x4000-0x8fff: clean.
pcmcia: parent PCI bridge Memory window: 0xc0200000 - 0xcfffffff
pcmcia: parent PCI bridge Memory window: 0xe8000000 - 0xefffffff
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
Synaptics Touchpad, model: 1, fw: 5.9, id: 0x2c6ab1, caps: 0x884793/0x0
serio: Synaptics pass-through port at isa0060/serio1/input0
Yenta: CardBus bridge found at 0000:02:00.1 [1014:0512]
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:00.1, mfunc 0x01d21022, devctl 0x64
input: SynPS/2 Synaptics TouchPad as /class/input/input8
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x3bc (0x7bc), irq 7, dma 0 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
NET: Registered protocol family 23
nsc-ircc 00:0c: activated
nsc-ircc, chip->init
nsc-ircc, Found chip at base=0x02e
nsc-ircc, driver loaded (Dag Brattli)
IrDA: Registered device irda0
nsc-ircc, Using dongle: IBM31T1100 or Temic TFDS6000/TFDS6500
Yenta: ISA IRQ mask 0x0430, PCI irq 11
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0x4000 - 0x8fff
cs: IO port probe 0x4000-0x8fff: clean.
pcmcia: parent PCI bridge Memory window: 0xc0200000 - 0xcfffffff
pcmcia: parent PCI bridge Memory window: 0xe8000000 - 0xefffffff
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.6 to 64
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.5 to 64
cs: IO port probe 0xc00-0xcff: clean.
cs: IO port probe 0x800-0x8ff: clean.
cs: IO port probe 0x100-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0xa00-0xaff: clean.
cs: IO port probe 0xc00-0xcff: clean.
cs: IO port probe 0x800-0x8ff: clean.
cs: IO port probe 0x100-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0xa00-0xaff: clean.
intel8x0_measure_ac97_clock: measured 52955 usecs
intel8x0: measured clock 207 rejected
intel8x0: clocking to 48000
Adding 1951856k swap on /dev/sda5.  Priority:-1 extents:1 across:1951856k
EXT3 FS on sda6, internal journal
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
IrCOMM protocol (Dag Brattli)
io scheduler anticipatory registered
io scheduler deadline registered
Ebtables v2.0 registered
Bridge firewalling registered
fuse init (API version 7.9)
EXT2-fs warning (device sda7): ext2_fill_super: mounting ext3 filesystem as ext2
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
NTFS driver 2.1.29 [Flags: R/O MODULE].
NTFS volume version 3.1.
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input9
NET: Registered protocol family 15
padlock: VIA PadLock Hash Engine not detected.
padlock: VIA PadLock Hash Engine not detected.
padlock: VIA PadLock not detected.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
Clocksource tsc unstable (delta = -197916262 ns)
e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
NET: Registered protocol family 17
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.28.0 20060524 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
[drm] Setting GART location based on new memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 2 usecs

--Boundary-00=_LyLhHJMffvMBTyp--
