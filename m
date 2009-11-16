Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZKPOCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZKPOCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbZKPOCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:02:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43297 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZKPOCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:02:38 -0500
Date: Mon, 16 Nov 2009 15:02:35 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] checkpatch: fix false positive on __initconst
Message-ID: <20091116140220.GC30609@pengutronix.de>
References: <1255945754-2160-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TybLhxa8M7aNoW+V"
Content-Disposition: inline
In-Reply-To: <1255945754-2160-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TybLhxa8M7aNoW+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ping

On Mon, Oct 19, 2009 at 11:49:14AM +0200, Wolfram Sang wrote:
> checkpatch falsely complained about '__initconst' because it thought the
> 'const' needed a space before. Fix this by changing the list of attribute=
s:
>=20
> - add '__initconst'
> - force plain 'init' to contain a word-boundary at the end
>=20
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Andy Whitcroft <apw@shadowen.org>
> ---
>=20
> Not entirely sure if adding the word boundary may cause a side-effect whi=
ch I
> overlooked. A few more eyes on this would be great.
>=20
>  scripts/checkpatch.pl |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>=20
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 87bbb8b..0a47a1f 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -142,11 +142,14 @@ our $Sparse	=3D qr{
>  			__kprobes|
>  			__ref
>  		}x;
> +
> +# Notes to $Attribute:
> +# We need \b after 'init' otherwise 'initconst' will cause a false posit=
ive in a check
>  our $Attribute	=3D qr{
>  			const|
>  			__read_mostly|
>  			__kprobes|
> -			__(?:mem|cpu|dev|)(?:initdata|init)|
> +			__(?:mem|cpu|dev|)(?:initdata|initconst|init\b)|
>  			____cacheline_aligned|
>  			____cacheline_aligned_in_smp|
>  			____cacheline_internodealigned_in_smp|
> --=20
> 1.6.3.3
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--TybLhxa8M7aNoW+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksBW3sACgkQD27XaX1/VRuIkACeNAGnPkpy112s//VOX0dvzsKt
fBIAnRHTnjZE0IKSNuOTivCQoytNJlJZ
=f5eC
-----END PGP SIGNATURE-----

--TybLhxa8M7aNoW+V--
