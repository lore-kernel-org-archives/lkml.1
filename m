Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbZCIVjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbZCIVjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 17:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZCIVjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 17:39:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:45877 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751569AbZCIVjW (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 17:39:22 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+H/+o2frSHMylqXvCjoBf2POAo4sR3vvwPp8IS/L
	3cqIkNJbRIwPr3
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [GIT PULL] Squashfs fixes for 2.6.29?
Date: Mon, 9 Mar 2009 22:39:12 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <49AF30EC.8010205@lougher.demon.co.uk>
In-Reply-To: <49AF30EC.8010205@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2860474.1YJVunDR7d";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903092239.13078.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2860474.1YJVunDR7d
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

On Donnerstag, 5. M=E4rz 2009, Phillip Lougher wrote:
> Hi Linus,
>=20
> Please consider pulling the following Squashfs fixes.  They fix some=20
> potential oopses when dealing with corrupted filesystems (plus a trivial=
=20
> documentation typo fix).
>=20
> Please pull from
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git
>=20
> Phillip Lougher (2):
>      Squashfs: Fix oops when reading fsfuzzer corrupted filesystems
[...]

This patch seems to break squashfs for me on i386 and amd64.=20

Test environment is a squashed filesystem image (live CD image, but also=20
tested manually with a loop mounted iso9660 and loop mounted squashfs;=20
kernel 2.6.29-rc7-git2). The squashfs image has been created with=20
squashfs-tools CVS[1] as of today (latest commit 2009-03-03).

# mkdir /tmp/pkg
# mount -o loop /var/cache/pyfll/sidux-snapshot-xfce-lite-i386-200903091945=
=2Eiso /mnt
# mount -t squashfs -o loop /mnt/sidux/sidux.686 /mnt/
# LANG=3D cp -a /mnt/ /tmp/pkg/
cp: reading `/mnt/lib/modules/2.6.28-7.slh.3-sidux-686/kernel/drivers/media=
/dvb/ttpci/dvb-ttpci.ko': Input/output error
cp: cannot stat `/mnt/lib/modules/2.6.29-rc7-sidux-686/kernel/drivers/hwmon=
': Input/output error
cp: cannot stat `/mnt/lib/modules/2.6.29-rc7-sidux-686/kernel/drivers/i2c':=
 Input/output error
cp: cannot stat `/mnt/lib/modules/2.6.29-rc7-sidux-686/kernel/drivers/infin=
iband': Input/output error
[...]

dmesg shows the following:

ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
squashfs: version 4.0 (2009/01/31) Phillip Lougher
SQUASHFS error: zlib_inflate tried to decompress too much data, expected 13=
1072 bytes.  Zlib data probably corrupt
SQUASHFS error: squashfs_read_data failed to read block 0xb7781f
SQUASHFS error: Unable to read data cache entry [b7781f]
SQUASHFS error: Unable to read page, block b7781f, size c7e5
SQUASHFS error: Unable to read data cache entry [b7781f]
SQUASHFS error: Unable to read page, block b7781f, size c7e5
SQUASHFS error: Unable to read data cache entry [b7781f]
SQUASHFS error: Unable to read page, block b7781f, size c7e5
SQUASHFS error: Unable to read data cache entry [b7781f]
SQUASHFS error: Unable to read page, block b7781f, size c7e5
SQUASHFS error: Unable to read data cache entry [b7781f]
SQUASHFS error: Unable to read page, block b7781f, size c7e5
SQUASHFS error: zlib_inflate tried to decompress too much data, expected 81=
92 bytes.  Zlib data probably corrupt
SQUASHFS error: squashfs_read_data failed to read block 0x17135aab
SQUASHFS error: Unable to read metadata cache entry [17135aab]
SQUASHFS error: Unable to read inode 0xc37f06f2
[...]

Reverting just this patch[2] results in flawless operations (I have the=20
same problems [and workaround, by reverting this patch] with the squashfs4=
=20
patches applied to 2.6.28.7, so that seems to rule out unrelated breakage).

Regards
	Stefan Lippers-Hollmann

[1]	cvs -d:pserver:anonymous@squashfs.cvs.sourceforge.net:/cvsroot/squashfs=
 login=20
	cvs -z3 -d:pserver:anonymous@squashfs.cvs.sourceforge.net:/cvsroot/squashf=
s co -P squashfs/squashfs-tools
[2]	From 118e1ef6fabfc023126e6075f6ac0fc729cb5285 Mon Sep 17 00:00:00 2001
	From: Phillip Lougher <phillip@lougher.demon.co.uk>
	Date: Thu, 5 Mar 2009 00:31:12 +0000
	Subject: [PATCH 16/17] Squashfs: Fix oops when reading fsfuzzer corrupted =
filesystems

--nextPart2860474.1YJVunDR7d
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm1jIEACgkQORbEMfgJlPaBQgCgqiRoLmNzINJQGjswIzU8z/sf
IsIAnicEgJGwA/Wz33Q/JugP0naSgPtM
=ITOe
-----END PGP SIGNATURE-----

--nextPart2860474.1YJVunDR7d--
