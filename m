Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbZDGCJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbZDGCJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZDGCIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:08:51 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:45150 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbZDGCIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:08:50 -0400
Subject: Re: [PATCH] Resurrect old pr_debug() semantics as pr_devel()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
In-Reply-To: <20090406212417.GC3212@redhat.com>
References: <4a5c6b4cd1b77ebe6d60362bc982f4dc81cba85e.1238992196.git.michael@ellerman.id.au>
	 <20090406212417.GC3212@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1FgHI7KhzeTS9+ZfrdFK"
Date: Tue, 07 Apr 2009 12:08:47 +1000
Message-Id: <1239070127.6565.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1FgHI7KhzeTS9+ZfrdFK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-04-06 at 17:24 -0400, Jason Baron wrote:
> On Mon, Apr 06, 2009 at 02:30:03PM +1000, Michael Ellerman wrote:
> > pr_debug() used to produce zero code unless DEBUG was #defined. This is
> > now no longer the case in practice[1].
> >=20
> > There are places where it's useful to have debugging printks, but we
> > don't want them to generate any code in production kernels.
> >=20
> > So add a new macro, pr_devel(), for _devel_opment, to provide the old
> > semantics, ie. if the programmer doesn't explicitly enable debugging,
> > no code is produced.
> >=20
> > [1]: You can turn CONFIG_DYNAMIC_DEBUG off, but it's enabled in at leas=
t
> >      one distro kernel, so it's not really a solution.
> >=20
>=20
> hmm...its designed to have low overhead when CONFIG_DYNAMIC_DEBUG
> is on, but none of the debugging printks are enabled.=20

Sure, it does that fairly well, and there are places where it's a good
trade off to have the debug available at the cost of a bit more code.

> Is there a specific benchmark or test case that is unaccpetable?

Yes. Compiling with DYNAMIC_DEBUG=3Dy generates a non-zero amount of code
for each pr_debug(), and in some places that is unacceptable.  :)

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-1FgHI7KhzeTS9+ZfrdFK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknata8ACgkQdSjSd0sB4dLYzwCgq3UIiRQ1VfLq9sXesddrrt1+
CD0AnjPs/zERDpEfpa8YT6z/DQX83Z+U
=aIHd
-----END PGP SIGNATURE-----

--=-1FgHI7KhzeTS9+ZfrdFK--

