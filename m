Return-Path: <linux-kernel-owner+w=401wt.eu-S933161AbXEGLy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbXEGLy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 07:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933332AbXEGLy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 07:54:27 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:40151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933161AbXEGLy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 07:54:27 -0400
Subject: Re: [PATCH -mm] PM: Separate hibernation code from suspend code
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <1178538404.7261.16.camel@johannes.berg>
References: <200705041132.32227.rjw@sisk.pl>
	 <200705051421.31067.rjw@sisk.pl> <1178368028.7408.93.camel@johannes.berg>
	 <200705051550.53436.rjw@sisk.pl>  <1178538404.7261.16.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aqukPlzon0YNdafgnDNd"
Date: Mon, 07 May 2007 13:56:06 +0200
Message-Id: <1178538966.7261.18.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aqukPlzon0YNdafgnDNd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-05-07 at 13:46 +0200, Johannes Berg wrote:
> On Sat, 2007-05-05 at 15:50 +0200, Rafael J. Wysocki wrote:
>=20
> > @@ -60,6 +60,9 @@ void hibernation_set_ops(struct hibernat
> >  	}
> >  	mutex_lock(&pm_mutex);
> >  	hibernation_ops =3D ops;
> > +	if (ops)
> > +		hibernation_mode =3D HIBERNATION_PLATFORM;
>=20
> 	else if (hibernation_mode =3D=3D HIBERNATION_PLATFORM)
> 		hibernation_mode =3D HIBERNATION_SHUTDOWN;

Also, you could then simplify all the instances of
  (hibernation_mode =3D=3D HIBERNATION_PLATFORM && hibernation_ops)=20
to just
  (hibernation_mode =3D=3D HIBERNATION_PLATFORM)
in various if statements and other places.

johannes

--=-aqukPlzon0YNdafgnDNd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGPxPV/ETPhpq3jKURAqYuAJ4zUIK6qO4RS7oMx+9/bi1w5JY+agCZAfjV
N13l4CPvo96XvdtT52ko8rg=
=M0gf
-----END PGP SIGNATURE-----

--=-aqukPlzon0YNdafgnDNd--

