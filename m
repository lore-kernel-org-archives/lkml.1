Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYJIV4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYJIV4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbYJIV4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:56:30 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:54723 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683AbYJIV43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:56:29 -0400
Message-ID: <48EE7E0A.8040701@dgreaves.com>
Date: Thu, 09 Oct 2008 22:56:26 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: SMART to USB/sata dock in 2.6.27-rc5 doesn't work
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I just bought a usb/sata adapter like this:
  http://www.thinkgeek.com/computing/drives/a7ea/?cpg=ab
lsusb -v is below

Works OK as a hot-plug SATA disk so I can check what's on that old disk in the
corner; but smartctl doesn't work so I can't see if it has any errors, run
selftests etc.

Kernel is 2.6.27-rc5 (I've also tried older kernels)

I plugged a previously zeroed drive in and...

root@ash:~ # smartctl -a /dev/sde
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Device: ST332062 0AS              Version:
Device type: disk
Local Time is: Thu Oct  9 21:38:16 2008 BST
Device supports SMART and is Enabled
Temperature Warning Disabled or Not Supported
SMART Health Status: OK

Error Counter logging not supported
Device does not support Self Test logging


I've tried -dscsi and -dsat but they don't work.

More info below.

David


dmesg tail:
Initializing USB Mass Storage driver...
scsi8 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
scsi 8:0:0:0: Direct-Access     ST332062 0AS                   PQ: 0 ANSI: 2
sd 8:0:0:0: [sde] 625134827 512-byte hardware sectors (320069 MB)
sd 8:0:0:0: [sde] Write Protect is off
sd 8:0:0:0: [sde] Mode Sense: 38 00 00 00
sd 8:0:0:0: [sde] Assuming drive cache: write through
sd 8:0:0:0: [sde] 625134827 512-byte hardware sectors (320069 MB)
sd 8:0:0:0: [sde] Write Protect is off
sd 8:0:0:0: [sde] Mode Sense: 38 00 00 00
sd 8:0:0:0: [sde] Assuming drive cache: write through
 sde: unknown partition table
sd 8:0:0:0: [sde] Attached SCSI disk
sd 8:0:0:0: Attached scsi generic sg6 type 0

root@ash:~ # lsusb -v -s3:3

Bus 003 Device 003: ID 04fc:0c25 Sunplus Technology Co., Ltd
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x04fc Sunplus Technology Co., Ltd
  idProduct          0x0c25
  bcdDevice            1.03
  iManufacturer           2 Sunplus Technology Inc.
  iProduct                3 USB to Serial-ATA bridge
  iSerial                 1 SAMSUNG HD472712CQ696126
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 Bulk Only Configuration
    bmAttributes         0xc0
      Self Powered
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
      iInterface              5 Bulk Only Interface
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
Device Status:     0x0001
  Self Powered



-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
