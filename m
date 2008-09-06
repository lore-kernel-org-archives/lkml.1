Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbYIFRsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbYIFRsH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYIFRrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:47:41 -0400
Received: from flock1.newmail.ru ([82.204.219.207]:59114 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752682AbYIFRrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:47:40 -0400
From: Andrey Borzenkov <arvidjaar@newmail.ru>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Ghost EDD devices in /sys again
Date: Sat, 6 Sep 2008 21:46:56 +0400
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200809052219.44093.arvidjaar@newmail.ru> <200809061240.25925.arvidjaar@newmail.ru> <48C28DE7.8030302@zytor.com>
In-Reply-To: <48C28DE7.8030302@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart58133737.03Y204liuA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809062147.01600.arvidjaar@newmail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart58133737.03Y204liuA
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 06 September 2008, H. Peter Anvin wrote:
>=20
> Andrey Borzenkov wrote:
> >=20
> > Was it really that simple?
> >=20
> > Subject: [PATCH] Fix ghost devices under /sys/firmware/edd
> > From: Andrey Borzenkov <arvidjaar@mail.ru>
> >=20
> > Some BIOSes do not always set CF on error before return from int13.
> > The patch adds additional check for status being zero (AH =3D=3D 0).
> >=20
>=20
> Do you have any evidence that there aren't any BIOSes which leave AH !=3D=
=20
> 0 on legitimate success?  If so, you have turned a nuisance bug into=20
> something that could cause install failures.
>=20

Hmm ... if install depends on having valid MBR, it will break right
now as well, because it will have duplicated signatures. So at least
something like following is needed.

diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
index d93cbc6..4c20d31 100644
=2D-- a/arch/x86/boot/edd.c
+++ b/arch/x86/boot/edd.c
@@ -58,6 +58,7 @@ static u32 read_mbr_sig(u8 devno, struct edd_info *ei, u3=
2 *mbrsig)
        if (mbrbuf_end > (char *)(size_t)boot_params.hdr.heap_end_ptr)
                return -1;

+       memset(mbrbuf_ptr, 0, sector_size);
        if (read_mbr(devno, mbrbuf_ptr))
                return -1;


--nextPart58133737.03Y204liuA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjCwhEACgkQR6LMutpd94wt/gCgz69+jvmYo2W7UEZi502OeKmw
U4wAnRVEeJJxeHvWAPaTuvU/ejzZIrO3
=AWYJ
-----END PGP SIGNATURE-----

--nextPart58133737.03Y204liuA--
