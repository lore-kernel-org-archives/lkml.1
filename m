Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbZIDFEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbZIDFEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZIDFEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:04:40 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60893 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZIDFEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:04:39 -0400
Subject: Re: [PATCH] cfg80211: clear cfg80211_inform_bss() from kmemleak
 reports
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090903204319.GC3701@mosca>
References: <1251958266-10692-1-git-send-email-lrodriguez@atheros.com>
	 <1251962791.3336.3.camel@johannes.local>
	 <43e72e890909031113r6010519br3b81d15cc331ba85@mail.gmail.com>
	 <1252001837.9336.2.camel@johannes.local>  <20090903204319.GC3701@mosca>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-d7JXL/ktGP0hW9macFZ4"
Date: Fri, 04 Sep 2009 07:04:31 +0200
Message-Id: <1252040671.9336.10.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-d7JXL/ktGP0hW9macFZ4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-03 at 13:43 -0700, Luis R. Rodriguez wrote:
> On Thu, Sep 03, 2009 at 11:17:17AM -0700, Johannes Berg wrote:
> > On Thu, 2009-09-03 at 11:13 -0700, Luis R. Rodriguez wrote:
> >=20
> > > What I meant is it gobbles it up and spits another thing out. When it
> > > gobbles it up the routine then uses kref_put().
> > >=20
> > > > Why can it not track this?
> > >=20
> > > It probably can, just not sure if it follows kref_put(), I was under
> > > the impression here it doesn't and because of it we were getting fals=
e
> > > positives. Catalin, can you confirm?
> >=20
> > Ah I'd think that if it can't track it then that's because we use a
> > pointer to the middle of the struct to keep track of it much of the
> > time.
>=20
> So you agree with the patch but not the commit log entry?

I'm not sure -- I think kmemleak should be able to figure it out, and if
you were using IBSS then we actually have a leak that we need to plug,
but otherwise I'd prefer to get some more input from Catalin first.

Catalin, is it conceivable that kmemleak reports false positives if we
use a struct like

struct pubbss {
...
};

struct bss {
...
struct pubbss pub;
};

and then keep track of &bss->pub; pointers instead of bss directly?

johannes

--=-d7JXL/ktGP0hW9macFZ4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKoJ/aAAoJEODzc/N7+Qma0AsQAMulcaFvKu4CdiJooZZZqCnO
v96SKbEoxJdes67LiZ+jL9YEiTV5bcPK5FMu7S1SgIT+kSveBVMcTIgQteZKmhpm
1FDUrZBYqHrKpk7ZTptjLy70WaMGcfzv0itJsLlaq8A7FgGQ8zyiIM31OfmetTQf
SMDzDapC8yIMuh+mkEwUW6FMbFgBclhoX8QWYXXiSCcI+voOSvMRE0UefjJ7Xx8A
K8C2wMhBDshFivIJ0+GZ8ptrZw16Hspwhqm2dPcNrRT/KdFZvwFupISrkBy2gASP
KUFR/edFmIaPXHlvhe7iQZ7l8Dc9L1MJDPkz/c67pOn8Z6q1fqbpBi+eXI9ng1No
hUC0jiZPHhZNyVYIgd7ikhcLjRtWj9Q+YeFXVMOrMycnlCoy5jxCISMunyTaBIyb
rzbKrgvP0QmGORK8IjAtC3C0nnSeseFXnC2EbjxRHB1UcnUmR++DahBnXGttPoEK
XlXWU67SVsWN6wuQ2G3tQM8M3QmwJv1ig35cx3v/v/ZpGVX3fO7NE4aqbU4CIm+J
MVoB3t5hmjjj05uvCbrdmZDGbmoK7lpEZZ/mmVSxZTpDLWB/8jq8ofkkwXqHHW86
MAJn81W/T87xmGr2nkngppmaUikn3iNNdRc8/vw5E1lTYAtj5RRjvJRjV5vVl0+1
auxCYpyGml3eP6Y8efE0
=c1gx
-----END PGP SIGNATURE-----

--=-d7JXL/ktGP0hW9macFZ4--

