Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbZHPN4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbZHPN4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 09:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZHPN4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 09:56:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:1443 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbZHPN4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 09:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=P70ZmBMtieQwFTn7T3IVUxbaXotFQ8tgVSPZYII6ojduQsaowI6mQsY1/VCPId+jMu
         gltNKJdn3IbmEUm7DA6BkrWIiOdO0D80tXsmUk/K8ESKIfehi97AvxN5XMbTMOrAKMKf
         UjHT3PtJBdt9wUKV1A+SPW7DEDIzMGfJlEm4c=
MIME-Version: 1.0
Date: Sun, 16 Aug 2009 14:56:29 +0100
Message-ID: <589ee1d0908160656u40672d47i7a7abe9923681f09@mail.gmail.com>
Subject: Oops: sysfs: duplicate filename 'usbdev3.3_ep81' can not be created
From: Christian Roche <christian.roche.fr@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I'm encountering a kernel oops when trying to use a USB 3G modem. The
modem is an LG LDU-1900D USB key used in Morocco to access Wana's 3G
network. The modem works fine in Vista but comes with no Linux
drivers. I've seen one similar message in the list archive, but it
seems to be related to another, already corrected bug
(http://www.gossamer-threads.com/lists/linux/kernel/981459#981459).

Does anyone here have an idea ? Thanks to kindly keep me cc'ed, I'm
not subscribed to the list (a tad too technical for me :-)

My system: Linux jimi 2.6.29.6-217.2.3.fc11.i586 #1 SMP Wed Jul 29
15:46:46 EDT 2009 i686 i686 i386 GNU/Linux

The USB key is a dual storage/modem system. When I plug it in at first
things seem to go ok, I get the following messages and I can mount and
access the virtual CRDOM:
=========== cut ===================== cut =====================
usb 3-2: new full speed USB device using uhci_hcd and address 2
usb 3-2: New USB device found, idVendor=1004, idProduct=1000
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 3-2: Product: USB MMC Storage
usb 3-2: Manufacturer: LG Electronics Inc.
usb 3-2: SerialNumber: 000000000002
usb 3-2: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi4 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 4:0:0:0: CD-ROM            LGE EVDO Mass Storage     2.31 PQ: 0 ANSI: 2
sr1: scsi3-mmc drive: 297x/297x
sr 4:0:0:0: Attached scsi CD-ROM sr1
sr 4:0:0:0: Attached scsi generic sg3 type 5
sr1: CDROM (ioctl) error, command: Get configuration 46 00 00 00 00 00
00 00 20 00
sr: Sense Key : No Sense [current]
sr: Add. Sense: No additional sense information
=========== cut ===================== cut =====================

Then I have to use usb_modeswitch to replace the internal storage with
the modem, accorging to this page (in French, sorry):
http://www.experts-libre.com/index.php?post/2008/12/09/Modem-EV-DO-RevA-LG-LDU-1900D

> sb_modeswitch -v 0x1004 -p 0x1000 -m 0x08 -M 55534243c83244ff0000000000000aff554d53434847000000000000000000

The modeswitch goes ok. However that's when I get the kernel oops:
=========== cut ===================== cut =====================
usb 3-2: USB disconnect, address 2
usb 3-2: new full speed USB device using uhci_hcd and address 3
usb 3-2: New USB device found, idVendor=1004, idProduct=6107
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: LG EV-DO USB MODEM
usb 3-2: Manufacturer: LG Electronics Inc.
usb 3-2: configuration #1 chosen from 1 choice
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:462 sysfs_add_one+0x32/0x3d() (Not tainted)
Hardware name: System Product Name
sysfs: duplicate filename 'usbdev3.3_ep81' can not be created
Modules linked in: usb_storage ipv6 sunrpc cpufreq_ondemand
acpi_cpufreq dm_multipath snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_timer iTCO_wdt snd
iTCO_vendor_support ppdev soundcore snd_page_alloc parport_pc tulip
i2c_i801 atl2 parport asus_atk0110 serio_raw pcspkr hwmon ata_generic
pata_acpi i915 drm i2c_algo_bit i2c_core video output [last unloaded:
scsi_wait_scan]
Pid: 27, comm: khubd Not tainted 2.6.29.6-217.2.3.fc11.i586 #1
Call Trace:
 [<c042ebaa>] warn_slowpath+0x7c/0xa4
 [<c055e004>] ? put_dec+0x2e/0x104
 [<c055a41d>] ? idr_get_empty_slot+0x13c/0x1e7
 [<c055a41d>] ? idr_get_empty_slot+0x13c/0x1e7
 [<c04aee23>] ? find_inode+0x25/0x5e
 [<c04dea64>] ? sysfs_ilookup_test+0x0/0x16
 [<c04af9d2>] ? wait_on_inode+0x2f/0x32
 [<c04afc23>] ? ifind+0x57/0x6a
 [<c04dea64>] ? sysfs_ilookup_test+0x0/0x16
 [<c04dec9b>] ? sysfs_find_dirent+0x1b/0x2c
 [<c04dee09>] sysfs_add_one+0x32/0x3d
 [<c04df95a>] sysfs_do_create_link+0xb0/0x109
 [<c04df9d3>] sysfs_create_link+0xf/0x14
 [<c05dd9df>] device_add+0x162/0x3f9
 [<c05ddc8d>] device_register+0x17/0x1a
 [<c06265c2>] usb_create_ep_devs+0x1e6/0x250
 [<c06217b4>] create_intf_ep_devs+0x3e/0x53
 [<c0622cfc>] usb_set_configuration+0x46c/0x484
 [<c0628fff>] generic_probe+0x49/0x82
 [<c0622edd>] usb_probe_device+0x39/0x3b
 [<c05df4b6>] driver_probe_device+0xa1/0x119
 [<c05df5ab>] __device_attach+0xd/0xf
 [<c05dec57>] bus_for_each_drv+0x42/0x6c
 [<c05df629>] device_attach+0x58/0x6c
 [<c05df59e>] ? __device_attach+0x0/0xf
 [<c05dead2>] bus_attach_device+0x26/0x55
 [<c05ddb50>] device_add+0x2d3/0x3f9
 [<c07060cc>] ? printk+0x14/0x18
 [<c061dcfa>] usb_new_device+0xfd/0x146
 [<c061ec99>] hub_thread+0x75e/0xb85
 [<c0402aa1>] ? __switch_to+0x7b/0xfd
 [<c0440029>] ? autoremove_wake_function+0x0/0x34
 [<c061e53b>] ? hub_thread+0x0/0xb85
 [<c043fd50>] kthread+0x41/0x65
 [<c043fd0f>] ? kthread+0x0/0x65
 [<c0404877>] kernel_thread_helper+0x7/0x10
---[ end trace c2178fb0797924f2 ]---
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:462 sysfs_add_one+0x32/0x3d() (Tainted: G        W )
Hardware name: System Product Name
sysfs: duplicate filename 'usbdev3.3_ep81' can not be created
Modules linked in: usb_storage ipv6 sunrpc cpufreq_ondemand
acpi_cpufreq dm_multipath snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_timer iTCO_wdt snd
iTCO_vendor_support ppdev soundcore snd_page_alloc parport_pc tulip
i2c_i801 atl2 parport asus_atk0110 serio_raw pcspkr hwmon ata_generic
pata_acpi i915 drm i2c_algo_bit i2c_core video output [last unloaded:
scsi_wait_scan]
Pid: 27, comm: khubd Tainted: G        W  2.6.29.6-217.2.3.fc11.i586 #1
Call Trace:
 [<c042ebaa>] warn_slowpath+0x7c/0xa4
 [<c0422a79>] ? set_next_entity+0x90/0xfc
 [<c055e004>] ? put_dec+0x2e/0x104
 [<c042a00d>] ? finish_task_switch+0x34/0x9f
 [<c055a41d>] ? idr_get_empty_slot+0x13c/0x1e7
 [<c055a41d>] ? idr_get_empty_slot+0x13c/0x1e7
 [<c04aee23>] ? find_inode+0x25/0x5e
 [<c04dea64>] ? sysfs_ilookup_test+0x0/0x16
 [<c04af9d2>] ? wait_on_inode+0x2f/0x32
 [<c04afc23>] ? ifind+0x57/0x6a
 [<c04dea64>] ? sysfs_ilookup_test+0x0/0x16
 [<c04dec9b>] ? sysfs_find_dirent+0x1b/0x2c
 [<c04dee09>] sysfs_add_one+0x32/0x3d
 [<c04df95a>] sysfs_do_create_link+0xb0/0x109
 [<c04df9d3>] sysfs_create_link+0xf/0x14
 [<c05dd9df>] device_add+0x162/0x3f9
 [<c05ddc8d>] device_register+0x17/0x1a
 [<c06265c2>] usb_create_ep_devs+0x1e6/0x250
 [<c06217b4>] create_intf_ep_devs+0x3e/0x53
 [<c0622cfc>] usb_set_configuration+0x46c/0x484
 [<c0628fff>] generic_probe+0x49/0x82
 [<c0622edd>] usb_probe_device+0x39/0x3b
 [<c05df4b6>] driver_probe_device+0xa1/0x119
 [<c05df5ab>] __device_attach+0xd/0xf
 [<c05dec57>] bus_for_each_drv+0x42/0x6c
 [<c05df629>] device_attach+0x58/0x6c
 [<c05df59e>] ? __device_attach+0x0/0xf
 [<c05dead2>] bus_attach_device+0x26/0x55
 [<c05ddb50>] device_add+0x2d3/0x3f9
 [<c07060cc>] ? printk+0x14/0x18
 [<c061dcfa>] usb_new_device+0xfd/0x146
 [<c061ec99>] hub_thread+0x75e/0xb85
 [<c0402aa1>] ? __switch_to+0x7b/0xfd
 [<c0440029>] ? autoremove_wake_function+0x0/0x34
 [<c061e53b>] ? hub_thread+0x0/0xb85
 [<c043fd50>] kthread+0x41/0x65
 [<c043fd0f>] ? kthread+0x0/0x65
 [<c0404877>] kernel_thread_helper+0x7/0x10
---[ end trace c2178fb0797924f3 ]---
cdc_acm 3-2:1.0: ttyACM0: USB ACM device
cdc_acm 3-2:1.2: ttyACM1: USB ACM device
cdc_acm 3-2:1.4: ttyACM2: USB ACM device
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and
ISDN adapters
=========== cut ===================== cut =====================

Afterwards the /dev/ttyACM0 port doesn't work, always comes back with
some "Input/Output error".
Here's the output of lsusb -v in case it might help:

=========== cut ===================== cut =====================
Bus 003 Device 003: ID 1004:6107 LG Electronics, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            2 Communications
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1004 LG Electronics, Inc.
  idProduct          0x6107
  bcdDevice            0.00
  iManufacturer           1
  iProduct                2
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          183
    bNumInterfaces          6
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      2 Abstract (modem)
      bInterfaceProtocol      1 AT-commands (v.25ter)
      iInterface              0
      CDC Header:
        bcdCDC               1.09
      CDC Call Management:
        bmCapabilities       0x03
          call management
          use DataInterface
        bDataInterface          1
      CDC ACM:
        bmCapabilities       0x0f
          connection notifications
          sends break
          line coding and serial state
          get/set/clear comm features
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0
      iInterface              3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      2 Abstract (modem)
      bInterfaceProtocol      1 AT-commands (v.25ter)
      iInterface              0
      CDC Header:
        bcdCDC               1.09
      CDC Call Management:
        bmCapabilities       0x03
          call management
          use DataInterface
        bDataInterface          3
      CDC ACM:
        bmCapabilities       0x0f
          connection notifications
          sends break
          line coding and serial state
          get/set/clear comm features
      CDC Union:
        bMasterInterface        2
        bSlaveInterface         3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0
      iInterface              3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      2 Abstract (modem)
      bInterfaceProtocol      1 AT-commands (v.25ter)
      iInterface              0
      CDC Header:
        bcdCDC               1.09
      CDC Call Management:
        bmCapabilities       0x03
          call management
          use DataInterface
        bDataInterface          5
      CDC ACM:
        bmCapabilities       0x0f
          connection notifications
          sends break
          line coding and serial state
          get/set/clear comm features
      CDC Union:
        bMasterInterface        4
        bSlaveInterface         5
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval              32
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0
      iInterface              3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x06  EP 6 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
=========== cut ===================== cut =====================
