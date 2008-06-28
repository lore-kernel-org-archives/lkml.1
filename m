Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbYF1POu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbYF1POu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 11:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbYF1POm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 11:14:42 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:14070 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752916AbYF1POl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 11:14:41 -0400
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
To: Alastair Bridgewater <nyef@lisphacker.com>
Subject: Re: [PATCH] input: Add support for eGalax TouchKit USB touchscreen used on HP tx1305us
Date: Sat, 28 Jun 2008 17:19:16 +0200
User-Agent: KMail/1.9.6
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806281719.16837.daniel.ritz-ml@swissonline.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi

> The eGalax touchscreen used in the HP tx1305us tablet PC (and presumably 
> the rest of the tx1000 series) uses a different format for events from 
> the device than the existing driver supports.
> 
is there more information available? datasheets? drivers?

> Add a new device description and interrupt packet handler for the 
> touchscreen used in the tx1305us, claiming the USB device ID for the 
> device that this patch was tested with from the older eGalax device code.
>
NAK. you cannot change device IDs currently used to some new code.
this will break most eGalax setups as the device ID 0x0eef,0x0001 is used
in most of them, including the one i have..

you'll need to find a way to distinguish the screens. as a starting point
i attached an lsusb -vvv output from my screen...

NAK-by: Daniel Ritz <daniel.ritz@gmx.ch>

rgds
-daniel

Bus 001 Device 002: ID 0eef:0001 D-WAV Scientific Co., Ltd eGalax TouchScreen
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x0eef D-WAV Scientific Co., Ltd
  idProduct          0x0001 eGalax TouchScreen
  bcdDevice            1.00
  iManufacturer           1 eGalax Inc.
  iProduct                5
  iSerial                 3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 USB TouchScreen
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
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               5
Device Status:     0x0002
  (Bus Powered)
  Remote Wakeup Enabled
