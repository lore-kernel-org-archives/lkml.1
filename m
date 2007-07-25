Return-Path: <linux-kernel-owner+w=401wt.eu-S1762469AbXGYIks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762469AbXGYIks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 04:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXGYIkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 04:40:37 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:44684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbXGYIkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 04:40:35 -0400
Subject: Re: [RFC] fix slub krealloc()
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070723143724.1d0b26eb@schroedinger.engr.sgi.com>
References: <1184773331.4002.4.camel@johannes.berg>
	 <20070723133206.2220db7e@schroedinger.engr.sgi.com>
	 <20070723134713.2b1218bd.akpm@linux-foundation.org>
	 <20070723143724.1d0b26eb@schroedinger.engr.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zmcaQcGyeJBTNGZ0Latl"
Date: Wed, 25 Jul 2007 10:40:56 +0200
Message-Id: <1185352857.4006.4.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zmcaQcGyeJBTNGZ0Latl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I think we already fixed this?

> >     Fix ZERO_OR_NULL_PTR(ZERO_SIZE_PTR)
>=20
> There is no use of ZERO_OR_NULL ptr in krealloc. Linus added a check to
> ksize() instead so that ksize(NULL) returns 0 instead of failing.

However, this still doesn't fix the other corner case I pointed out:
krealloc(NULL, 0, GFP_KERNEL) will give you a NULL pointer instead of a
ZERO_SIZE_PTR afaict.

johannes

--=-zmcaQcGyeJBTNGZ0Latl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGpwyY/ETPhpq3jKURAmm+AJ9fgdEet6EDdUkAsOkrMYq6smzK8ACgp8PC
oArGqIqQwBK9aVRKjaJl+hs=
=Eoff
-----END PGP SIGNATURE-----

--=-zmcaQcGyeJBTNGZ0Latl--

