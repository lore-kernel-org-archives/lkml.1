Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZAZS1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZAZS1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 13:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbZAZS1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 13:27:13 -0500
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2494 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbZAZS1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 13:27:11 -0500
Date: Mon, 26 Jan 2009 19:27:07 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29rc1 breakes usb: hiddev device no longer available
Message-ID: <20090126182707.GI6158@vanheusden.com>
References: <20090126170130.GG6158@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126170130.GG6158@vanheusden.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sat Jan 24 21:33:23 CET 2009
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to
	me with PGP!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since version 2.6.29rc1 querying cleware USb devices no longer works.
> 2.6.28 works fine. 2.6.29-rc2 also no longer works.

This is the WORKING situation:
open("/dev/usb/hiddev0", O_RDWR)        = 3
ioctl(3, HIDIOCGDEVINFO, 0xbfa71a48)    = 0
ioctl(3, HIDIOCAPPLICATION, 0)          = -6291455
ioctl(3, HIDIOCGSTRING, 0x804e2c0)      = 7

the is the FAILURE situation (2.6.29-rc*):
open("/dev/usb/hiddev0", O_RDWR)        = 3
ioctl(3, HIDIOCGDEVINFO, 0xbf90c0d8)    = 0
ioctl(3, HIDIOCAPPLICATION, 0)          = -6291455
ioctl(3, HIDIOCGSTRING, 0x804e2c0)      = -1 ENODEV (No such device)

Bus 002 Device 003: ID 0d50:0008 Cleware GmbH 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x0d50 Cleware GmbH
  idProduct          0x0008 
  bcdDevice            0.17
  iManufacturer           1 Cleware GmbH
  iProduct                2 USB-Switch
  iSerial                 3 000175C
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
    MaxPower              120mA
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
          bcdHID               1.00
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      48
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
        bInterval              50
Device Status:     0x0000
  (Bus Powered)


Folkert van Heusden

-- 
To MultiTail einai ena polymorfiko ergaleio gia ta logfiles kai tin
eksodo twn entolwn. Prosferei: filtrarisma, xrwmatismo, sygxwneysi,
diaforetikes provoles. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
