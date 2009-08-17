Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbZHQH5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbZHQH5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZHQH5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:57:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:13575 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbZHQH47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ju3S9Fi5MSB9c6MHln6GtRlkUuLnC8BWvJ02AKXmBV4AmUtzaTAWb4lu3th65aHCpq
         18JkmmI/bCQMhsNc0WaxXyoxzQRNY15da/DxgDeuySU7Q9Ia4VWI2q51MjpwHyX2udxx
         tKyAPk9wEUxmTkZ5RLo+ELG64r7RD0l8LsLEY=
Date: Mon, 17 Aug 2009 11:00:23 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, andi@firstfloor.org, rpjday@crashcourse.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] VIDEO: console, use DIV_ROUND_UP
Message-ID: <20090817080023.GB2967@localdomain.by>
References: <20090817073147.GA2967@localdomain.by>
 <1250495293-13035-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <1250495293-13035-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/17/09 09:48), Jiri Slaby wrote:
> On 08/17/2009 09:31 AM, Sergey Senozhatsky wrote:
> > On (08/17/09 09:15), Jiri Slaby wrote:
> >> Not at all. I was writing about about (X + 7) / 8 [or >> 3] which is
> >> DIV_ROUND_UP(X, 8).
> >>
> > As far as I can understand:=20
> > DIV_ROUND_UP(61, 8):
> > (111101 + 111) >> 3 -> 1000 =3D=3D 8
> >=20
> > (int)(61/8) =3D=3D 7
>=20
> Yeah, that's why there is the ROUND_UP keyword in the macro.
>=20
> I mean this:
> --
> Use DIV_ROUND_UP explicitly instead of manual shifts and adds. It makes
> the code more readable and consistent (sometimes there were shifts,
> sometimes divs).
>=20
> There is no change on the assembly level (compilers should do the right
> job).
>=20
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/video/console/bitblit.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitb=
lit.c
> index 69864b1..6b7c8fb 100644
> --- a/drivers/video/console/bitblit.c
> +++ b/drivers/video/console/bitblit.c
> @@ -25,7 +25,7 @@ static inline void update_attr(u8 *dst, u8 *src, int at=
tribute,
>  			       struct vc_data *vc)
>  {
>  	int i, offset =3D (vc->vc_font.height < 10) ? 1 : 2;
> -	int width =3D (vc->vc_font.width + 7) >> 3;
> +	int width =3D DIV_ROUND_UP(vc->vc_font.width, 8);

So... In general, ((vc->vc_font.width + 7) >> 3) =3D=3D  DIV_ROUND_UP(vc->v=
c_font.width, 8) - 1;
That means:
unsigned int cellsize =3D vc->vc_font.height * width;  now is  unsigned int=
 cellsize =3D vc->vc_font.height * (width + 1);

Are you sure we really can use DIV_ROUND_UP?

	Sergey


--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqJDhcACgkQfKHnntdSXjQ0tAP/fjI8Fdlj35afuys9NxLR3H5M
UU0oFHQE0+v5CLu5h9MrPVa3P5KoCEaRQIolz8w9JDWq009SM+ZSyDPcMs1jYecn
3F7J+qwP1fcoTPWH9EDkguTy5qXCB7zM/eqDY7VSaPnv1+CYdMzJumfjqa8NC58O
M/hj30AqRvQZZA42ens=
=YDvX
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
