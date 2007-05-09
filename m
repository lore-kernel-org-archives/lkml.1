Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbXEIP5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbXEIP5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbXEIP5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:57:14 -0400
Received: from mx33.mail.ru ([194.67.23.194]:5577 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361AbXEIP5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:57:12 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Albert Cahalan" <acahalan@gmail.com>
Subject: Re: Long file names in VFAT broken with iocharset=utf8
Date: Wed, 9 May 2007 19:57:06 +0400
User-Agent: KMail/1.9.6
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org, hpa@zytor.com
References: <787b0d920705072143q63e56f23j18c6b0dbfb270883@mail.gmail.com> <Pine.LNX.4.61.0705081036000.17280@yvahk01.tjqt.qr> <787b0d920705090834p7ece0880n51d6e9288f307d1f@mail.gmail.com>
In-Reply-To: <787b0d920705090834p7ece0880n51d6e9288f307d1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1932048.ZuBCudOJiY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705091957.07557.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1932048.ZuBCudOJiY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 09 May 2007, Albert Cahalan wrote:
> On 5/8/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> > On May 8 2007 00:43, Albert Cahalan wrote:
> > > Fix: the vfat driver should use the 8.3 name for such files.
> >
> > Or the 31-character ISO Level 1(?).
>
> That might be appropriate for a similar problem on CD-ROM
> filesystems. (when the CD is rockridge KOI8 and you want UTF-8)
> It may even be appropriate for Joliet, though 8.3 may be
> the better choice in that case.
>
> It's not appropriate for vfat, HPFS, JFS, or NTFS. All of those
> have built-in support for 8.3 aliases. Normally the 8.3 names
> are like hidden hard links, except that deletion of either name
> will wipe out the other. (same as case differences too)
> So the names are there, and they should already work.
> They just need to be reported for directory listings when the
> long names would be too long.

several problems associated with it

1. those names are rather meaningless. How do you find out which file they=
=20
refer to? It is OK for trivial cases but not in a directory full of long=20
names; nor am I sure how many unique short names can be generated.

2. directory contents is effectively invalidated upon backup and restore (t=
ar=20
c; rm -rf; tar x). It is impossible to infer long names from short ones.

3. this still does not answer how can I *create* long name from within Linu=
x.

Currently workaround is to mount with single byte character set, like koi8-=
r;=20
of course it becomes quite awkward if the rest of system is using UTF-8.

--nextPart1932048.ZuBCudOJiY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGQe9TR6LMutpd94wRAjyUAKCa1SSuY2brfe4Ngt3lfDjSG/iIBACgyQb5
8vb4eMdk3mbGR+wgYxFU9UY=
=/cED
-----END PGP SIGNATURE-----

--nextPart1932048.ZuBCudOJiY--
