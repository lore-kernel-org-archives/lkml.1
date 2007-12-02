Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbXLBR6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbXLBR6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 12:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbXLBR6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 12:58:07 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43543 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbXLBR6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 12:58:05 -0500
Message-ID: <4752F226.1090003@garzik.org>
Date: Sun, 02 Dec 2007 12:57:58 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: dmitry.torokhov@gmail.com, rubini@vision.unipv.it,
       linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, jkosina@suse.cz,
       linux-usb@vger.kernel.org
Subject: Re: REGRESSION: 2.6.24:  false double-clicks from USB mouse
References: <4752DB8C.50608@rtr.ca> <4752E432.10504@rtr.ca> <4752E5AD.40905@rtr.ca>
In-Reply-To: <4752E5AD.40905@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mark Lord wrote:
>> Mark Lord wrote:
>>> I've only just recently tried running 2.6.24 on my main machine.
>>> And it appears that I'll have to go back to 2.6.23,
>>> because the USB mouse is not working correctly.
>>>
>>> Single-clicking on things with 2.6.24 very frequently gives a 
>>> "double-click".
>>> This does not happen with 2.6.23.8.
>>>
>>> I wonder what broke it?
>>>
>>> I've grabbed mousedev.c from 2.6.23 and inserted that in place
>>> of the updated 2.6.24 source, but no change.  So it's not that file.
>> ...
>>
>> Mmm.. reverting the entire drivers/hid directory to that from 2.6.23
>> seems to have fixed the problem, so we now know it's in there somewhere.
>>
>> Jiri: do you have any suggestions that might be more specific than that ?
> ..
> 
> Here's my USB mouse:
> 
> 
> Bus 005 Device 004: ID 046d:c016 Logitech, Inc. M-UV69a Optical Wheel Mouse
> Device Descriptor:
>  bLength                18
>  bDescriptorType         1
>  bcdUSB               2.00
>  bDeviceClass            0 (Defined at Interface level)
>  bDeviceSubClass         0
>  bDeviceProtocol         0
>  bMaxPacketSize0         8
>  idVendor           0x046d Logitech, Inc.
>  idProduct          0xc016 M-UV69a Optical Wheel Mouse
>  bcdDevice            3.40
>  iManufacturer           1 Logitech
>  iProduct                2 Optical USB Mouse
>  iSerial                 0
>  bNumConfigurations      1
>  Configuration Descriptor:
>    bLength                 9
>    bDescriptorType         2
>    wTotalLength           34
>    bNumInterfaces          1
>    bConfigurationValue     1
>    iConfiguration          0
>    bmAttributes         0xa0
>      (Bus Powered)
>      Remote Wakeup
>    MaxPower              100mA
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       0
>      bNumEndpoints           1
>      bInterfaceClass         3 Human Interface Devices
>      bInterfaceSubClass      1 Boot Interface Subclass
>      bInterfaceProtocol      2 Mouse
>      iInterface              0
>        HID Device Descriptor:
>          bLength                 9
>          bDescriptorType        33
>          bcdHID               1.10
>          bCountryCode            0 Not supported
>          bNumDescriptors         1
>          bDescriptorType        34 Report
>          wDescriptorLength      52
>         Report Descriptors:
>           ** UNAVAILABLE **
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x81  EP 1 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0004  1x 4 bytes
>        bInterval              10
> Device Status:     0x0000
>  (Bus Powered)
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

My USB mouse recently started giving me phantom scrolls (movements of 
the mouse wheel, even I made sure the wheel was in a resting position) 
in recently kernels.  It happened too infrequently for me to care.

Bus 001 Device 004: ID 045e:0047 Microsoft Corp. IntelliMouse Explorer 3.0

My USB keyboard also occasionally loses all contact with the number pad. 
  Other keys continue to work as expected.  Unplug/replug sometimes 
helps.  Reboot /always/ fixes the issue.

Bus 001 Device 005: ID 045e:000b Microsoft Corp. Natural Keyboard Elite

USB HID is a fun place to be.

Whee...

	Jeff


