Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbZK0RgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbZK0RgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 12:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZK0RgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 12:36:03 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50231 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZK0RgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 12:36:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Ffrovw5VALUWdwHw7lXjimeDbwGNEf4YtjttMACiAlIgStNqcymqjuCR2RiZ2u9v8l
         xjdj3Z4LUg1lhgcFDY2aVhEnd/LQwl1N6323O/CJlKsKewxLjacEPVdlpuooprsi+CoL
         NGDHKoLmvaeMAqTvD6XuNVGbGnIVA3lHKPeTw=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0911271308270.6953@wotan.suse.de>
References: <39840bc80911241957r38e6f26ah437f73fc890236c0@mail.gmail.com>
	 <alpine.LRH.2.00.0911271158560.3659@twin.jikos.cz>
	 <39840bc80911270403q83c16efy872cc1f72a0344ee@mail.gmail.com>
	 <alpine.LSU.2.00.0911271308270.6953@wotan.suse.de>
Date: Fri, 27 Nov 2009 19:36:06 +0200
X-Google-Sender-Auth: a613e83b2584e003
Message-ID: <39840bc80911270936n2cb568e6wd33a376ab59a6e62@mail.gmail.com>
Subject: Re: touchscreen wirh 2.6.26
From: Alex Custov <alex.custov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/27 Jiri Kosina <jkosina@suse.cz>:
> On Fri, 27 Nov 2009, Alex Custov wrote:
>
>> >> I have Acer T230H on Debian Lenny with 2.6.26.8 manually complied
>> >> kernel. The problem is that this is a multitouch monitor and it seems
>> >> that it doesn't work at all (even single touches). All things under
>> >> "Drivers => Input device support => Touchscreens" are enabled in kernel
>> >> (as modules). Is this type of monitor supported, or I should upgrade to
>> >> a newer kernel? Thanks.
>> >
>> > How is the touchscreen conntected to system? Is it USB? If so, what is the
>> > vendor and product ID? (lsusb will tell).
>>
>> Hi. Thanks for answer. I've already found the /dev device it has - it
>> is /dev/usb/hiddev0. Yes, it is USB connected. I did "cat
>> /dev/usb/hiddev0" and touched some points on the screen, it seems that
>> it works (I got some binary data from 'cat'). Now I will try to add
>> the corresponding section to the xorg.conf to let it work in X.
>
> It might not be that trivial -- /dev/usb/hiddev0 gives you only
> more-or-less raw HID data, but they have still to be interpreted somehow
> to make sense.
>
> If the device is implementing some vendor-specific (or device-specific)
> protocol, then the data you see coming through hiddev0 might not be useful
> at all directly in X.
>
> Repeating from my previous mail -- please provide the idVendor/idProduct
> (found by lsusb -v) for this device. It might be supported in later
> kernels, but without this information, it's impossible to tell.
>
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
>

Here you are:

Bus 004 Device 002: ID 0408:3000 Quanta Computer, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0408 Quanta Computer, Inc.
  idProduct          0x3000
  bcdDevice            0.00
  iManufacturer           1 Acer
  iProduct                2 T230H
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
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
          wDescriptorLength     210
         Report Descriptors:
           ** UNAVAILABLE **
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
Device Status:     0x0000
  (Bus Powered)

--
