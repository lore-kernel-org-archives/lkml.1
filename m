Return-Path: <linux-kernel-owner+w=401wt.eu-S932854AbXCKVxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbXCKVxM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 17:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932875AbXCKVxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 17:53:12 -0400
Received: from phpmyadmin.profiwh.com ([85.93.165.67]:36616 "EHLO
	cacti.profiwh.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932854AbXCKVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 17:53:10 -0400
Message-ID: <45F47A45.5080006@gmail.com>
Date: Sun, 11 Mar 2007 22:53:09 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>  <45E996A0.6070700@gmail.com> <45E99A45.9030506@gmail.com>  <20070303094125.838ce04d.akpm@linux-foundation.org>  <45F13791.8040408@gmail.com> <d120d5000703090613v2923e9c1k8389b566257daa43@mail.gmail.com> <Pine.LNX.4.64.0703091531280.26904@twin.jikos.cz> <Pine.LNX.4.64.0703091658350.26904@twin.jikos.cz> <45F4770F.4090902@gmail.com> <Pine.LNX.4.64.0703112243560.26904@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0703112243560.26904@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina napsal(a):
> On Sun, 11 Mar 2007, Jiri Slaby wrote:
> 
>>> -	/* make sure the unused bits in the last byte are zeros */
>>> -	if (count > 0 && size > 0)
>>> -		data[(offset+count*size-1)/8] = 0;
>>> -
>> No, this doesn't help -- -rc3-mm2 minus this behaves exactly the same. 
>> -rc3 without this patch too.
>> Going to try to revert the commits mentioned above.
> 
> Hmm, strange, I did bet that this would have solved the problem, as the 
> code is for sure bogus and could be causing these kinds of problems (I 

Hmm, so I'll check this out again to eliminate human factor.

> Otherwise, would you care to bisect?

Yup.

> What is the keyboard in question, please? (vendor/product ids).
Bus 002 Device 013: ID 0458:004c KYE Systems Corp. (Mouse Systems) Slimstar Pro 
Keyboard
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x0458 KYE Systems Corp. (Mouse Systems)
   idProduct          0x004c Slimstar Pro Keyboard
   bcdDevice            1.01
   iManufacturer           1 ABBHOME
   iProduct                2 USB Keyboard
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           59
     bNumInterfaces          2
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower               50mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Devices
       bInterfaceSubClass      1 Boot Interface Subclass
       bInterfaceProtocol      1 Keyboard
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.10
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength      65
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
         bInterval              10
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
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
           wDescriptorLength     104
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10





It has a hub inside, I think it's connected behind
Bus 002 Device 012: ID 04b4:2050 Cypress Semiconductor Corp.
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0         8
   idVendor           0x04b4 Cypress Semiconductor Corp.
   idProduct          0x2050
   bcdDevice            0.01
   iManufacturer           1 Bella Corporation
   iProduct                2 GBella Corporation DV Keyboard
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           25
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower              100mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval             255
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             3
   wHubCharacteristic 0x000d
     Per-port power switching
     Compound device
     Per-port overcurrent protection
   bPwrOn2PwrGood       50 * 2 milli seconds
   bHubContrCurrent     25 milli Ampere
   DeviceRemovable    0xc0
   PortPwrCtrlMask    0xe6
  Hub Port Status:
    Port 1: 0000.0103 power enable connect
    Port 2: 0000.0100 power
    Port 3: 0000.0100 power

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
