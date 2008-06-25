Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbYFYPgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbYFYPgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758730AbYFYPfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:35:37 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:54171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360AbYFYPff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:35:35 -0400
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
	in some kernel info printks
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Jackson <pj@sgi.com>, hpa@zytor.com, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, linux-kernel@vger.kernel.org,
       ying.huang@intel.com, andi@firstfloor.org
In-Reply-To: <alpine.LFD.1.10.0806250813030.4733@hp.linux-foundation.org>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>
	 <86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>
	 <20080623060939.6b6b3183.pj@sgi.com>
	 <86802c440806241429s  <alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org>
	 <1214406026.21847.25.camel@johannes.berg>
	 <alpine.LFD.1.10.0806250813030.4733@hp.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PgLoh2g3zCnCkTe6XMQ8"
Date: Wed, 25 Jun 2008 17:34:25 +0200
Message-Id: <1214408065.21847.30.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PgLoh2g3zCnCkTe6XMQ8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-25 at 08:19 -0700, Linus Torvalds wrote:
>=20
> On Wed, 25 Jun 2008, Johannes Berg wrote:
> >=20
> > In networking, we've gone through various incarnations of print_mac()
> > which is similar to the sym() macro Paul proposed, and it turned out to
> > be undesirable because of the way it interacts with static inlines that
> > only optionally contain code at all, the print_mac() function call is
> > still emitted by the compiler. People experimented with marking it
> > __pure but that had other problems.
>=20
> You don't even have to go that esoteric.
>=20
> Just printing things like "sector_t" or "u64" is painful, because the=20
> exact type depends on config options and/or architecture.

Heh, true, but I have the print_mac() disaster firmly imprinted in my
mind ;)

> > It would be nice to be able to say
> >=20
> > u8 *eaddr;
> >=20
> > printk(... %M ..., eaddr);
>=20
> For special things, I do think we should extend the format more, and=20
> forget about single-character names. It would be lovely to do them as
> %[mac], %[u64], %[symbol] or similar. Because once you don't rely on gcc=20
> checking the string, you can do it.

True, that does look a lot better and has less potential for confusion.

> The problem is that right now we absolutely _do_ rely on gcc checking the=
=20
> string, and as such we're forced to use standard patterns, and standard=20
> patterns _only_. And that means that %M isn't an option, but also that if=
=20
> we want symbolic names we'd have to use %p, and not some extension.
>=20
> But once you drop the 'standard patterns' requirement, I do think you=20
> should drop it _entirely_, and not just extend it with some pissant=20
> single-character unreadable mess.

Oh yes, I agree. At one point I figured it should be easy enough to
extend gcc with something that allows you to specify the format
character/type to take but alas, such a thing is not possible.

johannes

--=-PgLoh2g3zCnCkTe6XMQ8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYmV9AAoJEKVg1VMiehFYIZoQAL+Njqp6byI9dIIMmexfg8G4
2HePs1PrdWZ/NYLij/wFurehaLZ7ZEkDqYZsar/FbZR9uZN6oHBXyY3teE7+svqy
OONC3gF9/uTHf33FiepugsGKWIWo9EaIeqzFFyRiPesrkUt33YBRiFmZ2nm3W2Sg
ygnB6iXnCiAX7lQX64w1m3Oq6Wq7ygyt1ZZ+EuOwVCxULlD8a+bInIwa8upfpJyw
STqTcPjHv2iVfaqZs9R21+iPnmDpFsyl6iKIRwWyalqLriyk2KpfRzmpamqfDTNn
w5PY7rTUmSa8a+xIO0Sx7yhhYrousP9w2vXBNZCFrrc/WkAfG3cwXkn0u4auvkyO
vbWaQfZ5hnjXt2BIsdfZfe1iihIeGK+VgxXpzEAMmOewAj1FK9cC1zZTDqfBZGKx
LARPLYu1ro+EGlN2fIyOlM798ncMf49bqlm61PGhhYWVwePei3Mnqs1O80ZEk76W
1+Nr7wmY5qHjmp+s8oK65ukwzPecgYJJGt7DfuhKlRb2qJNMxwu2/GidsT8h6z2i
e14wNhfRf3bjMvk3Z4l16Tg71RZuJcPTHJx2JdHHvBMhpDhecDOpOp5OtgLzKaM1
H5DQ7OT2Mia7DMYoP5h+QOAq13YbFPwTU84k24ICyJ5f5FQ6jQ5iQnRL/IKQJfwI
wmokWrjtp9gaEjqm7VGk
=+UJp
-----END PGP SIGNATURE-----

--=-PgLoh2g3zCnCkTe6XMQ8--

