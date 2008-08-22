Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbYHVWbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbYHVWbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 18:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYHVWas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 18:30:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:34471 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbYHVWaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 18:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=mcFcfNTrId4wrm768fc59qobHoHc8VK1+VaSn0ivQr9CeZex8JLvkX5iCSUKZT+jc8
         6kad/d3K15oxhqFVMA/5JKygkn3UvUSJDtKx3nPWswRMLbwcwlT6/bfJgAI8f571b2vJ
         iWeQJaFr8NoV8M6/KQvA3HHSDm6oWdCF0aLMw=
Message-ID: <2f5034170808221530h6bea5dc9hcb63a839a9589d2e@mail.gmail.com>
Date: Fri, 22 Aug 2008 17:30:44 -0500
From: "Tony Murray" <murraytony@gmail.com>
To: klloyd@sierrawireless.com, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Patch: Correct Sierra Wireless USB EVDO Modem Device ID
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to figure out why my device wasn't supported by the
drivers/usb/serial/sierra.c driver, while looking throught the device
IDs I spotted what I believe to be a typo in the device IDs.  Please
apply the following patch:

--- drivers/usb/serial/sierra.c.orig    2008-08-22 16:55:00.000000000 -0500
+++ drivers/usb/serial/sierra.c 2008-08-22 17:08:55.000000000 -0500
@@ -185,7 +185,7 @@
        { USB_DEVICE(0x1199, 0x0017) }, /* Sierra Wireless EM5625 */
        { USB_DEVICE(0x1199, 0x0018) }, /* Sierra Wireless MC5720 */
        { USB_DEVICE(0x1199, 0x0218) }, /* Sierra Wireless MC5720 */
-       { USB_DEVICE(0x0f30, 0x1b1d) }, /* Sierra Wireless MC5720 */
+       { USB_DEVICE(0x03f0, 0x1b1d) }, /* HP ev2200 a.k.a MC5720 */
        { USB_DEVICE(0x1199, 0x0020) }, /* Sierra Wireless MC5725 */
        { USB_DEVICE(0x1199, 0x0220) }, /* Sierra Wireless MC5725 */
        { USB_DEVICE(0x1199, 0x0019) }, /* Sierra Wireless AirCard 595 */


If you look down further, there is another HP wireless broadband card,
which has a vendor ID of 03f0, like my device.  Below is my "lsusb -v
-d 03f0:1b1d".

Bus 001 Device 005: ID 03f0:1b1d Hewlett-Packard
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x03f0 Hewlett-Packard
  idProduct          0x1b1d
  bcdDevice            0.01
  iManufacturer           1 HP
  iProduct                2 HP ev2200 1xEV-DO Broadband Wireless Module
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           67
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
      bNumEndpoints           7
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              3 Data Interface
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval             128
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
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)


Tony Murray

PS: Sorry about the multi-list spam, but I was unsure exactly to send this.
