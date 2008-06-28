Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbYF1STV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbYF1STV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 14:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYF1STO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 14:19:14 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:33222 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYF1STN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 14:19:13 -0400
Date: Sat, 28 Jun 2008 14:18:24 -0400
From: Alastair Bridgewater <nyef_sbcl@lisphacker.com>
Subject: Re: [PATCH] input: Add support for eGalax TouchKit USB touchscreen
 used on HP tx1305us
In-reply-to: <200806281757.48201.daniel.ritz-ml@swissonline.ch>
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Message-id: <48668070.3040902@lisphacker.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <200806281719.16837.daniel.ritz-ml@swissonline.ch>
 <200806281757.48201.daniel.ritz-ml@swissonline.ch>
User-Agent: Thunderbird 2.0.0.12 (X11/20080320)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Ritz wrote:
> On Saturday 28 June 2008 17:19:16 Daniel Ritz wrote:
>> hi
>>
>>> The eGalax touchscreen used in the HP tx1305us tablet PC (and presumably 
>>> the rest of the tx1000 series) uses a different format for events from 
>>> the device than the existing driver supports.
>>>
>> is there more information available? datasheets? drivers?
 >>
>>> Add a new device description and interrupt packet handler for the 
>>> touchscreen used in the tx1305us, claiming the USB device ID for the 
>>> device that this patch was tested with from the older eGalax device code.
>>>
>> NAK. you cannot change device IDs currently used to some new code.
>> this will break most eGalax setups as the device ID 0x0eef,0x0001 is used
>> in most of them, including the one i have..
>>
>> you'll need to find a way to distinguish the screens. as a starting point
>> i attached an lsusb -vvv output from my screen...
>>
> 
> reading the latest driver guide and programming guide from eGalax (now EETI btw.
> www.eeti.com.tw ) it turns out that the newer devices should support the HID
> format and report with that by default. those newer screens are handled by the
> 'usbhid' driver. have you tried loading that one before usbtouchscreen?

Okay, just built a kernel without the usbtouchscreen driver, and it 
recognized the touchscreen as belonging to the usbhid driver, and it 
works.  Didn't even have to change my X configuration.  Thank you.

> can you give an lsusb -vvv output?

Bus 001 Device 005: ID 0eef:0001 D-WAV Scientific Co., Ltd eGalax 
TouchScreen
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x0eef D-WAV Scientific Co., Ltd
   idProduct          0x0001 eGalax TouchScreen
   bcdDevice            1.00
   iManufacturer           1 eGalax INC.
   iProduct                2 USB TouchController
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           34
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          1 eGalax INC.
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
       bInterfaceClass         3 Human Interface Devices
       bInterfaceSubClass      1 Boot Interface Subclass
       bInterfaceProtocol      2 Mouse
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               2.10
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength     141
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
         bInterval               3
Device Status:     0x0002
   (Bus Powered)
   Remote Wakeup Enabled

> in case the usbhid driver does not work, it's possible to put the touchscreen
> into the non-HID operating mode and have to current code work again..it's easy
> to code...but please try usbhid first...

And usbhid works, so... what's the next step?

> rgds
> -daniel

-- Alastair Bridgewater
