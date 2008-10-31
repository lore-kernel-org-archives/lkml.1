Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbYJaLdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbYJaLdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbYJaLct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:32:49 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYJaLcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:32:48 -0400
Subject: Re: [RFC] B+Tree library
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081031112651.GD18182@logfs.org>
References: <20081026124643.GA1328@logfs.org>
	 <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MvWKO4jvBpz8GnlSPHzi"
Date: Fri, 31 Oct 2008 12:32:41 +0100
Message-Id: <1225452761.3535.28.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MvWKO4jvBpz8GnlSPHzi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-31 at 12:26 +0100, J=C3=B6rn Engel wrote:
> On Fri, 31 October 2008 11:35:14 +0100, Johannes Berg wrote:
> >=20
> > [looks like this hitting LWN means everyone suddenly found it...]
>=20
> It did?

Yes, on the weekly kernel page, under "Patches and updates / Core kernel
code"

> > > The one aspect where my implementation is actually nice is in allowin=
g
> > > variable key length.  Btree keys are interpreted as an array of unsig=
ned
> > > long.  So by passing the correct geometry to the core functions, it i=
s
> > > possible to handle 32bit, 64bit or 128bit btrees, which logfs uses.  =
If
> > > so desired, any other weird data format can be used as well (Zach, ar=
e
> > > you reading this?).
> >=20
> > Would there be an easy way to use 48-bit keys? Or variable length keys?
>=20
> Variable as in one implementation for several trees with different
> sizes, yes.  Variable as in one tree with differently sized keys, no.

Ok, I guess that would blow up the key size to 6+1+32 bytes, or 10 (5)
longs. Bit large.

> > > So would something like this be merged once some users are identified=
?
> > > Would it be useful for anything but logfs?  Or am I plain nuts?
> >=20
> > I could imagine using it instead of the hash-table for stations and APs
> > in the wireless code, stations are identified by the MAC address (48
> > bit) and APs (BSSs) are identified by their BSSID+SSID (or mesh ID), so
> > variable length. Currently we use a hash table with 256 slots which is
> > quite large for the typical case of mostly less than a hundred entries.
>=20
> MAC address wouldn't be a problem.  For BSSID+SSID one could just keep
> the hashing and use the btree as an 'implementation detail' of the
> 'hashtable'.  Beware that I don't allow two identical keys.  The
> implications of that make my toenails curl up.

Heh. We don't actually hash on the SSID right now, only on the BSSID,
and then use the SSID to distinguish (it isn't common to have two SSIDs
on the same BSSID)

> > > This implementation is extremely simple.  It splits nodes when they
> > > overflow.  It does not move elements to neighboring nodes.  It does n=
ot
> > > try fancy 2:3 splits.  It does not even merge nodes when they shrink,
> > > making degenerate cases possible.  And it requires callers to do
> > > tree-global locking.  In effect, it will be hard to find anything les=
s
> > > sophisticated.
> >=20
> > I think the wireless case would probably want to have real shrinking
> > because it's well possible that you're moving, with your laptop, from a=
n
> > area with a large number of APs to say your home out in the countryside
> > that only has your single AP.
>=20
> Indeed.

I guess not then for now, unless one of us wants to implement
resizing... I'll look for replacements another time, nobody has
complained yet about the huge hash table :)

johannes

--=-MvWKO4jvBpz8GnlSPHzi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCuzWAAoJEKVg1VMiehFYx3oP/1LxLhl/i6GWwbVir//2Iger
oiV9oF+JYS62GwSPB21ulA4+IA1QstkQ4aFQd546QPt00SQmaHBDQTjBExvBxCYw
MDjJTSJaCy6ugJcP4JcKyyAj46TUTdGZMarmsGJTXBXDzyL4xatatMQmPhSkpDK8
LWvA2ODhBUe4bePTFMk++RUMaP20RFqJRbtNpZDC3jpy9Wl94g8+yA5NYRkclZc+
C23yqJNrdMtxMs/Uy0inCvgggAaM72VJVEY74wwVed8mp7qIIyEILzFNV17ezDvs
I0n7MU7SLaLLyxnYe9nsbyrzOemWJaCMQH6Cf7MMyf7Den0lDZCiQo5rB0VUP0Zc
N9CDYsEVp7CseDbY8SPrFneiEvnyila6Qh5svEKFw8qPG3O1K87OszpVKD4TkcCk
5fku4vBnxDfIIUKjLIrwFCha8wV2oAN/BBqRNNrp8R+95e9D9ypzq/HxRKSWfpg5
psUrwZ5nD3CNA3pJ7URda0DS49hP3tKXcL/PPEdZbtuZi3LGLYUpMJdFwC9hyqG5
mI1JXJ5zL2BJxUC6OfT+lOqKM2N6YwGip2op6zNT9H+Aq2t3SoMxd53XPfNTopYO
4go0YZa44t+7yfcQFPS0RMxzrWhpbtN4HbTE+BwoyErRZMobkbEQWWZZ9wCYmwxm
6GcNjLOE+t94tL/LZXtN
=DFd5
-----END PGP SIGNATURE-----

--=-MvWKO4jvBpz8GnlSPHzi--

