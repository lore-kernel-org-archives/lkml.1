Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZGITrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZGITrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 15:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZGITra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 15:47:30 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44958 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbZGITr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 15:47:29 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: tridge@samba.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Date: Thu, 9 Jul 2009 21:47:18 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29.6-tp42-toi-3.0.1-00977-gf7efeea; KDE/4.2.4; i686; ; )
Cc: Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
References: <19013.8005.541836.436991@samba.org> <200907081339.59815.Martin@lichtvoll.de> <19029.28240.995268.850038@samba.org> (sfid-20090709_113856_286413_EC1F4C70)
In-Reply-To: <19029.28240.995268.850038@samba.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2074799.f3HERdKTQ2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200907092147.26875.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2074799.f3HERdKTQ2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Donnerstag 09 Juli 2009 schrieb tridge@samba.org:
> Hi Martin,

Hi Tridge,

>  > The question before that would be whether anyone has a comprehensive
>  > list of those tools, cause I think there are quite many. Well at
>  > least those from bigger vendors should be tested I think. Paragon,
>  > Symantec, ...
>
> Do you happen to have any of those handy to test with?

There might be some stuff laying around on some magazine CD/DVDs, but=20
honestly I lack the motivation to do any testing. I am still not a fan of=20
your patch. And I think the people that are interested in getting the=20
patch in should do the testing - not me. Why should I do the work that=20
TomTom and other companies not willing or able to fight patents legally=20
might be interested in getting done? A motivation would be to think that=20
it actually helps towards a software patent free world, but I am not=20
convinced that it does.

>  > And has it been tested with Linux tools such as fsck.msdos,
>  > fsck.vfat, parted and partimage? I think it probably has not much
>  > effect on parted and partimage, but what about the fscks?
>
> I tested it with dosfstools (which provides the fsck.vfat on Linux
> distros) and with mtools. Both required patches to work correctly. I
> have submitted both patches to the maintainers of those packages.
>
> The patch to dosfstools makes it skip the invalid 8.3 entries, just as
> windows chkdsk does. The patch is here:
>
>   http://samba.org/tridge/dosfstools.patch1
>
> The patch to mtools is partly cosmetic, and partly to fix a bug in the
> VFAT checksum routine. The code in mtools incorrectly treated a nul
> byte as special in 8.3 directory entries. The patch is here:
>
>   http://samba.org/tridge/mtools.patch1

Okay. But then before activating the your Linux kernel patch as default=20
there should a transition time to let distro pick up the newest stuff and=20
a safety margin for users to upgrade to them. If it should be activated as=
=20
default at all.

>  > Thus even when the patch only changes the values stored for new - or
>  > rewritten? - files it actively corrupts the meta consistency of the
>  > whole filesystem. To me it is like inserting a defective inode into
>  > a consistent Linux filesystem.

> If the windows implementation is taken as the reference implementation
> then the files are not considered defective. The windows chkdsk will
> (with a small probability) complain of duplicates, but it doesn't
> complain about the entries being defective in any other way.

But you and others consider the characters / bytes your patch put into the=
=20
short names as invalid. How did you come to that conclusion? Either these=20
characters are invalid or they are not. An indication would be on what DOS=
=20
would allow me to create. Does it allow me to create files with those=20
characters such as blanks or null bytes with simple DOS commands. If not,=20
then not checking filenames in short name FAT for invalid names seems to=20
be an omission in CHKDSK for me.

Even when fsck.{ext3,whatever}/xfs_check/xfs_repair doesn't moan about "/"=
=20
in filenames I would still consider them invalid and think any software=20
which creates those actively corrupts an Ext3, XFS, whatever unix=20
filesystem.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2074799.f3HERdKTQ2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpWSUgACgkQmRvqrKWZhMfPUgCcClfn0PZyFPWiHAjguvL7gr6G
Xo8AniZopGDlibrx/S3NS+5gN+P/IhL4
=SSwp
-----END PGP SIGNATURE-----

--nextPart2074799.f3HERdKTQ2--
