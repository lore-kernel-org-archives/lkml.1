Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbXLBRE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbXLBRE5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 12:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbXLBREs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 12:04:48 -0500
Received: from rtr.ca ([76.10.145.34]:1672 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbXLBREr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 12:04:47 -0500
Message-ID: <4752E5AD.40905@rtr.ca>
Date: Sun, 02 Dec 2007 12:04:45 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: dmitry.torokhov@gmail.com, rubini@vision.unipv.it,
       linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, jkosina@suse.cz,
       linux-usb@vger.kernel.org
Subject: REGRESSION: 2.6.24:  false double-clicks from USB mouse
References: <4752DB8C.50608@rtr.ca> <4752E432.10504@rtr.ca>
In-Reply-To: <4752E432.10504@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mark Lord wrote:
>> I've only just recently tried running 2.6.24 on my main machine.
>> And it appears that I'll have to go back to 2.6.23,
>> because the USB mouse is not working correctly.
>>
>> Single-clicking on things with 2.6.24 very frequently gives a 
>> "double-click".
>> This does not happen with 2.6.23.8.
>>
>> I wonder what broke it?
>>
>> I've grabbed mousedev.c from 2.6.23 and inserted that in place
>> of the updated 2.6.24 source, but no change.  So it's not that file.
> ...
> 
> Mmm.. reverting the entire drivers/hid directory to that from 2.6.23
> seems to have fixed the problem, so we now know it's in there somewhere.
> 
> Jiri: do you have any suggestions that might be more specific than that ?
..

Here's my USB mouse:


Bus 005 Device 004: ID 046d:c016 Logitech, Inc. M-UV69a Optical Wheel Mouse
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0xc016 M-UV69a Optical Wheel Mouse
  bcdDevice            3.40
  iManufacturer           1 Logitech
  iProduct                2 Optical USB Mouse
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
      bInterfaceClass         3 Human Interface Devices
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
          wDescriptorLength      52
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
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

