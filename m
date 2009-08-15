Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbZHOOJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbZHOOJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 10:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbZHOOJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 10:09:35 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:48854 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbZHOOJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 10:09:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X2ymLxLPkgj/Vlniy/0wW4quzdtLqWLOr5hZDQM6g6q7ub79dWDkK8m/H8AIOQ8wo0
         oZgxog917CemiCMjJSXa6fMYtHytcuKuJ0mZG9oeEEqsbGsJl5k3yPj7JUif71Ax9MgK
         LEVZ9Fdcq+ItI8S6i3o+50gc53KyXDGpE2vG8=
Date: Sat, 15 Aug 2009 17:12:12 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make shr to divide by power of 2 (resend)
Message-ID: <20090815141212.GA7692@localdomain.by>
References: <20090815134312.GA7533@localdomain.by>
 <4A86BC96.9040702@gmail.com>
 <alpine.LFD.2.00.0908150947260.14440@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908150947260.14440@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/15/09 09:49), Robert P. J. Day wrote:
> Date: Sat, 15 Aug 2009 09:49:15 -0400 (EDT)
> From: "Robert P. J. Day" <rpjday@crashcourse.ca>
> To: Jiri Slaby <jirislaby@gmail.com>
> cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
> 	Andrew Morton <akpm@linux-foundation.org>,
> 	linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Make shr to divide by power of 2 (resend)
> User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
>=20
> On Sat, 15 Aug 2009, Jiri Slaby wrote:
>=20
> > On 08/15/2009 03:43 PM, Sergey Senozhatsky wrote:
> > > Make an arithmetic right shift to divide by power of 2.
> >
> > Why? Is out there a compiler not doing that?
> >
> > Seems like it should be rather converted to DIV_ROUND_UP.
> >

                                =20
It was duscussed, so I'll just copy paste my answer.
On (08/08/09 09:35), Andi Kleen wrote:
> DIV should be always slower than a SHIFT.
>
> But it has nothing really to do with the CPU. The point is that the compi=
ler
> always selects a suitable one by itself. Rewriting x / 2 to x >> 1 is
> one of the easiest exercises in compiler optimizations.
>
> The only case when the compiler cannot do this easily by itself is
> when the dividend is not a constant.
>

        int width =3D (vc->vc_font.width + 7) >> 3;

> That said -Os sometimes screws us up on this, but it's still not worth
> doing this change manually.
>

My point is that it should 'look the same'.
I mean there are 5
        int width =3D (vc->vc_font.width + 7) >> 3;
*not exactly this one, but vc->vc_font.width (+ 7)? >> 3

and _only_ one
        int width =3D (vc->vc_font.width + 7) / 8;


>   it does seem like a DIV_ROUND_UP would be better but perhaps another
> solution would be to define a meaningful macro name for that
> operation.  if that conversion is going to be done regularly, a macro
> with an informative name might be in order.  if it's a one-shot
> operation, though, not much point.
>=20

No, it's not a one-shot.

grep -c '>>' bitblit.c
7

	Sergey
--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqGwjwACgkQfKHnntdSXjSnNwQAhJpOqMkaZe7BVP7/UuJCPMhx
L2rnNSDZieuulxyk/85mPRm+Xa9+9u6OwMK7AEctlnRHWPyKQNHewuuw4izePyB6
vseBrWUzwMKhYYdq7pYNqtS49uSfVOmlkyY5DUjlJwJp8ohTfAhMrcNYjhy1bDIk
k/jVyYYPHQjL7Thod9c=
=UWXB
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
