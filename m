Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbXEIK1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbXEIK1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbXEIK1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:27:15 -0400
Received: from mx33.mail.ru ([194.67.23.194]:14649 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbXEIK1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:27:13 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
Subject: Re: Long file names in VFAT broken with iocharset=utf8
Date: Wed, 9 May 2007 14:27:04 +0400
User-Agent: KMail/1.9.6
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org
References: <200705072151.20104.arvidjaar@mail.ru> <87fy685w0m.fsf@duaron.myhome.or.jp> <BD281C0E-5278-4944-ABF0-AF692325945C@e18.physik.tu-muenchen.de>
In-Reply-To: <BD281C0E-5278-4944-ABF0-AF692325945C@e18.physik.tu-muenchen.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1651649.FqxuWtoWYm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705091427.04903.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1651649.FqxuWtoWYm
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 07 May 2007, Roland Kuhn wrote:
> Hi!
>
> On 7 May 2007, at 20:27, OGAWA Hirofumi wrote:
> > Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de> writes:
> >> PATH_MAX specifically counts _bytes_ not characters, so UTF-8 does
> >> not matter. ISTR that PATH_MAX was 256 at some point, but I just
> >> quickly grepped /usr/include and found various mention of 4096, so
> >> where's the central repository for this configuration item? A hard-
> >> coded value of 256 somewhere inside the kernel smells like a bug.
> >
> > There is a nasty issue here. FAT is limited by 255 unicode chars or
> > so.
> > So, we would need to count number of unicode chars of filename.
>
> No, we don't. At least not when looking at the POSIX spec, which
> explicitly mentions _bytes_ and _not_ unicode characters. So, to be
> on the safe side, FAT filesystems would need to support a NAME_MAX of
> roughly 6*255+3=3D1533 bytes (not to mention the hassles of forbidden
> sequences, etc.; do we need to count zero-width characters?)

How is this issue related to character *width* at all?

> and=20
> report it through pathconf() to userspace, then userspace could do
> with that whatever it liked.
>
> What happened to: "file names are just sequences of octets, excluding
> '/' and NUL"? Adding unicode parsing to the kernel is completely
> useless _and_ a big trouble maker.
>

Who speaks about unicode parsing? UCS2 - UTF-8 transformation does and=20
requires no parsing; this is simply conversion between on-disk and in-kerne=
l=20
representation (like endian conversion). Anyway we are doing it now already=
;=20
how support for larger name length limit changes it?

=2Dandrey

--nextPart1651649.FqxuWtoWYm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGQaH4R6LMutpd94wRAnrkAJsGnaNBBukQuUv6CVTruWAg9BPnIgCgw7av
HLJ2Luls7wXfSAhBZpP77JI=
=LOZh
-----END PGP SIGNATURE-----

--nextPart1651649.FqxuWtoWYm--
