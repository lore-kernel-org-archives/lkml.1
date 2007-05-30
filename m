Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbXE3Ikg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbXE3Ikg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXE3IkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:40:09 -0400
Received: from redstar.dorchain.net ([212.88.133.153]:56560 "EHLO
	Redstar.dorchain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbXE3IkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:40:04 -0400
X-Greylist: delayed 1082 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 May 2007 04:40:03 EDT
X-DKIM: Sendmail DKIM Filter v0.6.1 Redstar.dorchain.net l4U8Kbiv009265
Date: Wed, 30 May 2007 10:20:35 +0200
From: Joerg Dorchain <joerg@dorchain.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 1/2] m68k: runtime patching infrastructure
Message-ID: <20070530082035.GA8200@Redstar.dorchain.net>
References: <20070528191630.377693320@mail.of.borg> <20070528191715.352919509@mail.of.borg> <20070529173818.fd94ae81.akpm@linux-foundation.org> <465D1020.3030605@cosmosbay.com> <Pine.LNX.4.64.0705300903030.31930@anakin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705300903030.31930@anakin>
X-message-flag: Formating hard disk. please wait...   10%...  20%...
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 30, 2007 at 09:06:08AM +0200, Geert Uytterhoeven wrote:
[...]
> > >=20
> > > I think it could be tightened up even if it happens not to warn?
> >=20
> >=20
> > struct a {
> > 	struct not_yet_defined *start, *end;
> > };
> >=20
> > struct not_yet_defined {
> > 	void *foo;
> > };
> >=20
> > Is a valid and gives no warnings.
>=20
> I was puzzled by this as well, as there were no compiler warnings...

Pointers are (at least on m68k) of known size, so the compiler knows how
much space the struct occupies.

Type checking is by definition futile with void * pointer, but for all
other cases the compiler has all types and sizes it needs at this point.

The actual dereferencing of the symbol table is done by the linker,
which also knows all locations and sizes it needs.

Actually, this is the only way to define circular referencing
structures.

A one-pass-compiler-linker would run into problems.

Joerg, trying to recall compiler construction lessons

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGXTPTjY4+4PdzvOARAuPOAKCG5U6LT9ePqYnQZTAldX20/co/4QCfZSjh
ciagXwFfgeZ3nJ2TFjqvBl0=
=5mKN
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
