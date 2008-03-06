Return-Path: <linux-kernel-owner+w=401wt.eu-S934759AbYCFOn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934759AbYCFOn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 09:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934564AbYCFOmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 09:42:49 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:11716 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934509AbYCFOmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 09:42:47 -0500
From: Ritesh Raj Sarraf <rrs@researchut.com>
Reply-To: Ritesh Raj Sarraf <rrs@researchut.com>
Organization: RESEARCHUT
To: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] Re: 2.6.24 Kernel Soft Lock Up with heavy I/O =?iso-8859-1?q?in=09dm-crypt?=
Date: Thu, 6 Mar 2008 20:11:38 +0530
User-Agent: KMail/1.9.9
Cc: device-mapper development <dm-devel@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, dm-crypt@saout.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Alasdair G Kergon <agk@redhat.com>,
       Christophe Saout <christophe@saout.de>
References: <200802281924.03996.rrs@researchut.com> <47C9AEF3.7040507@redhat.com> <47C9AF8F.2050502@redhat.com>
In-Reply-To: <47C9AF8F.2050502@redhat.com>
X-Face: L'e+W$sfUn_vK\|0It}WsAtt>E&abqUEWN>=?iso-8859-1?q?6=5F9w0jpkai8CP=3D=2ECDW=7DOkJ!rk!8*=5E7=2E=25*3=3BV=0A?=
 =?iso-8859-1?q?_FN=26rLp=2E=7DW?=)TyA|=}Sr'-B$|ZDu]w5(a|F>g}FqCv67uLfK6)\>T2N@?Ndx0b}=9k^*_;BAUbZ8BXLG
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3270476.Hljc4nDSfQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200803062011.45323.rrs@researchut.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3270476.Hljc4nDSfQ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I have a problem now.
I'm not able to reproduce the bug on an IBM xSeries box.

CPU: Dual Core 3.8 Ghz
RAM: 1 GB

The big difference in the configuration is that the laptop read data from a=
=20
USB HDD and copied it to another USB HDD (dm-crypted)
The IBM box reads it from an NFS share and copies it to the local hdd=20
(dm-crypted)

Ritesh


On Sunday 02 March 2008, Milan Broz wrote:
> (the same patch for 2.6.24)
>
> Milan
> --
> Add cond_resched() to prevent stuck in big bio processing.
>
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> ---
>  drivers/md/dm-crypt.c |    1 +
>  1 file changed, 1 insertion(+)
>
> Index: linux-2.6.24.3/drivers/md/dm-crypt.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.24.3.orig/drivers/md/dm-crypt.c	2008-02-26 01:20:20.0000000=
00
> +0100 +++ linux-2.6.24.3/drivers/md/dm-crypt.c	2008-03-01
> 16:46:24.000000000 +0100 @@ -374,6 +374,7 @@ static int
> crypt_convert(struct crypt_co
>  			break;
>
>  		ctx->sector++;
> +		cond_resched();
>  	}
>
>  	return r;



=2D-=20
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."

--nextPart3270476.Hljc4nDSfQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH0AKp4Rhi6gTxMLwRAgSRAJ9Qlkb+RLLiKsv5GaJkD1dqexTV+QCeO3dV
grXG/Ddd7DkMnzHEI8D/cP4=
=7S8l
-----END PGP SIGNATURE-----

--nextPart3270476.Hljc4nDSfQ--
