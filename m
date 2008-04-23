Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbYDWQnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbYDWQnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 12:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYDWQnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 12:43:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:53999 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751261AbYDWQnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 12:43:05 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/c6l1zuHXcvse3eK1h/MkClMIQgQs402jlHTr4tY
	cAQpHiItsBCfUZ
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Jan Kara <jack@suse.cz>
Subject: Re: ./fs/partitions/check.c: off-by-one error ?
Date: Wed, 23 Apr 2008 18:42:57 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200804201235.46552.toralf.foerster@gmx.de> <20080422103829.GC21922@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080422103829.GC21922@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2651143.rJFLyt0SpG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804231843.00379.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2651143.rJFLyt0SpG
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

At Tuesday 22 April 2008 12:38:29 Jan Kara wrote :
> =A0 This looks more like a strange interaction of your device size (it
> claims to have 3902463 sectors) and your partitioning programs which
> create partition ending at sector 3902464. Can you send the partition
> table you have on the device? E.g:
> =A0 fdisk /dev/sda
> =A0 x
> =A0 p
>=20
> =A0 will print detailed information about the partition table.
>=20

n22 ~ # fdisk /dev/sda

The number of cylinders for this disk is set to 1267.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
   (e.g., DOS FDISK, OS/2 FDISK)

Command (m for help): x

Expert command (m for help): p

Disk /dev/sda: 56 heads, 55 sectors, 1267 cylinders

Nr AF  Hd Sec  Cyl  Hd Sec  Cyl     Start      Size ID
 1 00   2   4    0  55  55  967        129    3902335 06
 2 00   0   0    0   0   0    0          0          0 00
 3 00   0   0    0   0   0    0          0          0 00
 4 00   0   0    0   0   0    0          0          0 00

Expert command (m for help): q

n22 ~ # fdisk -l /dev/sda

Disk /dev/sda: 1998 MB, 1998061056 bytes
56 heads, 55 sectors/track, 1267 cylinders
Units =3D cylinders of 3080 * 512 =3D 1576960 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1        1268     1951167+   6  FAT16

I deleted +created the partition both manually and by the digikam
but w/o success...

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart2651143.rJFLyt0SpG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkgPZxQACgkQhyrlCH22naPjnwCgklqded56TQE84o+7DeYYlllb
E1MAoMuLxVs4cNFDv6fouGboOrwYD34x
=UDnE
-----END PGP SIGNATURE-----

--nextPart2651143.rJFLyt0SpG--
