Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbZHQH2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbZHQH2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZHQH2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:28:33 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:30875 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZHQH2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EU/4slDVwzhO3kHt0lUFbWq7ZGpaYNN2ZCF7BQACJ0barUkN1Y3UibOFWX+f9sY+S8
         pYMHtSF1wmFw6L9gpt4VJbYg82xgm1qWhbMVd5rjllvllqFFd3k8uxym1FZqZZc03pSr
         28zoJd/HW1cd2geY/HcIPWa2izMySLVnrRjpM=
Date: Mon, 17 Aug 2009 10:31:47 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make shr to divide by power of 2 (resend)
Message-ID: <20090817073147.GA2967@localdomain.by>
References: <20090815134312.GA7533@localdomain.by>
 <4A86BC96.9040702@gmail.com>
 <alpine.LFD.2.00.0908150947260.14440@localhost>
 <20090815141212.GA7692@localdomain.by>
 <4A871DAF.10609@gmail.com>
 <20090816091425.GB7968@localdomain.by>
 <4A890388.8070709@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <4A890388.8070709@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/17/09 09:15), Jiri Slaby wrote:
> On 08/16/2009 11:14 AM, Sergey Senozhatsky wrote:
> > There are different shr/shl operations in bitblit.c. Like,
> > #1
> > cur_height =3D vc->vc_font.height >> 1
> > cur_height =3D (vc->vc_font.height << 1)/3;
> > c |=3D c >> 1;
> > u32 idx =3D vc->vc_font.width >> 3;
> > etc.
> >=20
> > So, should I convert it to something like:
>=20
> Not at all. I was writing about about (X + 7) / 8 [or >> 3] which is
> DIV_ROUND_UP(X, 8).
>=20
As far as I can understand:=20
DIV_ROUND_UP(61, 8):
(111101 + 111) >> 3 -> 1000 =3D=3D 8

(int)(61/8) =3D=3D 7

So, we need not DIV_ROUND_UP but (let it be) DIV_SHR (a,b) (a) >> (b);
In that case cur_height =3D vc->vc_font.height >> 2 should be cur_height =
=3D DIV_SHR(vc->vc_font.height, 1).
And this is kind of obfuscation I think.

> > #2
> > cur_height =3D DIV_XXX(vc->vc_font.height, 2)
> > cur_height =3D DIV_XXX( MUL_XXX(vc->vc_font.height, 2), 3); or cur_heig=
ht =3D DIV_XXX( (vc->vc_font.height * 2), 3);
> > c |=3D DIV_XXX(c, 1);
> > u32 idx =3D DIV_XXX(vc->vc_font.width, 8);
> >=20
> > #1 is better-looking I think.
>=20
> Agreed. I would write it without shifts though. But we were talking
> about the roundup case not about the shifts all over the code.
>=20

	Sergey
--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqJB2MACgkQfKHnntdSXjThNAQAwFKB6eefXlMlUavml7w8w/JV
OHS2SyB0+xJGwmk+ssSVdp3c1vTGhfyq1dvGiTMcglry9vB2vNIpxzO0hU6JFIMr
/k+xsuT3Wq5R9H6W99cq3pplMZ/olL+mF2E4Pl9VQfptjpB+VaxlfuVNWtb1HI6f
7iQkRZbZ62YmE1FRI3k=
=iS51
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
