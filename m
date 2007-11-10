Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbXKJVlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbXKJVlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 16:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbXKJVlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 16:41:11 -0500
Received: from rtr.ca ([76.10.145.34]:1973 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212AbXKJVlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 16:41:09 -0500
Message-ID: <47362573.4050309@rtr.ca>
Date: Sat, 10 Nov 2007 16:41:07 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-usb-users@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       mdharm-usb@one-eyed-alien.net, dbrownell@users.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: USB storage: corrupted data transfers
References: <47361D24.8020708@rtr.ca>
In-Reply-To: <47361D24.8020708@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Something may be broken in USB / usb-storage land.
> 
> I've got a 2GB USB stick here.
> I want to copy it to an image file on my hard drive:
> 
>    cat /dev/sdb > usbkey.image1
> 
> Make a second copy, with or without unplugging/replugging the stick:
> 
>    cat /dev/sdb > usbkey.image2
> 
> After doing this, the two copies *differ*.

Here's the information on the specific devices I'm trying this with.

I'm beginning to suspect a faulty stick, or maybe one that just doesn't
work reliably with the way Linux accesses it (?).  The type that fails
(I have several of that model here) also gives some errors from "lsusb -v"
(see below for details).

I have another completely different brand/model of 2GB stick here
that has now been confirmed to NOT have any such issues.

Perhaps the USB experts here could comment on the differences
in information they report from lsusb --> maybe it's somethere there
that makes one of them fail, and the other one work?

First, the BAD one:

Bus 001 Device 084: ID 1307:0163  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1307 
  idProduct          0x0163 
  bcdDevice            1.00
  iManufacturer           1 USB 2.0
  iProduct                2 Flash Disk
  iSerial                 3 465743a79ca017
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower               80mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
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
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               8
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1

can't get debug descriptor: Connection timed out
cannot read device status, Connection timed out (110)

****************************

Now, the GOOD one:

Bus 001 Device 087: ID 1005:b113 Apacer Technology, Inc. Handy Steno 2.0 (256MB)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1005 Apacer Technology, Inc.
  idProduct          0xb113 Handy Steno 2.0 (256MB)
  bcdDevice            1.00
  iManufacturer           1         
  iProduct                2 USB FLASH DRIVE 
  iSerial                 3 1962140002E9
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
    MaxPower              200mA
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

**************************

Now just a "diff -u" of the above:

--- bad 	2007-11-10 16:29:35.000000000 -0500
+++ good	2007-11-10 16:36:59.000000000 -0500
@@ -1,4 +1,4 @@
-Bus 001 Device 084: ID 1307:0163  
+Bus 001 Device 087: ID 1005:b113 Apacer Technology, Inc. Handy Steno 2.0 (256MB)
 Device Descriptor:
   bLength                18
   bDescriptorType         1
@@ -7,29 +7,29 @@
   bDeviceSubClass         0 
   bDeviceProtocol         0 
   bMaxPacketSize0        64
-  idVendor           0x1307 
-  idProduct          0x0163 
+  idVendor           0x1005 Apacer Technology, Inc.
+  idProduct          0xb113 Handy Steno 2.0 (256MB)
   bcdDevice            1.00
-  iManufacturer           1 USB 2.0
-  iProduct                2 Flash Disk
-  iSerial                 3 465743a79ca017
+  iManufacturer           1         
+  iProduct                2 USB FLASH DRIVE 
+  iSerial                 3 1962140002E9
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
-    wTotalLength           39
+    wTotalLength           32
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0 
     bmAttributes         0x80
       (Bus Powered)
-    MaxPower               80mA
+    MaxPower              200mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
-      bNumEndpoints           3
+      bNumEndpoints           2
       bInterfaceClass         8 Mass Storage
       bInterfaceSubClass      6 SCSI
       bInterfaceProtocol     80 Bulk (Zip)
@@ -37,33 +37,23 @@
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
-        bEndpointAddress     0x01  EP 1 OUT
+        bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
-        bInterval               1
+        bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
-        bEndpointAddress     0x82  EP 2 IN
+        bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
-        bInterval               1
-      Endpoint Descriptor:
-        bLength                 7
-        bDescriptorType         5
-        bEndpointAddress     0x83  EP 3 IN
-        bmAttributes            3
-          Transfer Type            Interrupt
-          Synch Type               None
-          Usage Type               Data
-        wMaxPacketSize     0x0040  1x 64 bytes
-        bInterval               8
+        bInterval               0
 Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
@@ -73,7 +63,5 @@
   bDeviceProtocol         0 
   bMaxPacketSize0        64
   bNumConfigurations      1
-
-can't get debug descriptor: Connection timed out
-cannot read device status, Connection timed out (110)
-
+Device Status:     0x0000
+  (Bus Powered)
