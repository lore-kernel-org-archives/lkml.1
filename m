Return-Path: <linux-kernel-owner+w=401wt.eu-S1763065AbYBPAmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763065AbYBPAmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbYBPAl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:41:59 -0500
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:44868
	"EHLO QMTA02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635AbYBPAl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:41:56 -0500
X-Authority-Analysis: v=1.0 c=1 a=bojhYoMd2USPMMK5XVEeMQ==:17
 a=t88WT2mrxyaeZXGZVukA:9 a=XGb3SciSDdCJINAGz48A:7
 a=-WSg51Fu8j2ROnlnla_HukeiudoA:4 a=50e4U0PicR4A:10
From: kelk1@comcast.net (Quel Qun)
To: linux-kernel@vger.kernel.org
Subject: Kernel oops with bluetooth usb dongle
Date: Sat, 16 Feb 2008 00:41:52 +0000
Message-Id: <021620080041.476.47B631500001264E000001DC2200761438CE05040A05@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct 30 2007)
X-Authenticated-Sender: a2VsazFAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since the rc's of 2.6.24, my machine crashes when I try to use the USB dongle. 
No other activity seems to create a crash. The system is stable with 2.6.23.1. 
It is a Dell Dimension 8400 updated daily to mandriva cooker. I am not 
subscribed 
to this list, so please CC me if there is any more information I can provide.

Here is the Oops with 2.6.25-rc1:

BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<c0131f3e>] get_next_timer_interrupt+0xfe/0x210
*pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: hidp rfcomm l2cap nfsd auth_rpcgss exportfs nfs lockd nfs_acl 
sunrpc af_packet binfmt_misc loop nls_iso8859_1 nls_cp437 vfat fat dm_mod piix 
ide_core fuse snd_pcm_oss snd_mixer_oss hci_usb snd_intel8x0 snd_ac97_codec 
ac97_bus thermal button snd_pcm i2c_i801 snd_timer parport_pc processor snd 
parport pcspkr i2c_core evdev dcdbas tg3 soundcore rtc_cmos bluetooth 
snd_page_alloc iTCO_wdt sr_mod iTCO_vendor_support sg ata_piix ahci libata 
sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ssb pcmcia pcmcia_core ehci_hcd 
usbcore [last unloaded: scsi_wait_scan]

Pid: 0, comm: swapper Not tainted (2.6.25-rc1 #1)
EIP: 0060:[<c0131f3e>] EFLAGS: 00010097 CPU: 0
EIP is at get_next_timer_interrupt+0xfe/0x210
EAX: 00000000 EBX: 00000000 ECX: c047e7dc EDX: 00000000
ESI: 00000026 EDI: c047e6ac EBP: c03f5f60 ESP: c03f5f28
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c03f4000 task=c03c9300 task.ti=c03f4000)
Stack: 0005a600 0005a55b c047dea0 00000000 00000001 00000026 000005a6 c047e6ac
       c047e8ac c047eaac c047ecac c1808340 ffc484c0 0005a55b c03f5fa4 c014627c
       ffd3c700 c03c9300 c03c947c c180b420 ffc4cdde 0000009b ffc484c0 0000009b
Call Trace:
 [<c014627c>] ? tick_nohz_stop_sched_tick+0x13c/0x350
 [<c014658c>] ? tick_nohz_restart_sched_tick+0xfc/0x140
 [<c0103a20>] ? default_idle+0x0/0xa0
 [<c0103854>] ? cpu_idle+0x34/0x110
 [<c0322519>] ? rest_init+0x49/0x50
 =======================
Code: e0 89 c6 89 45 dc 8d b4 26 00 00 00 00 8b 04 f7 8b 10 0f 18 02 90 8d 0c f7 
39 c8 0f 84 83 00 00 00 8b 40 08 39 d8 0f 48 d8 89 d0 <8b> 12 0f 18 02 90 39 c1 
75 ec c7 45 d4 01 00 00 00 8b 7d dc 85
EIP: [<c0131f3e>] get_next_timer_interrupt+0xfe/0x210 SS:ESP 0068:c03f5f28
---[ end trace 5fb484ad8037e593 ]---
Kernel panic - not syncing: Attempted to kill the idle task!

$ lsub -vvv
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB UHCI #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Dimension 8400
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at ff40 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

# ./ver_linux 
Linux macine.domain.com 2.6.25-rc1 #1 SMP Fri Feb 15 14:39:54 PST 2008 i686 
Intel(R) Pentium(R) 4 CPU 3.20GHz GNU/Linux
 
Gnu C                  4.2.2
Gnu make               3.81
binutils               2.18.50.0.3.20071102
util-linux             2.13.1
mount                  2.13.1
module-init-tools      3.3-pre11
e2fsprogs              1.40.6
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.10
udev                   118
Modules Loaded         nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc 
af_packet binfmt_misc loop nls_iso8859_1 nls_cp437 vfat fat dm_mod piix ide_core 
fuse snd_pcm_oss snd_mixer_oss hci_usb snd_intel8x0 snd_ac97_codec thermal 
ac97_bus i2c_i801 snd_pcm processor button i2c_core parport_pc snd_timer pcspkr 
iTCO_wdt sr_mod rtc_cmos parport snd iTCO_vendor_support soundcore bluetooth 
dcdbas tg3 evdev snd_page_alloc sg ata_piix ahci libata sd_mod scsi_mod ext3 jbd 
uhci_hcd ohci_hcd ssb pcmcia pcmcia_core ehci_hcd usbcore

Bus 003 Device 002: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle 
(HCI mode)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth
  bMaxPacketSize0        64
  idVendor           0x0a12 Cambridge Silicon Radio, Ltd
  idProduct          0x0001 Bluetooth Dongle (HCI mode)
  bcdDevice            1.84
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          193
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xc0
      Self Powered
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass       254 Application Specific Interface
      bInterfaceSubClass      1 Device Firmware Update
      bInterfaceProtocol      0 
      iInterface              0 
      ** UNRECOGNIZED:  07 21 07 88 13 ff 03
Device Status:     0x0000
  (Bus Powered)

Bus 003 Device 001: ID 1d6b:0001  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b 
  idProduct          0x0001 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.25-rc1 uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Thank you for your time.
--
kk1
