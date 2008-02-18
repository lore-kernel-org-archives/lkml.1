Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbYBRA6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbYBRA6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 19:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbYBRA6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 19:58:05 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42841 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755521AbYBRA6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 19:58:03 -0500
X-Sasl-enc: jMw730nOdR6rpyqXdytunhh3LY86So498xDJpwGgaB05 1203296281
Message-ID: <47B8D80C.8000408@imap.cc>
Date: Mon, 18 Feb 2008 01:57:48 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc2 regression: LVM cannot find volume group
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>	<47B73616.9050303@imap.cc> <20080216201206.1452cfe7@core> <47B765B1.1030709@gmail.com>
In-Reply-To: <47B765B1.1030709@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB601C9E6DD00B1C2D2C7AD1B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB601C9E6DD00B1C2D2C7AD1B
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 16.02.2008 23:37 schrieb Jiri Slaby:
> On 02/16/2008 09:12 PM, Alan Cox wrote:
>> On Sat, 16 Feb 2008 20:14:30 +0100
>> Tilman Schmidt <tilman@imap.cc> wrote:
>>
>>> 2.6.25-rc2 fails to bring up my openSUSE 10.3 PC because LVM
>>> cannot find the volume group containing the root file system.
>>> 2.6.25-rc1 has the same problem, 2.6.24 works fine.

Bisection says:

edfaa7c36574f1bf09c65ad602412db9da5f96bf is first bad commit
commit edfaa7c36574f1bf09c65ad602412db9da5f96bf
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Mon May 21 22:08:01 2007 +0200

     Driver core: convert block from raw kobjects to core devices

     This moves the block devices to /sys/class/block. It will create a
     flat list of all block devices, with the disks and partitions in one=

     directory. For compatibility /sys/block is created and contains syml=
inks
     to the disks.

Apparently, compatibility is in the eye of the beholder - in this
case, LVM.

>> Compile in SCSI disk support. Modular even if loaded in initrd it seem=
s
>> to have broken somewhere.

Setting

CONFIG_SCSI=3Dy
CONFIG_BLK_DEV_SD=3Dy

does not help. The problem persists.

> # CONFIG_SYSFS_DEPRECATED is not set
>=20
> I would suspect this.

Setting

CONFIG_SYSFS_DEPRECATED=3Dy

does indeed fix the problem and allows me to boot successfully.
Pity, I was so happy getting rid of that a couple of releases ago.

> Try to upgrade to at least lvm 2.02.29 (I guess this is the first versi=
on which=20
> understands the new sysfs layout).

I'll have to investigate how to do that without breaking anything.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigB601C9E6DD00B1C2D2C7AD1B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHuNgWMdB4Whm86/kRAv3SAJ94UcEXsZqgJcTDuVFSXLrTQ9CpXQCfSnOT
DDIYjyEksnpc2b+dA5ohmcI=
=O+9n
-----END PGP SIGNATURE-----

--------------enigB601C9E6DD00B1C2D2C7AD1B--
