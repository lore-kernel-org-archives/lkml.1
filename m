Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab0BHRBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 12:01:54 -0500
Received: from ppp-156-198.adsl.restena.lu ([158.64.156.198]:49973 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab0BHRBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 12:01:51 -0500
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Feb 2010 12:01:50 EST
Date: Mon, 8 Feb 2010 17:51:45 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oliver@neukum.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Marcel Holtmann <marcel@holtmann.org>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: S2R resume crash in 2.6.33-rc7 - NULL pointer dereference in
 dev_get_drvdata() for usbhid
Message-ID: <20100208175145.606ca761@neptune.home>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-rc7 (don't know if any previous version resumes properly)
crashes during resume from S2Ram when my USB keyboard is connected but
resumes properly (viafb corruption put apart) when the USB keyboard is
not connected.

Keyboard detection:
[    3.070054] usb 2-2: new full speed USB device using uhci_hcd and address 2
[    3.220179] kbd_mode used greatest stack depth: 2228 bytes left
[    3.276403] usb 2-2: New USB device found, idVendor=058f, idProduct=9462
[    3.276514] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.276619] usb 2-2: Product: Multimedia USB Keyboard
[    3.276711] usb 2-2: Manufacturer: Multimedia USB Keyboard
[    3.278056] loadkeys used greatest stack depth: 1904 bytes left
[    3.278791] init-early.sh used greatest stack depth: 1700 bytes left
[    3.282561] hub 2-2:1.0: USB hub found
[    3.286387] hub 2-2:1.0: 3 ports detected
[    3.571454] usb 2-2.1: new full speed USB device using uhci_hcd and address 3
[    3.761474] usb 2-2.1: New USB device found, idVendor=058f, idProduct=9462
[    3.761584] usb 2-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.761719] usb 2-2.1: Product: Multimedia USB Keyboard
[    3.762518] usb 2-2.1: Manufacturer: Multimedia USB Keyboard
[    3.762612] usb 2-2.1: SerialNumber: Multimedia USB Keyboard
[    3.789221] input: Multimedia USB Keyboard Multimedia USB Keyboard as /devices/pci0000:00/0000:00:10.0/usb2/2
-2/2-2.1/2-2.1:1.0/input/input4
[    3.789585] generic-usb 0003:058F:9462.0001: input: USB HID v1.10 Keyboard [Multimedia USB Keyboard Multimedi
a USB Keyboard] on usb-0000:00:10.0-2.1/input0
[    3.818001] generic-usb: probe of 0003:058F:9462.0002 failed with error -22

Resume crash:
[   48.130061] usb 2-2: reset full speed USB device using uhci_hcd and address 2
[   48.591086] usb 2-2.1: reset full speed USB device using uhci_hcd and address 3
[   48.741106] BUG: unable to handle kernel NULL pointer dereference at 00000020
[   48.741558] IP: [<c11eabb0>] dev_get_drvdata+0x10/0x20
[   48.741902] *pde = 00000000 
[   48.742083] Oops: 0000 [#1] 
[   48.742269] last sysfs file: /sys/power/state
[   48.742528] Modules linked in: e_powersaver via_cputemp snd_hda_codec_via snd_hda_intel snd_hda_codec snd_pcm snd_timer via_agp snd soundcore viafb snd_page_alloc i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect sg agpgart
[   48.743939] 
[   48.744040] Pid: 1512, comm: bash Not tainted 2.6.33-rc7-venus #1 CX700+W697HG/CX700+W697HG
[   48.744528] EIP: 0060:[<c11eabb0>] EFLAGS: 00010202 CPU: 0
[   48.744859] EIP is at dev_get_drvdata+0x10/0x20
[   48.745121] EAX: 0000001c EBX: f6814000 ECX: 00000000 EDX: 00000000
[   48.745493] ESI: f68bd064 EDI: f6814000 EBP: f6539dbc ESP: f6539dbc
[   48.745861]  DS: 0068 ES: 007b FS: 0000 GS: 0033 SS: 0068
[   48.746178] Process bash (pid: 1512, ti=f6539000 task=f73686e0 task.ti=f6539000)
[   48.746595] Stack:
[   48.746716]  f6539dcc c12823fe f68bd064 f682fe00 f6539e00 c1282558 00000021 00000000
[   48.747391] <0> 00000001 00000000 00000000 00001388 f68bd000 f692a000 f682fe00 00000001
[   48.747975] <0> f682fe00 f6539e0c c12825a8 c149d690 f6539e34 c122e65a c1498654 f68bd000
[   48.751052] Call Trace:
[   48.751052]  [<c12823fe>] ? usbhid_restart_queues+0x3e/0x100
[   48.751052]  [<c1282558>] ? hid_post_reset+0x98/0xc0
[   48.751052]  [<c12825a8>] ? hid_reset_resume+0x28/0x30
[   48.751052]  [<c122e65a>] ? usb_resume_interface+0x9a/0x190
[   48.751052]  [<c123641f>] ? generic_resume+0xf/0x30
[   48.751052]  [<c122eb0f>] ? usb_resume_both+0x8f/0x130
[   48.751052]  [<c122f7fb>] ? usb_external_resume_device+0x2b/0x70
[   48.751052]  [<c122f85d>] ? usb_resume+0x1d/0x30
[   48.751052]  [<c12240ed>] ? usb_dev_resume+0xd/0x10
[   48.751052]  [<c11ee1b4>] ? pm_op+0x94/0xb0
[   48.751052]  [<c11711d0>] ? kobject_put+0x20/0x50
[   48.751052]  [<c11ee9f9>] ? dpm_resume_end+0xe9/0x330
[   48.751052]  [<c105131a>] ? resume_device_irqs+0x2a/0x60
[   48.751052]  [<c104d0ff>] ? suspend_devices_and_enter+0x7f/0x1a0
[   48.751052]  [<c132e0dd>] ? printk+0x18/0x1b
[   48.751052]  [<c104d320>] ? enter_state+0x100/0x120
[   48.751052]  [<c104cae0>] ? state_store+0x80/0xb0
[   48.751052]  [<c104ca60>] ? state_store+0x0/0xb0
[   48.751052]  [<c11710a4>] ? kobj_attr_store+0x24/0x30
[   48.751052]  [<c10c27bd>] ? sysfs_write_file+0x9d/0xf0
[   48.751052]  [<c10810cc>] ? vfs_write+0x9c/0x160
[   48.751052]  [<c10c2720>] ? sysfs_write_file+0x0/0xf0
[   48.751052]  [<c108124d>] ? sys_write+0x3d/0x70
[   48.751052]  [<c1002bd0>] ? sysenter_do_call+0x12/0x26
[   48.751052] Code: 55 89 e5 5d 83 f8 01 19 c0 f7 d0 83 e0 f0 c3 8d b6 00 00 00 00 8d bf 00 00 00 00 55 85 c0 89 e5 75 09 31 c0 5d c3 90 8d 74 26 00 <8b> 40 04 85 c0 74 f0 8b 40 40 5d c3 8d 74 26 00 55 89 e5 83 ec 
[   48.751052] EIP: [<c11eabb0>] dev_get_drvdata+0x10/0x20 SS:ESP 0068:f6539dbc
[   48.751052] CR2: 0000000000000020
[   49.281981] ---[ end trace 1f0c734925556462 ]---

Could the crash be related to the generic-usb probe error?

lsusb -v for the keyboard:
Bus 002 Device 003: ID 058f:9462 Alcor Micro Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x058f Alcor Micro Corp.
  idProduct          0x9462 
  bcdDevice            4.10
  iManufacturer           1 Multimedia USB Keyboard
  iProduct                2 Multimedia USB Keyboard
  iSerial                 3 Multimedia USB Keyboard
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
    MaxPower               50mA
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
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
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
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     106
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
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval             255
Device Status:     0x0000
  (Bus Powered)

Bus 002 Device 002: ID 058f:9462 Alcor Micro Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0         8
  idVendor           0x058f Alcor Micro Corp.
  idProduct          0x9462 
  bcdDevice            1.58
  iManufacturer           1 Multimedia USB Keyboard
  iProduct                2 Multimedia USB Keyboard
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower               50mA
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
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             3
  wHubCharacteristic 0x000d
    Per-port power switching
    Compound device
    Per-port overcurrent protection
  bPwrOn2PwrGood       22 * 2 milli seconds
  bHubContrCurrent     50 milli Ampere
  DeviceRemovable    0x02
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
Device Status:     0x0000
  (Bus Powered)


