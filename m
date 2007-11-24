Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbXKXPvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbXKXPvP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 10:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbXKXPvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 10:51:00 -0500
Received: from smtp3.netcabo.pt ([212.113.174.30]:59208 "EHLO
	exch01smtp12.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752024AbXKXPu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 10:50:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhRuAH/WR0dThJYTPGdsb2JhbACBW4Vjh3YBAQEBNQI
Date: Sat, 24 Nov 2007 15:50:52 +0000
From: Luciano Rocha <strange@nsk.no-ip.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, kune@deine-taler.de, johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
Message-ID: <20071124155052.GA15440@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <strange@nsk.no-ip.org>,
	Pierre Ossman <drzeus-list@drzeus.cx>,
	Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
	davem@davemloft.net, kune@deine-taler.de, johannes@sipsolutions.net
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net> <20071124143441.41657307@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <20071124143441.41657307@poseidon.drzeus.cx>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-OriginalArrivalTime: 24 Nov 2007 15:50:56.0560 (UTC) FILETIME=[CD206300:01C82EB1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 24, 2007 at 02:34:41PM +0100, Pierre Ossman wrote:
> On Fri, 23 Nov 2007 00:15:53 +0000 (GMT)
> Daniel Drake <dsd@gentoo.org> wrote:
>=20
> > Being spoilt by the luxuries of i386/x86_64 I've never really had a good
> > grasp on unaligned memory access problems on other architectures and de=
cided
> > it was time to figure it out. As a result I've written this documentati=
on
> > which I plan to submit for inclusion as
> > Documentation/unaligned_memory_access.txt
> >=20
> > Before I do so, any comments on the following?
> >=20
>=20
> A very nice, and much needed document. I think you should include one thi=
ng though:
>=20
> memcpy() is _only_ safe when one of the pointers is char* or void*. If it=
 is anything more complex than that, gcc will assume alignment and optimise=
 based on that. E.g. memcpy() of two long:s generates the same assembly as =
doing an assignment.

Dumb memcpy (while (len--) { *d++ =3D *s++ }) will have alignment problems
in any case. Intelligent ones, like the one provided in glibc, first copy
bytes till output is aligned (C file) *or* size is a multiple (i686 asm fil=
e)
of word size, and then it copies word-by-word.

Linux's x86_64 memcpy does the opposite, copies 64bit words, and then
copies the last bytes.

So, in effect, as long as no packed structures are used, memcpy should
be safer on *int, etc., than *char, as the compiler ensures
word-alignment.

--=20
lfr
0/0

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHSEhcinSul6a7oB8RApR3AKCV5qMYQACdV9v2cqcnkKn1k4azTwCgocF7
+ZiMtM/N/iDwGs3yUOP04RA=
=cmfL
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
