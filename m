Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbXIEHSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbXIEHSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 03:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbXIEHSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 03:18:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:63332 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbXIEHSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 03:18:13 -0400
Message-ID: <46DE5830.9060401@trausch.us>
Date: Wed, 05 Sep 2007 03:18:08 -0400
From: "Michael B. Trausch" <mike@trausch.us>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Belkin F5U002, usblp, uss720 issues
X-Enigmail-Version: 0.95.2
OpenPGP: id=19C59A30
Content-Type: multipart/signed; micalg=pgp-ripemd160;
 protocol="application/pgp-signature";
 boundary="------------enig6C494399F515FFA3F995136B"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6C494399F515FFA3F995136B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Long story short: I have a computer without a parallel port, and a
printer that requires one.  My computer has USB, so I bought a
USB->Parallel converter (a Belkin F5U002 Revision 2 wire).  After many
many hours of googling around and looking at everything I could find, I
am still having trouble.

I can do "cat /proc/cpuinfo > /dev/usblp0", and it will hang forever ---
or until I take the printer off-line and then put the printer back
on-line; additionally, it loses the first byte of the print job no
matter how it is submitted (including redirected directly to the printer
using the "cat" command above).  This is a standard, ASCII handling,
dot-matrix printer that is Epson compatible.

It worked perfectly with my previous computer, which had a parallel
port, so I know that this isn't an issue with the printer itself.

I have tried using the usblp driver (which the kernel tries to use by
default), which was a no go.  I then attempted to modify the usblp
driver by adding the following to the quirk_printers[] structure array,
to force the kernel to use unidirectional mode:

  { 0x050d, 0x0002, USBLP_QUIRK_BIDIR }, /* Belkin F5U002 */

The only result that had was to show this up repeatedly in the kernel's
ring buffer output by dmesg:

  drivers/usb/class/usblp.c: usblp0: error -115 writing to printer

=2E.. about once every 10 seconds.

So, my travels then led me to try using the uss720 driver to talk to the
printer.  However, this failed horribly; it wouldn't even talk.  Even
worse, I had to restart my system to get the thing back out of memory,
because once it was there, it wouldn't leave.  It left behind lots of
errors, too (I am only showing one of each; but there were 6,435 lines
of this stuff, cut down to 5 lines by sort and uniq):

  drivers/usb/misc/uss720.c: async_complete: urb error -104
  drivers/usb/misc/uss720.c: async_complete: urb error -32
  drivers/usb/misc/uss720.c: async_complete: urb error -62
  drivers/usb/misc/uss720.c: get_1284_register timeout
  drivers/usb/misc/uss720.c: get_1284_register: usb error -32

I am lost as to how to make this work.  The only thing that I can guess
is that the IEEE1284 controller inside of this thing is expecting some
different treatment than what it is getting from usblp or uss720.  What
it expects, I don't know.

So, I have a couple groups of questions:

  (1) Has anyone seen this problem, and maybe knows how to work around
      it?  If not, can I somehow provide the necessary information that
      would be necessary to fix this?  I would be happy to test
      anything with potential to get this going.
  (2) I (attempted to) read through usblp.c and friends and compare them
      with other systems that claim to drive this piece of hardware.
      However, that really got me nowhere.  For example, FreeBSD claims
      to support this controller/wire, but it doesn't even boot on my
      system, so I could not verify this.  (The kernel panics, so I
      don't even get the chance to try.)  If I can try to test this
      piece of hardware under a different operating system and it works,
      would that maybe provide enough information to get it going
      (again, it looks like) under Linux?

I hope that I have provided enough information; if not please feel free
to ask.  I have also included the relevant section of the output of
lsusb -vvv below the signature block.

	Thanks in advance,
	Mike

--=20
Michael B. Trausch               Internet Mail & Jabber: mike@trausch.us
Phone:  (404) 592-5746 x1                         http://www.trausch.us/
Mobile: (678) 522-7934             VoIP: 6453@sip.trausch.us, 861384@fwd
Pidgin 2.1.1 and plugins for Ubuntu Feisty! http://www.trausch.us/pidgin

---- begin snipped output of sudo lsusb -vvv
Bus 002 Device 002: ID 050d:0002 Belkin Components
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x050d Belkin Components
  idProduct          0x0002
  bcdDevice            2.02
  iManufacturer           1 Belk USB Printing Support
  iProduct                2 IEEE-1284 Controller
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           78
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
      bInterfaceClass         7 Printer
      bInterfaceSubClass      1 Printer
      bInterfaceProtocol      1 Unidirectional
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass         7 Printer
      bInterfaceSubClass      1 Printer
      bInterfaceProtocol      2 Bidirectional
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       2
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval               1
Device Status:     0x0000
  (Bus Powered)
---- end snipped output of sudo lsusb -vvv


--------------enig6C494399F515FFA3F995136B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG3lgy0kE/IBnFmjARA5+kAJ9F21wmfEhyhzmdGE9JzfoBI0zSJgCfX1AF
zYQncVGOGIdw9Y5cjZMQ28s=
=md7Q
-----END PGP SIGNATURE-----

--------------enig6C494399F515FFA3F995136B--
