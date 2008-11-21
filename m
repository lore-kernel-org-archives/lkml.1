Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbYKUQCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbYKUQCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYKUQCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:02:35 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:53562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYKUQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:02:35 -0500
Subject: Re: [PATCH] IB/ehca: Fix lockdep failures for shca_list_lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>
In-Reply-To: <200811211637.15300.fenkes@de.ibm.com>
References: <200806061835.43802.fenkes@de.ibm.com>
	 <48499C11.7030504@gmail.com>  <200811211637.15300.fenkes@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lE2xKnnJ7qgNxVLjKvvc"
Date: Fri, 21 Nov 2008 17:02:27 +0100
Message-Id: <1227283347.3599.8.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lE2xKnnJ7qgNxVLjKvvc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-21 at 16:37 +0100, Joachim Fenkes wrote:

> +	u64 flags;

> -	spin_lock(&shca_list_lock);
> +	spin_lock_irqsave(&shca_list_lock, flags);

That's wrong and I think will give a warning on all machines where
u64 !=3D unsigned long. Might not particularly matter in this case.

Also, generally it seems wrong to say "fix lockdep failure" when the
patch really fixes a bug that lockdep happened to find.

johannes

--=-lE2xKnnJ7qgNxVLjKvvc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJtuOAAoJEKVg1VMiehFY3SgP+wQxUP8OH09UEvYbkTm3Wb82
r3LUyHaDNlla4X8D4/qlc7bKyam39YddIeT95GV7/pbZJ/rMV/ZoQSZWK963OqLN
Y27da78iwCeR5Hy+JosDkMskp8hQR6XG+GJB9U9GDwnOBNV7ah9tRBqxFkeT7ZtZ
pSgT+7I6Cpjuxd7J7JD2xRPwwtEeQi+yfHwCH0V5ihYe2fBmsDmh4ipjAr0CtB+W
85npS0K8NNmmUdjuN6DXs7yln6Aur1L1cBGbjG7tfCWRv6W/iC7e9AzuFIlqg6pw
LXRGOx482BU6y1oDSn5wSfmt2VxDu7Fm9p3Ql14gtIcIU1iy/v5JcxGlZAZZ7ETK
3MAchChmB0ElplTKpP1eW6Hah9Y6BgU2oTArlDohUPrScv7uW57YhYhi25sjU6ho
JlIfx6SAQVPP+S2wntAj2aHiuWgTLhSTAkbbwWJv/bi0+Nyy2k3aVUlqSf9LmXek
YGYdkHsp9PlfOCMRuS5o/yjZeWrayTfT54NWD5ZxLEd7Iblvz/DwNiioiY/KIGVQ
bJ6GGCgcN/w8LyMD8Bs+gnY19eYEMTWgO9b1JSpdihJFqOurRqrKz5j1dnRuXjwW
MXMjfdpcL084fNbBh4f+HjypcTfx7S43WnPiG6lSF08Z36uHeLd5gR16n6zrSmBK
DoSGG7IwJXMoIHCWJ2ru
=2bTj
-----END PGP SIGNATURE-----

--=-lE2xKnnJ7qgNxVLjKvvc--

