Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbXKXRWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbXKXRWu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 12:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXKXRWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 12:22:42 -0500
Received: from smtp2.netcabo.pt ([212.113.174.29]:51793 "EHLO
	exch01smtp11.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752550AbXKXRWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 12:22:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhRuAFfsR0dThJYTPGdsb2JhbACBW4Vjh3YBAQEBNQI
Date: Sat, 24 Nov 2007 17:22:36 +0000
From: Luciano Rocha <strange@nsk.no-ip.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, kune@deine-taler.de, johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
Message-ID: <20071124172236.GA16944@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <strange@nsk.no-ip.org>,
	Pierre Ossman <drzeus-list@drzeus.cx>,
	Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
	davem@davemloft.net, kune@deine-taler.de, johannes@sipsolutions.net
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net> <20071124143441.41657307@poseidon.drzeus.cx> <20071124155052.GA15440@bit.office.eurotux.com> <20071124171931.699aa1ff@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20071124171931.699aa1ff@poseidon.drzeus.cx>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-OriginalArrivalTime: 24 Nov 2007 17:22:39.0537 (UTC) FILETIME=[9D280A10:01C82EBE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 24, 2007 at 05:19:31PM +0100, Pierre Ossman wrote:
> On Sat, 24 Nov 2007 15:50:52 +0000
> Luciano Rocha <strange@nsk.no-ip.org> wrote:
>=20
> >=20
> > Dumb memcpy (while (len--) { *d++ =3D *s++ }) will have alignment probl=
ems
> > in any case. Intelligent ones, like the one provided in glibc, first co=
py
> > bytes till output is aligned (C file) *or* size is a multiple (i686 asm=
 file)
> > of word size, and then it copies word-by-word.
> >=20
> > Linux's x86_64 memcpy does the opposite, copies 64bit words, and then
> > copies the last bytes.
> >=20
> > So, in effect, as long as no packed structures are used, memcpy should
> > be safer on *int, etc., than *char, as the compiler ensures
> > word-alignment.
> >=20
>=20
> It most certainly does not. gcc will assume that an int* has int alignmen=
t. memcpy() is a builtin, which gcc can translate to pretty much anything. =
And C specifies that a pointer to foo, will point to a real object of type =
foo, so gcc can't be blamed for the unsafe typecasts. I have tested this th=
e hard way, so this is not just speculation.

Yes, on *int and other assumed aligned pointers, gcc uses its internal
version.

However, my point is that those pointers, unless speaking of packed
structures, can safely be assumed aligned, while char*/void* can't.

> In other words, memcpy() does _not_ save you from alignment issues. If yo=
u cast from char* or void* to something else, you better be damn sure the a=
lignment is correct because gcc will assume it is.

Nothing does, even memcpy doesn't check alignment of the source, or
alignment at all in some assembly implementations (only word-copy,
without checking if at word-boundary).

--=20
lfr
0/0

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHSF3binSul6a7oB8RApjdAJ4pvLZ1ThOMi9Ph0o68UM70PDiQVACfWU3H
aV5vPZa8gkFqoz+f1VGOgZM=
=6GAc
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
