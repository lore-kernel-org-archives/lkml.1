Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbZGUVQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbZGUVQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbZGUVQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:16:17 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:63292 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952AbZGUVQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:16:16 -0400
X-Greylist: delayed 2144 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 17:16:16 EDT
Message-ID: <d1351198778762a135751934d1977539.squirrel@intranet.cs.nmsu.edu>
Date: Tue, 21 Jul 2009 14:40:31 -0600
Subject: Blacklisting a usbhid device
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to write a driver for the Logitech G13 keypad, but one of the
first problems I'm running into is the usbhid driver claiming the device.

I'm working on a Fedora 11 system, so I checked the usbhid driver and it
is built in.

I applied the following patch and rebuilt the kernel, but usbhid still
claims the device. Another problem I noticed was that I received a compile
error when I used HID_QUIRK_IGNORE rather than 0x00000004.

Is it not possible to blacklist a device without compiling usbhid as a
module?

Also below is the output of lsusb -vvv for the G13.

Any suggestions on how to either work within the usbhid framework or how
to get usbhid to stop claiming the device?

Thanks,

Rick


diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6301010..611a24d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -18,6 +18,7 @@
 #ifndef HID_IDS_H_FILE
 #define HID_IDS_H_FILE

+#define USB_DEVICE_ID_LOGITECH_G13		0xc21c
 #define USB_VENDOR_ID_A4TECH		0x09da
 #define USB_DEVICE_ID_A4TECH_WCP32PU	0x0006
 #define USB_DEVICE_ID_A4TECH_X5_005D	0x000a
diff --git a/drivers/hid/usbhid/hid-quirks.c
b/drivers/hid/usbhid/hid-quirks.c
index d8f7423..65de9ef 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -63,6 +63,7 @@ static const struct hid_blacklist {

 	{ USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS,
HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_WISEGROUP_LTD2, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS,
HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
+	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G13, 0x00000004 },

 	{ 0, 0 }
 };




Bus 005 Device 007: ID 046d:c21c Logitech, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0xc21c
  bcdDevice            1.03
  iManufacturer           0
  iProduct                1 G13
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
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      61
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
        bInterval               2
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
Device Status:     0x0000
  (Bus Powered)


