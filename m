Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbYKXIxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbYKXIxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 03:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYKXIw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 03:52:59 -0500
Received: from sd-green-bigip-83.dreamhost.com ([208.97.132.83]:44428 "EHLO
	spunkymail-a10.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751506AbYKXIw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 03:52:58 -0500
From: Yuval Hager <yuval@avramzon.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: BCM4312 Fails when xdm is started
Date: Mon, 24 Nov 2008 10:49:38 +0200
User-Agent: KMail/1.9.9
Cc: Michael Buesch <mb@bu3sch.de>, LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de
References: <200811151801.02369.yuval@avramzon.net> <20081123204631.21061.qmail@stuge.se> <4929C68E.6080401@lwfinger.net>
In-Reply-To: <4929C68E.6080401@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4121756.b8sE6cYxkZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811241049.45734.yuval@avramzon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4121756.b8sE6cYxkZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 23 November 2008, Larry Finger wrote:
> From a config file posted earlier, the OP is using SLAB. Is there any poi=
nt
> in trying SLUB?

Another try, not sure what it means:

* Added CONFIG_SLUB and CONFIG_SLUB_DEBUG

* boot parameters: root=3D/dev/sda3 debug memory_corruption_check=3D1 devre=
s.log=3D1 debug_objects debugpat=20
acpi.debug_layer=3D0x00410002 acpi.debug_level=3D0xffffffff acpi=3Doff apic=
=3Ddebug nolapic irqpoll pci=3Dnoacpi slub_debug=3DFZPU

* cat /proc/interrupts is
           CPU0      =20
  0:      16658    XT-PIC-XT        timer
  1:        289    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  3:         60    XT-PIC-XT        uhci_hcd:usb2, ehci_hcd:usb4
  5:       9163    XT-PIC-XT        sata_via, HDA Intel
  7:          0    XT-PIC-XT        uhci_hcd:usb3
  8:          2    XT-PIC-XT        rtc
 10:       1712    XT-PIC-XT        b43
 11:        131    XT-PIC-XT        uhci_hcd:usb1
 12:        706    XT-PIC-XT        i8042
 14:          0    XT-PIC-XT        ide0
 15:          0    XT-PIC-XT        ide1
NMI:          0   Non-maskable interrupts
LOC:          0   Local timer interrupts
RES:          0   Rescheduling interrupts
CAL:          0   Function call interrupts
TLB:          0   TLB shootdowns
TRM:          0   Thermal event interrupts
SPU:          0   Spurious interrupts
ERR:          0
MIS:          0

* lspci -d 14e4:4312 -x
02:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g (rev 0=
2)
00: e4 14 12 43 06 01 10 00 02 00 80 02 08 00 00 00
10: 04 c0 ff fd 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 71 13
30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 01 00 00

* xset dpms force standby
* wake up
* dmesg is virtually the same as before, complaining about nobody handling =
irq 10 and disabling it.
* /proc/interrupts now is
  0:      80987    XT-PIC-XT        timer
  1:       1027    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  3:         60    XT-PIC-XT        uhci_hcd:usb2, ehci_hcd:usb4
  5:      10400    XT-PIC-XT        sata_via, HDA Intel
  7:          0    XT-PIC-XT        uhci_hcd:usb3
  8:          2    XT-PIC-XT        rtc
 10:     200000    XT-PIC-XT        b43
 11:        131    XT-PIC-XT        uhci_hcd:usb1
 12:       3059    XT-PIC-XT        i8042
 14:          0    XT-PIC-XT        ide0
 15:          0    XT-PIC-XT        ide1
NMI:          0   Non-maskable interrupts
LOC:          0   Local timer interrupts
RES:          0   Rescheduling interrupts
CAL:          0   Function call interrupts
TLB:          0   TLB shootdowns
TRM:          0   Thermal event interrupts
SPU:          0   Spurious interrupts
ERR:          0
MIS:          0

* Now check this out - the output of lspci -d 14e4:4312 -x
02:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g (rev f=
f)
00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

(I double checked this)

huh?

=2D-yuval

--nextPart4121756.b8sE6cYxkZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkqaqkACgkQl7qmwPqEj9+KSgCcDDvJdZJG6I9bqeOZ+6wsx+Fh
1cUAniIl+yKJFmDIi/FRrfc+jUxZ/bgh
=95vG
-----END PGP SIGNATURE-----

--nextPart4121756.b8sE6cYxkZ--
