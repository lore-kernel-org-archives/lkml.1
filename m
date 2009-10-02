Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbZJBWBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbZJBWBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZJBWBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:01:08 -0400
Received: from dovecot.org ([82.118.211.50]:40232 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726AbZJBWBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:01:07 -0400
X-Greylist: delayed 1418 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2009 18:01:07 EDT
Subject: setproctitle()
From: Timo Sirainen <tss@iki.fi>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-E9O6nwAzLskgTGAyTLrM"
Date: Fri, 02 Oct 2009 17:37:29 -0400
Message-Id: <1254519449.4605.33.camel@timo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E9O6nwAzLskgTGAyTLrM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I'd like to get BSD's setproctitle() implemented for glibc so that more
programs could start using it. The current method of messing around with
argv and environment to implement it is horribly ugly, fragile and I
find it dangerous enough that I haven't dared to use it in my programs.

Any chance of making all this easier so it could actually be implemented
in a generic and safe way in glibc?

I guess there are several different ways it could be done. My first idea
was to have some magic value in beginning of cmdline (\0 followed by a
few characters) followed by a pointer to the actual string. But that's a
bit ugly and userspace can't easily figure out if this is supported by
kernel.

So the second idea, perhaps this will work? Reserve space for the
pointer between arg_end and env_start. If it's NULL, use the old way. If
it's non-NULL, use it for the cmdline. Userspace can check if this is
supported by seeing if environ[0] - (argv[argc-1] + strlen(argv[argc-1])
+ 1) =3D=3D sizeof(void *).

--=-E9O6nwAzLskgTGAyTLrM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrGcpkACgkQyUhSUUBVismuEwCffzfWxjD5HRbHnhsLkI86Jrst
FN8AoJBaFV2AlPn3qrJZGU6CngCvtx5U
=YRDe
-----END PGP SIGNATURE-----

--=-E9O6nwAzLskgTGAyTLrM--

