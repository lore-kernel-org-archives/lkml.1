Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790Ab0ANOGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0ANOGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 09:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773Ab0ANOGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 09:06:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48655 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756743Ab0ANOGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 09:06:50 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Rob Landley <rob@landley.net>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <201001140457.00696.rob@landley.net>
References: <201001140457.00696.rob@landley.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mvhU4xIvC8KARoc+j0kI"
Date: Thu, 14 Jan 2010 14:06:45 +0000
Message-ID: <1263478005.17815.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: git 9c501935a3cd broke the strace build.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mvhU4xIvC8KARoc+j0kI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-01-14 at 04:57 -0600, Rob Landley wrote:
> >    net: Support inclusion of <linux/socket.h> before <sys/socket.h>
> >  =20
> >    The following user-space program fails to compile:
> >   =20
> >        #include <linux/socket.h>
> >        #include <sys/socket.h>
>=20
> Did it ever?  Isn't #including both sys/thingy and a linux/thingy in the =
same=20
> program considered bad form?

I don't see why.

Even if a source file doesn't include both of them directly, they may
both be included indirectly.

[...]
> Now under 2.6.32 it dies with:
>=20
>   linux/netlink.h:35: error: expected specifier-qualifier-list before
>   'sa_family_t'

I did actually ask for this to be reverted when I saw that it causes
breakage elsewhere, but David Miller insisted that my change was
correct.

> And later on the strace build breaks because it doesn't #include=20
> linux/netlink.h when it needs to.  (Why yes, autoconf _is_ brittle and ne=
ar-
> useless, thanks for noticing.)
>=20
> *shrug*  I can patch the strace ./configure to include bits/socket.h inst=
ead of=20
> linux/socket.h,

Including libc headers under 'bits' is a bad idea.

> but what I can't understand is why _you_ couldn't.  (What use=20
> case did this patch actually fix?  Would reversing the order of those two=
=20
> headers have helped?)

I think that reversing the order of the two headers should work for
kernel headers before and after this change.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-mvhU4xIvC8KARoc+j0kI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS08k7ee/yOyVhhEJAQL3YBAAqCN2S0NImJ/3gn1LwVkG44pa8xxEHrKl
7pzbhHOMbIKsBO6pdpN0WB7idUY1Mq5UWT4D7bCI4bLqrtZCzb/3+w3C32MW7Kw4
OG9uWHLgsi/JWbsejFAjos4y7TuWJ9SCSgOivdj/lJ7YSiGl9YOGCLskGMZHgkWv
gXJnsIL/2Y7bK9Hyfp8MpKpTjfv3aZ1MOK5zROdqo3YHyX40mBsILARlY5ycDDua
E426b2XZm83nBXRtkwK3xFoJTO5aq8XDH8M7aKHd54QxnVhMNij0F3L8SWf3XUjf
LyeqUoeN4F5TVgUxtyvWMS73RGiC6NSzj+OrhzJ6aRw0NHBgAF0zJ1d3dXc0GyGP
SGi+XfXIUnOiLjn/HhMKLrmPpXwJ8mbHBXRMwx8QK8+WBv1Kzype+DqQoXqzgTlB
/q5E+dd5KEY/LOCd/Q4JDy5i+5zkjoegbFw9CzNPMz2TZlWfvnTcVQJWaVHHLsM8
FlWX/O+ovbEzpkYXxa5+h03qhjBRyjDa5fxfA9drjM97PMHBcUvoY3KalTQvN5hA
832T/799x+WKJtXW1gETbYINwU8zAmSDN1987sZCzaXaDML7sgX5Orf3sw8KHb8K
Rp+plBveyBwJ9NGv+k64nWsYRLi5mhcLZF6xCu/rF/Xl/sfva2l3NwKYlR4lSCyL
rl1H1XEyzck=
=tM8/
-----END PGP SIGNATURE-----

--=-mvhU4xIvC8KARoc+j0kI--
