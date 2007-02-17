Return-Path: <linux-kernel-owner+w=401wt.eu-S1946550AbXBQJjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946550AbXBQJjH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 04:39:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965105AbXBQJjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 04:39:07 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:52515 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965103AbXBQJjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 04:39:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=RMefFA04joH3pc0qTjwhvF1zMaEvRmnL6LntKWV9i4xyP/a7lLzH4ZK9Rp7d/1arOdLWkdRyVsOF1obZVhODFrEJCyo+ZaIi+FjCHWnhkEbxne8YFfn9iWKPTRv8Z0fK;
Message-ID: <45D6CD2D.7090705@simon.arlott.org.uk>
Date: Sat, 17 Feb 2007 09:38:53 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: security_fixup_ops
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig96E5ABBD62B43DC1F491D6AC"
Reply-To: Simon Arlott <0fe037f0d97e4d61cc1him220006i098@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig96E5ABBD62B43DC1F491D6AC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Shouldn't security_fixup_ops be exported?

Otherwise I have to include the kernel's security/dummy.c to use it and t=
here's no other way to fix all the ops for a secondary module without cop=
ying a list of all the ops, which may change in future kernels, into the =
module's code.

Unless of course including kernel source in modules is ok, because the mo=
dule will need to have been compiled with the right version of struct sec=
urity_operations anyway.

---
/* http://redrum.lp0.eu/portac/portac.c */

#include <../security/dummy.c>

struct security_operations portac_ops =3D {=20
	.register_security =3D portac_register_security,
	.unregister_security =3D portac_unregister_security,

	.socket_bind =3D portac_socket_bind
};
struct security_operations primary_ops;
struct security_operations *secondary_ops =3D NULL;

int portac_register_security(const char *name, struct security_operations=
 *ops)
{
	struct security_operations tmp;
=2E..
	/* Copy our current ops because they have
	 * been fixed with dummy functions.
	 *
	 * Keep a reference to the secondary ops
	 * for later use.
	 */
	primary_ops =3D portac_ops;
	secondary_ops =3D ops;

	/* Copy the secondary ops, override the
	 * functions we use and call security_fixup_ops
	 * to add missing dummy functions.
	 *
	 * Replace our current ops with these ops.
	 */
	tmp =3D *ops;
	tmp.socket_bind =3D portac_socket_bind;
	tmp.unregister_security =3D portac_unregister_security;
	security_fixup_ops(&tmp); /* from security/dummy.c */
	portac_ops =3D tmp;
=2E..
}

--=20
Simon Arlott


--------------enig96E5ABBD62B43DC1F491D6AC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRdbNMKRtx1WjQ8ihAQocpw/8D86Fk2x4rQvKT4qa9EwwSoJ5ibpIH2pA
EZsDsuNwcyCSEbiPtjPzdtklMl6V8nz6SJU2dwLiEso47J+LbYpMOvozlXKwIFwm
HsHZRT9MHmH6T/+NEzP9Np1Kk/wxfnwLDttDmAQwi0BqR/T3d7qQnN5j+6ppckV4
zC4nuGv+8nTAe2bnkG24UekVzFs0rWFTdtJ0ieS09DSOG+2lq9MHLT/4x37mhRtl
xhnVdr6OFyW8HYGUjJyw9aBmA2uaXMvtq+R0RxQPeOwc191CU7u4XrOiHDidj6Yh
4PZmopyaKkb9CWzYAuf+6kZihj2ViXJBnfY7xV25fOq2A7K7TmwU/1ZZIWsONN+C
cw8Hhug/fzDTXRLOB8cJb3LV0/oSyJcbUpomCotU3FRL5JmbDTJb76yWBQxN8D5Q
uqW11pSvVHv/eDNjVGDnzbaS6j2gpePEusq6EeuQAeY565ccdo9GhU7yYl9IEfXQ
pDy4eRvbnRZi33zAKGTjMvPc92+FNAtISL8KgCDVv0M4nAchK9/p8jQZqH0rZBpi
rLnsi7+04oFZckIB2pJHpF0Zi/DGmNzribV8dxod8sj6aW7BTfa4mzIUCF8cHjX0
5bYPi73ywtxkvD+a6YgE6UdAKpXrbprtWHMsPjbfn3vVgR3oX8Zjbhb9SgVXKdp8
G++oNW9Cihc=
=43E6
-----END PGP SIGNATURE-----

--------------enig96E5ABBD62B43DC1F491D6AC--
