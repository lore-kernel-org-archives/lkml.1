Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYAFTjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYAFTjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 14:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYAFTjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 14:39:42 -0500
Received: from smtp-out.rrz.uni-koeln.de ([134.95.19.53]:39934 "EHLO
	smtp-out.rrz.uni-koeln.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYAFTjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 14:39:39 -0500
Message-ID: <47812E5B.6080000@uni-koeln.de>
Date: Sun, 06 Jan 2008 20:39:07 +0100
From: Berthold Cogel <cogel@uni-koeln.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Al Viro <viro@ZenIV.linux.org.uk>, nigel@nigel.suspend2.net, dtor@mail.ru,
       jikos@jikos.cz, akpm@linux-foundation.org,
       linux-usb-owner@vger.kernel.org
Subject: Re: Oops in evdev_disconnect for kernel 2.6.23.12
References: <477A93CD.9030707@rrz.uni-koeln.de> <20080105065233.GE27894@ZenIV.linux.org.uk> <47801D70.8020504@uni-koeln.de> <20080106001756.GP27894@ZenIV.linux.org.uk>
In-Reply-To: <20080106001756.GP27894@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro schrieb:
> On Sun, Jan 06, 2008 at 01:14:40AM +0100, Berthold Cogel wrote:
> 
>>> There are only 4 changesets between 2.6.23 and this one affecting 
>>> drivers/input
>>> and only
>>> 8006479c9b75fb6594a7b746af3d7f1fbb68f18f and
>>> 6addb1d6de1968b84852f54561cc9a999909b5a9
>>> appear to be relevant.  Apply to your kernel and see if it helps...
>> Looks as if I have to start using git ... I always feared that this day 
>> will come. ;-)
>>
>> If I'm able to reproduce the oops with my patched kernel, I will gladly 
>> follow your advice.
> 
> AFAICS, lkml.org/lkml/2007/7/24/20 is the same patch...

Ok! It happened again....

I was able to reproduce the Oops twice. Once with my patched kernel
(2.6.23.12 patched with tuxonice-3.0-rc3-for-2.6.23.9 on Debian
stable/testing/unstable) and the second time with a vanilla 2.6.23.12
kernel. So this isn't related to Tuxonice.

The only method to reproduce the oops was to disconnect the Wacom Bamboo
tablet. So I think that my memory was failing me, when I wrote in my
original message that I haven't disconnected the tablet. Sorry about that!

The tablet is connected via a Belkin hub. All I've modified in the 
system to make the tablet work was to build a new xorg driver with the 
source from linuxwacom-0.7.9-4 (http://linuxwacom.sourceforge.net/) via
'configure/make/make install'. And I modified xorg.conf of course.

I've CC'ed everybody who has already been involved in this thread or who
I have been asked to CC. I will try to give every information avaliable,
even if I've already posted parts of it in an earlier message, to make
sure everybody has the pieces he needs.

So here's the code for the vanilla kernel:

Jan  6 19:54:45 wonderland kernel: usb 2-2.6: USB disconnect, address 6
Jan  6 19:54:45 wonderland kernel: BUG: unable to handle kernel paging
request at virtual address 00100100
Jan  6 19:54:45 wonderland kernel:  printing eip:
Jan  6 19:54:45 wonderland kernel: f8819668
Jan  6 19:54:45 wonderland kernel: *pde = 00000000
Jan  6 19:54:45 wonderland kernel: Oops: 0000 [#1]
Jan  6 19:54:45 wonderland kernel: PREEMPT
Jan  6 19:54:45 wonderland kernel: Modules linked in: nls_cp437
nls_iso8859_1 vfat fat isofs radeon drm rfcomm l2cap bluetooth ppdev lp
fan ac battery dm_crypt dm_snapshot dm_mirror sr_mod sbp2 sd_mod joydev
wacom usbhid hid ff_memless snd_emu10k1_synth snd_emux_synth
snd_seq_virmidi snd_seq_midi_emul usb_storage snd_emu10k1 firmware_class
snd_ac97_codec ac97_bus snd_util_mem snd_hwdep snd_pcm_oss snd_pcm
snd_page_alloc snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq parport_pc parport snd_timer
snd_seq_device snd rtc ide_cd soundcore i2c_viapro emu10k1_gp gameport
via_agp ehci_hcd ohci1394 ieee1394 8139too thermal uhci_hcd agpgart
button processor evdev
Jan  6 19:54:45 wonderland kernel: CPU:    0
Jan  6 19:54:45 wonderland kernel: EIP:    0060:[<f8819668>]    Not
tainted VLI
Jan  6 19:54:45 wonderland kernel: EFLAGS: 00010206   (2.6.23.12 #1)
Jan  6 19:54:45 wonderland kernel: EIP is at evdev_disconnect+0x65/0x9e
[evdev]
Jan  6 19:54:45 wonderland kernel: eax: 00000000   ebx: 000ffcf0   ecx:
c1929ca0   edx: 00000033
Jan  6 19:54:45 wonderland kernel: esi: f7750a00   edi: f7750a4c   ebp:
f7750a54   esp: c19c9e8c
Jan  6 19:54:45 wonderland kernel: ds: 007b   es: 007b   fs: 0000  gs:
0000  ss: 0068
Jan  6 19:54:45 wonderland kernel: Process khubd (pid: 136, ti=c19c8000
task=c1929ab0 task.ti=c19c8000)
Jan  6 19:54:45 wonderland kernel: Stack: f7750c00 f76de000 f76de758
f76de76c f7605858 c03388fe 00000000 c03ba302
Jan  6 19:54:45 wonderland kernel:        f758a454 c0284bba f771d3e0
f758a400 f9a37608 f9a353ab f758a400 f758a400
Jan  6 19:54:45 wonderland kernel:        f758a41c c032ada0 f758a41c
f9a37638 00000000 c02f0fa1 f758a41c f758a41c
Jan  6 19:54:45 wonderland kernel: Call Trace:
Jan  6 19:54:45 wonderland kernel:  [<c03388fe>]
input_unregister_device+0x6f/0xff
Jan  6 19:54:45 wonderland kernel:  [<c03ba302>] klist_release+0x27/0x30
Jan  6 19:54:45 wonderland kernel:  [<c0284bba>] kref_put+0x5f/0x6c
Jan  6 19:54:45 wonderland kernel:  [<f9a353ab>]
wacom_disconnect+0x2b/0x66 [wacom]
Jan  6 19:54:45 wonderland kernel:  [<c032ada0>]
usb_unbind_interface+0x2d/0x6e
Jan  6 19:54:45 wonderland kernel:  [<c02f0fa1>]
__device_release_driver+0x6e/0x8b
Jan  6 19:54:45 wonderland kernel:  [<c02f12f7>]
device_release_driver+0x1d/0x32
Jan  6 19:54:45 wonderland kernel:  [<c02f09e1>] bus_remove_device+0x6a/0x7a
Jan  6 19:54:45 wonderland kernel:  [<c02ef22b>] device_del+0x1c3/0x234
Jan  6 19:54:45 wonderland kernel:  [<c0328acb>]
usb_disable_device+0x5c/0xbb
Jan  6 19:54:45 wonderland kernel:  [<c0325445>] usb_disconnect+0x7e/0xe6
Jan  6 19:54:45 wonderland kernel:  [<c0325927>] hub_thread+0x31c/0xa10
Jan  6 19:54:45 wonderland kernel:  [<c0114e17>] update_curr+0x102/0x12c
Jan  6 19:54:45 wonderland kernel:  [<c0114a13>]
update_stats_wait_end+0x96/0xb9
Jan  6 19:54:45 wonderland kernel:  [<c012815b>]
autoremove_wake_function+0x0/0x33
Jan  6 19:54:45 wonderland kernel:  [<c032560b>] hub_thread+0x0/0xa10
Jan  6 19:54:45 wonderland kernel:  [<c01280a2>] kthread+0x36/0x5c
Jan  6 19:54:45 wonderland kernel:  [<c012806c>] kthread+0x0/0x5c
Jan  6 19:54:45 wonderland kernel:  [<c01048f7>]
kernel_thread_helper+0x7/0x10
Jan  6 19:54:45 wonderland kernel:  [<c02dcda9>] echo_char+0x49/0x5d
Jan  6 19:54:45 wonderland kernel:  =======================
Jan  6 19:54:45 wonderland kernel: Code: 5e 4c 81 eb 10 04 00 00 eb 21
8d 83 08 04 00 00 b9 06 00 02 00 ba 1d 00 00 00 e8 fa cb 94 c7 8b 9b 10
04 00 00 81 eb 10 04 00 00 <8b> 83 10 04 00 00 0f 18 00 90 8d 83 10 04
00 00 39 f8 75 cb 8d
Jan  6 19:54:45 wonderland kernel: EIP: [<f8819668>]
evdev_disconnect+0x65/0x9e [evdev] SS:ESP 0068:c19c9e8c
wonderland:/usr/src/linux#

lspci -v:

00:00.0 Host bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333]
	Subsystem: ASUSTeK Computer Inc. A7V333 Mainboard
	Flags: bus master, 66MHz, medium devsel, latency 0
	Memory at e0000000 (32-bit, prefetchable) [size=128M]
	Capabilities: [a0] AGP version 2.0
	Capabilities: [c0] Power Management version 2

00:01.0 PCI bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo
KT266/A/333 AGP] (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: c6800000-c7efffff
	Prefetchable memory behind bridge: c8000000-dfffffff
	Capabilities: [80] Power Management version 2

00:06.0 RAID bus controller: Promise Technology, Inc. PDC20276
(MBFastTrak133 Lite) (rev 01) (prog-if 85)
	Subsystem: ASUSTeK Computer Inc. A7V333 motherboard.
	Flags: bus master, 66MHz, slow devsel, latency 32, IRQ 17
	I/O ports at b800 [size=8]
	I/O ports at b400 [size=4]
	I/O ports at b000 [size=8]
	I/O ports at a800 [size=4]
	I/O ports at a400 [size=16]
	Memory at c6000000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [60] Power Management version 1

00:07.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 808d
	Flags: bus master, medium devsel, latency 35, IRQ 18
	Memory at c5800000 (32-bit, non-prefetchable) [size=2K]
	Memory at c5000000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2

00:09.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 50) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. A7V333 motherboard
	Flags: bus master, medium devsel, latency 32, IRQ 17
	I/O ports at a000 [size=32]
	Capabilities: [80] Power Management version 2

00:09.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 50) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. A7V333 motherboard
	Flags: bus master, medium devsel, latency 32, IRQ 16
	I/O ports at 9800 [size=32]
	Capabilities: [80] Power Management version 2

00:09.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 51) (prog-if
20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8080
	Flags: bus master, medium devsel, latency 32, IRQ 18
	Memory at c4800000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2

00:0e.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RT8139
	Flags: bus master, medium devsel, latency 32, IRQ 18
	I/O ports at 9400 [size=256]
	Memory at c4000000 (32-bit, non-prefetchable) [size=256]
	[virtual] Expansion ROM at 50000000 [disabled] [size=64K]
	Capabilities: [50] Power Management version 2

00:0f.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev 07)
	Subsystem: Creative Labs SBLive! 5.1 Model SB0100
	Flags: bus master, medium devsel, latency 32, IRQ 20
	I/O ports at 9000 [size=32]
	Capabilities: [dc] Power Management version 1

00:0f.1 Input device controller: Creative Labs SB Live! Game Port (rev 07)
	Subsystem: Creative Labs Gameport Joystick
	Flags: bus master, medium devsel, latency 32
	I/O ports at 8800 [size=8]
	Capabilities: [dc] Power Management version 1

00:11.0 ISA bridge: VIA Technologies, Inc. VT8233A ISA Bridge
	Subsystem: ASUSTeK Computer Inc. A7V333 motherboard
	Flags: bus master, stepping, medium devsel, latency 0
	Capabilities: [c0] Power Management version 2

00:11.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
(prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. A7V8X / A7V333 motherboard
	Flags: bus master, medium devsel, latency 32
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	I/O ports at 8400 [size=16]
	Capabilities: [c0] Power Management version 2

00:11.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 23) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. VT6202 USB2.0 4 port controller
	Flags: bus master, medium devsel, latency 32, IRQ 19
	I/O ports at 8000 [size=32]
	Capabilities: [80] Power Management version 2

00:11.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 23) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. VT6202 USB2.0 4 port controller
	Flags: bus master, medium devsel, latency 32, IRQ 19
	I/O ports at 7800 [size=32]
	Capabilities: [80] Power Management version 2

01:00.0 VGA compatible controller: ATI Technologies Inc RV350 AR [Radeon
9600] (prog-if 00 [VGA])
	Subsystem: PC Partner Limited Sapphire Radeon 9600XT
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
	Memory at d8000000 (32-bit, prefetchable) [size=128M]
	I/O ports at d800 [size=256]
	Memory at c7000000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at d7fe0000 [disabled] [size=128K]
	Capabilities: [58] AGP version 2.0
	Capabilities: [50] Power Management version 2

01:00.1 Display controller: ATI Technologies Inc RV350 AR [Radeon 9600]
(Secondary)
	Subsystem: PC Partner Limited Sapphire Radeon 9600XT (Secondary)
	Flags: bus master, 66MHz, medium devsel, latency 64
	Memory at c8000000 (32-bit, prefetchable) [size=128M]
	Memory at c6800000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [50] Power Management version 2


lsusb -v:

Bus 001 Device 001: ID 0000:0000
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x0000
   idProduct          0x0000
   bcdDevice            2.06
   iManufacturer           3 Linux 2.6.23.12 uhci_hcd
   iProduct                2 UHCI Host Controller
   iSerial                 1 0000:00:09.0
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
    Port 1: 0000.0100 power
    Port 2: 0000.0100 power
Device Status:     0x0003
   Self Powered
   Remote Wakeup Enabled

Bus 003 Device 001: ID 0000:0000
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x0000
   idProduct          0x0000
   bcdDevice            2.06
   iManufacturer           3 Linux 2.6.23.12 uhci_hcd
   iProduct                2 UHCI Host Controller
   iSerial                 1 0000:00:09.1
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
    Port 1: 0000.0100 power
    Port 2: 0000.0100 power
Device Status:     0x0003
   Self Powered
   Remote Wakeup Enabled

Bus 004 Device 003: ID 046d:c404 Logitech, Inc. TrackMan Wheel
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x046d Logitech, Inc.
   idProduct          0xc404 TrackMan Wheel
   bcdDevice            2.20
   iManufacturer           1 Logitech
   iProduct                2 Trackball
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           34
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              100mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      1 Boot Interface Subclass
       bInterfaceProtocol      2 Mouse
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.10
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength     103
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10
Device Status:     0x0000
   (Bus Powered)

Bus 004 Device 002: ID 045e:00db Microsoft Corp. Natural Ergonomic 
Keyboard 4000 V1.0
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x045e Microsoft Corp.
   idProduct          0x00db Natural Ergonomic Keyboard 4000 V1.0
   bcdDevice            1.73
   iManufacturer           1 Microsoft
   iProduct                2 Natural® Ergonomic Keyboard 4000
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           59
     bNumInterfaces          2
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              100mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      1 Boot Interface Subclass
       bInterfaceProtocol      1 Keyboard
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.11
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength      60
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      0 No Subclass
       bInterfaceProtocol      0 None
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.11
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength      86
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10
Device Status:     0x0000
   (Bus Powered)

Bus 004 Device 001: ID 0000:0000
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x0000
   idProduct          0x0000
   bcdDevice            2.06
   iManufacturer           3 Linux 2.6.23.12 uhci_hcd
   iProduct                2 UHCI Host Controller
   iSerial                 1 0000:00:11.2
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
    Port 1: 0000.0303 lowspeed power enable connect
    Port 2: 0000.0303 lowspeed power enable connect
Device Status:     0x0003
   Self Powered
   Remote Wakeup Enabled

Bus 005 Device 001: ID 0000:0000
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x0000
   idProduct          0x0000
   bcdDevice            2.06
   iManufacturer           3 Linux 2.6.23.12 uhci_hcd
   iProduct                2 UHCI Host Controller
   iSerial                 1 0000:00:11.3
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
    Port 1: 0000.0100 power
    Port 2: 0000.0100 power
Device Status:     0x0003
   Self Powered
   Remote Wakeup Enabled

Bus 002 Device 006: ID 056a:0065 Wacom Co., Ltd
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x056a Wacom Co., Ltd
   idProduct          0x0065
   bcdDevice            1.08
   iManufacturer           1 Wacom Co.,Ltd.
   iProduct                2 MTE-450
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           34
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower               44mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      1 Boot Interface Subclass
       bInterfaceProtocol      2 Mouse
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.00
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength     146
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0009  1x 9 bytes
         bInterval               4
Device Status:     0x0000
   (Bus Powered)

Bus 002 Device 005: ID 046d:c218 Logitech, Inc. Logitech RumblePad 2 USB
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x046d Logitech, Inc.
   idProduct          0xc218 Logitech RumblePad 2 USB
   bcdDevice            1.00
   iManufacturer           1 Logitech
   iProduct                2 Logitech RumblePad 2 USB
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           41
     bNumInterfaces          1
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
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      0 No Subclass
       bInterfaceProtocol      0 None
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.10
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength     119
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10
Device Status:     0x0000
   (Bus Powered)

Bus 002 Device 004: ID 067b:3507 Prolific Technology, Inc. PL3507 ATAPI6 
Bridge
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x067b Prolific Technology, Inc.
   idProduct          0x3507 PL3507 ATAPI6 Bridge
   bcdDevice            0.01
   iManufacturer           1 ASSMANN Electronic GmbH
   iProduct                2
   iSerial                 3 200412A18E9
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           32
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                2mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass         8 Mass Storage
       bInterfaceSubClass      6 SCSI
       bInterfaceProtocol     80 Bulk (Zip)
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
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
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)

Bus 002 Device 003: ID 050d:0237 Belkin Components
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         2 TT per port
   bMaxPacketSize0        64
   idVendor           0x050d Belkin Components
   idProduct          0x0237
   bcdDevice            0.00
   iManufacturer           0
   iProduct                0
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           41
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                2mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      1 Single TT
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              12
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      2 TT per port
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              12
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             7
   wHubCharacteristic 0x0000
     Ganged power switching
     Ganged overcurrent protection
     TT think time 8 FS bits
   bPwrOn2PwrGood       50 * 2 milli seconds
   bHubContrCurrent      1 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0100 power
    Port 2: 0000.0100 power
    Port 3: 0000.0100 power
    Port 4: 0000.0100 power
    Port 5: 0000.0303 lowspeed power enable connect
    Port 6: 0000.0103 power enable connect
    Port 7: 0000.0100 power
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0001
   Self Powered

Bus 002 Device 002: ID 07cc:0340 Carry Computer Eng., Co., Ltd
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x07cc Carry Computer Eng., Co., Ltd
   idProduct          0x0340
   bcdDevice            0.05
   iManufacturer           1         Ltd
   iProduct                2 Winter Ver1.3
   iSerial                 3 377162540753
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           32
     bNumInterfaces          1
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
       bInterfaceClass         8 Mass Storage
       bInterfaceSubClass      6 SCSI
       bInterfaceProtocol     80 Bulk (Zip)
       iInterface              4 1.06.30.0704
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
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
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)

Bus 002 Device 001: ID 0000:0000
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         1 Single TT
   bMaxPacketSize0        64
   idVendor           0x0000
   idProduct          0x0000
   bcdDevice            2.06
   iManufacturer           3 Linux 2.6.23.12 ehci_hcd
   iProduct                2 EHCI Host Controller
   iSerial                 1 0000:00:09.2
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
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval              12
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             4
   wHubCharacteristic 0x000a
     No power switching (usb 1.0)
     Per-port overcurrent protection
     TT think time 8 FS bits
   bPwrOn2PwrGood       10 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0503 highspeed power enable connect
    Port 2: 0000.0503 highspeed power enable connect
    Port 3: 0000.0100 power
    Port 4: 0000.0503 highspeed power enable connect
Device Status:     0x0003
   Self Powered
   Remote Wakeup Enabled


My next step will be a test of the system with a vanilla 2.6.24-rc6.
Please tell me if there is anything else I can do.


Regards,

Berthold Cogel
