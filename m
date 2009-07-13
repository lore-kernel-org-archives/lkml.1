Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbZGMQjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbZGMQjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZGMQjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:39:08 -0400
Received: from mail.open.by ([193.232.92.17]:50646 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbZGMQjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:39:07 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9018 [Jul 13 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Mon, 13 Jul 2009 19:41:13 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: possible regression with pty.c commit
Message-ID: <20090713164113.GA3207@localdomain.by>
References: <20090711191556.GA3845@localdomain.by>
 <20090711232452.4dc7c1ba@lxorguk.ukuu.org.uk>
 <20090711235530.GA3231@localdomain.by>
 <20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/13/09 12:48), Alan Cox wrote:
> > Alan, I forgot to tell - I'm using KDE 3.5.9 (3.5.10). Don't know wheth=
er this can be reproduced with KDE 4.x.x.
>=20
> Dumping out the traces tty side the tty code appears to be
> working correctly. The userspace on the other hand appears broken and to
> only work by chance with the old code.
>=20
> For one it wants for new output to appear before checking for "Password:"
> and in doing so consumes any partial output it receives without checking.
> I suspect it should be doing line +=3D more
>=20
> One for the KDE people as its not the kind of thing we can fudge back
> kernel side if my diagnosis is right.
>=20
Hello,
Sorry for delay. d945cb9cce20ac7143c2de8d88b187f62db99bdc is not the first =
bad commit as I've managed to make=20
kdesu work simply adding some senseless instructions to pty_write_room(). A=
nyway.

As for kdesu, it's obvious that kernel should be free from code that simply=
 makes some buggy user space=20
programm working (even one that was working for years until 2.6.31).
Lots of versions could be affected (4.a.b, 3.c.d, ...) and I'm just not sur=
e that all of them will be
updated ( not all, but popular ones. like 3.5.x ). We'll see.

Thanks,
	Sergey
--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpbY6kACgkQfKHnntdSXjRxIgQA01jsaAHwgs5xeKv9JUtQsC/K
u3mDTEmbRFbOfhv0i8abqSxRW53a/ld6Nrn5E518AYBJa2HUkADyBTo1UEoC537u
Gh0Gp9o0zI2CYJEP8SzVFlRALU5/+rQzHZDKwcC/EtLs9Siu129Qrq0SXcTzGH5g
H1mt7oukopahEsdl/Sk=
=7Hl9
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
