Return-Path: <linux-kernel-owner+w=401wt.eu-S1762046AbXGCVp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762046AbXGCVp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbXGCVpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:45:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:4746 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbXGCVpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:45:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QC16USSKrBJ7/vRRwEJWeSclEB7sQhkCrozfEuaDFcvq1qTfkB0YUVKt+S2pkw5YOA52/rb31C3Km+6sdN+q1FdaiphCi0A1sgErWpe+oO/4t0OiWRp6BvTYadBawxfvOQT9K50R9Thd6vX8dXAAmdZs4r/Y/qBKuX8zH9LOcjs=
Message-ID: <a9e22dff0707031445q759b7bafqa81fc8f407c5cf3@mail.gmail.com>
Date: Wed, 4 Jul 2007 00:45:17 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] for NIKON D50 as UMS
In-Reply-To: <a9e22dff0707031341o199032ejb6fe4b4ecde4af61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a9e22dff0707031303i30c08439t3cc48fb1b95f29b8@mail.gmail.com>
	 <a9e22dff0707031341o199032ejb6fe4b4ecde4af61@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This short patch allows NIKON D50 to be mounted as UMS[unusual device]
on Linux niam 2.6.22-rc7-cfs-v18 #2 PREEMPT Tue Jul 3 22:35:53 EEST
2007 i686 Intel(R) Celeron(R) M processor 1.50GHz GenuineIntel
GNU/Linux,
some previous kernels...

lsusb -v
Bus 001 Device 006: ID 04b0:0409 Nikon Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x04b0 Nikon Corp.
  idProduct          0x0409
  bcdDevice            1.00
  iManufacturer           1 NIKON
  iProduct                2 NIKON DSC D50
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
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
Device Status:     0x0001
  Self Powered


Sorry for flood ... but I disappointed where to send this patch.

Signed-off-by: Milinevsky Dmitry <niam.niam@gmail.com>

--- linux-2.6.22-rc7/drivers/usb/storage/unusual_devs.h 2007-07-03
22:54:23.000000000 +0300
+++ linux-2.6.22-rc7-niam/drivers/usb/storage/unusual_devs.h
2007-07-03 22:35:39.000000000 +0300
@@ -313,6 +313,13 @@
                US_SC_DEVICE, US_PR_DEVICE,NULL,
                US_FL_NOT_LOCKABLE ),

+/* Reported by Milinevsky Dmitry <niam.niam@gmail.com> */
+UNUSUAL_DEV(  0x04b0, 0x0409, 0x0100, 0x0100,
+               "NIKON",
+               "NIKON DSC D50",
+               US_SC_DEVICE, US_PR_DEVICE, NULL,
+               US_FL_FIX_CAPACITY),
+
 /* Reported by Andreas Bockhold <andreas@bockionline.de> */
 UNUSUAL_DEV(  0x04b0, 0x0405, 0x0100, 0x0100,
                "NIKON",
