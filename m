Return-Path: <linux-kernel-owner+w=401wt.eu-S1765639AbXGWW12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765639AbXGWW12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbXGWW1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:27:21 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:46868 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbXGWW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:27:20 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] [PATCH 0/5] Dynamically allocated pageflags.
Date: Tue, 24 Jul 2007 08:27:18 +1000
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200707232305.12364.nigel@nigel.suspend2.net> <200707240005.22163.rjw@sisk.pl>
In-Reply-To: <200707240005.22163.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart29634502.tsWM2WXE1A";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707240827.18807.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart29634502.tsWM2WXE1A
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Tuesday 24 July 2007 08:05:21 Rafael J. Wysocki wrote:
> Hi,
>=20
> On Monday, 23 July 2007 15:05, Nigel Cunningham wrote:
> > Hi all.
> >=20
> > As we all know, pageflags have been a scarce resource for a while now.=
=20
These=20
> > patches seek to help address that issue by adding support for a new typ=
e=20
> > of 'dynamically allocated' pageflag.
> >=20
> > The basic idea is that we use per node & zone bitmaps built out of orde=
r=20
zero=20
> > allocations, to replace bits in page->flags. Bitmaps can be sparse, bei=
ng=20
> > populated when a bit on the page is set, and returning zero for all bit=
s=20
in=20
> > sparse pages. Untested hotplug support is included.
> >=20
> > This method of storing the data does of course come with a performance=
=20
hit.=20
> > I've included some simple timing loops in #ifdef'd code that help quant=
ify=20
> > that.
> >=20
> > Interestingly, the new implementation is actually quicker under some=20
> > circumstances. In cases where the usage pattern involves operating on t=
he=20
> > flags for a number of pages in succession, the hit involved in getting =
the=20
> > struct pages from main memory appears to be greater than that involved =
in=20
> > calculating which unsigned long and bit to test.
> >=20
> > Tested only on UP (x86_64) so far.
>=20
> How does it compare to the memory bitmaps used by swsusp, defined in
> kernel/power/snapshot.c?

Looking through kernel/power/snapshot.c, I'd say this implementation has=20
advantages in having support for memory hotplugging, sparseness and random=
=20
access to the flags in the bitmap. Like the snapshot.c implementation, it=20
uses per-zone bitmaps and has a method that can be used to iterate over the=
=20
contents of a bitmap. Having per-node support might also be useful. I haven=
't=20
looked at the speed of the snapshot.c implementation. Do you see advantages=
=20
to snapshot.c that I might have missed?

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart29634502.tsWM2WXE1A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGpStGN0y+n1M3mo0RAjSZAKCD8vH1GrnhHWSBdG+A1xFXxGk7xwCeN/gc
xYroEHu9/LoCy15zEax3d8U=
=J8HK
-----END PGP SIGNATURE-----

--nextPart29634502.tsWM2WXE1A--
