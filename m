Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbZAVTZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbZAVTZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbZAVTZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:25:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:30272 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbZAVTZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:25:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=fze8gtTe9l/f4eB/ZoRWrfWZn3/gkoFlrDg6AVVEOMlDBpqQTTF+1m81Igu7O4M87D
         tv+0/5Aigl2uptdv0KyIO02yn9fK0dgpm9P9GPdkNTfXXHsxWy3QmjihXNiXFgI0KHTs
         7PgQFS5Za9dV+0NMh22boHQCvgSUSxmSNWadg=
Message-ID: <4978C812.90702@gmail.com>
Date: Thu, 22 Jan 2009 20:25:06 +0100
From: Sandro Bonazzola <sandro.bonazzola@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in wb35_probe()
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI> <20090122114237.GA13845@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20090122114237.GA13845@atrey.karlin.mff.cuni.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pavel Machek ha scritto:
>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>> If successful, the usb_control_msg() function returns the number of
>> bytes transferred. Fix up wb35_probe() to only bail out if the function
>> returns a negative number.
>>
>> Reported-by: Sandro Bonazzola <sandro.bonazzola@gmail.com>
>> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Acked-by: Pavel Machek <pavel@suse.cz>

Ok, tested. Here is the result:

# uname -a
Linux arilinn 2.6.29-rc2-00013-gf3b8436-dirty #1 Thu Jan 22 19:39:23 CET 2009
x86_64 AMD Athlon(tm) 64 Processor 3500+ AuthenticAMD GNU/Linux

Inserting the USB device:
# dmesg
usb 1-3: new high speed USB device using ehci_hcd and address 4
usb 1-3: New USB device found, idVendor=18e8, idProduct=6201
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-3: Product: Usb2Wlan
usb 1-3: Manufacturer: WINBOND
usb 1-3: SerialNumber: 101d350112
usb 1-3: configuration #1 chosen from 1 choice
w35und: module is from the staging directory, the quality is unknown, you have
been warned.
wmaster0 (usb): not using net_device_ops yet
phy0: Selected rate control algorithm 'minstrel'
usbcore: registered new interface driver w35und

#  iwlist wlan0 scan
wlan0     Interface doesn't support scanning.

#  iwlist wmaster0 scan
wmaster0  Interface doesn't support scanning.

# ifconfig wlan0 10.0.4.1
SIOCSIFADDR: No such device
wlan0: ERROR while getting interface flags: No such device

# ifconfig wmaster0 10.0.4.1
SIOCSIFFLAGS: Operation not supported

# lsusb
Bus 002 Device 003: ID 045e:00f5 Microsoft Corp. LifeCam VX-3000
Bus 002 Device 002: ID 046d:c505 Logitech, Inc. Cordless Mouse+Keyboard Receiver
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 004: ID 18e8:6201 Qcom
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

#  lsusb -v -s 001:004

Bus 001 Device 004: ID 18e8:6201 Qcom
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x18e8 Qcom
  idProduct          0x6201
  bcdDevice           87.65
  iManufacturer           1 WINBOND
  iProduct                2 Usb2Wlan
  iSerial                 3 101d350112
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           49
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
      bNumEndpoints           4
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      ** UNRECOGNIZED:  03 08 3f
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkl4yBEACgkQV871CybFezntuQCguBg2n5aFYv0MQ1+P5bRcNw4Q
LosAnRwszYu076vzA2PglXC6Pub0ofvs
=zuIX
-----END PGP SIGNATURE-----
