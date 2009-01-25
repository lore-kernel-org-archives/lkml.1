Return-Path: <linux-kernel-owner+w=401wt.eu-S1751925AbZAYWtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbZAYWtW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 17:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbZAYWtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 17:49:13 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:23351 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZAYWtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 17:49:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type;
        b=vxJSydERy6FFAheBFCuAYgp+0sRlEMWJnr0yWae0pfPJRJ8/Toj8BwWZ6T9Pq+fZxm
         saC5l/BkdmUlFsQk/PXbZCKU4NARYx88HUK4dI687bVjXjBQA/B7jxKstF6bwqrros0E
         NX08QW6I5p5tnRpHRRbp6JqDliLCiDhHb5LyE=
Date: Sun, 25 Jan 2009 23:49:02 +0100
From: Max Weninger <max.weninger@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: support of touchscreen reported as eGalax but is not working
Message-ID: <20090125234902.7605fd16@zork.foo.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/SRUGFThe/y6GkalBY/qH1ik";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SRUGFThe/y6GkalBY/qH1ik
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi

I recently got a used USB touchscreen and try to get it working
It looks like a eGalax type but not really is :-(

I am using kernel 2.6.28.2 but also tried the one that comes with
fedora 10 (2.6.27) When I connect the touchscreen dmesg shows

usb 2-1: new low speed USB device using uhci_hcd and address 13
usb 2-1: string descriptor 0 read error: -32
usb 2-1: string descriptor 0 read error: -32
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: string descriptor 0 read error: -32
generic-usb: probe of 0003:0EEF:0001.000B failed with error -32
usb 2-1: New USB device found, idVendor=3D0eef, idProduct=3D0001
usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0

lsusb -vv for the device gives

Bus 002 Device 013: ID 0eef:0001 D-WAV Scientific Co., Ltd eGalax
TouchScreen Device Descriptor:
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
  iManufacturer           1
  iProduct                2
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower               44mA
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
          bcdHID               1.12
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
        bInterval               5

/proc/bus/usb/devices gives

T:  Bus=3D02 Lev=3D01 Prnt=3D01 Port=3D00 Cnt=3D01 Dev#=3D 13 Spd=3D1.5 MxC=
h=3D 0
D:  Ver=3D 1.10 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D 8 #Cfgs=3D  1
P:  Vendor=3D0eef ProdID=3D0001 Rev=3D 1.00
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3Da0 MxPwr=3D 44mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D00 Prot=3D00 Driver=
=3Dusbhid
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   8 Ivl=3D5ms

I compared this output to other eGalax and discovered some differences
like that iManufactur and iProduct is not filled also
bInterfaceSubClass and bInterfaceProtocol

The kernel is not installing any input device for the touchscreen
so /proc/bus/input/devices does not show the touchscreen

To check if the thing is actually working I did a quick test on XP
and there it works.

Any chance to get this thing working?
I can test any patch maybe required and provide more information if
needed. If am wrong on this mailing list please tell me where
I should post this question.

Thanks for any help

Max

--Sig_/SRUGFThe/y6GkalBY/qH1ik
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkl87GEACgkQWFKBZOdSyBUAqgCeNlleR4GRUB9+V+ie1fEZD8ou
MKQAniBc25UioExLK7nVjiDw2VljHqF4
=+9vj
-----END PGP SIGNATURE-----

--Sig_/SRUGFThe/y6GkalBY/qH1ik--
