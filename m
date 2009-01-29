Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbZA2O0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbZA2O0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZA2O0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:26:07 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:49426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbZA2O0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:26:06 -0500
Subject: Re: [PATCH v3] timer: implement lockdep deadlock detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1233236287.4495.77.camel@laptop>
References: <1233010786.4344.1.camel@johannes.local>
	 <20090126230721.GA6556@elte.hu> <1233046009.4012.3.camel@johannes.local>
	 <20090127132759.GI23121@elte.hu>  <20090127134128.GA24965@elte.hu>
	 <1233079597.4755.2.camel@johannes.local> <1233081027.10992.21.camel@laptop>
	 <1233082650.4455.9.camel@johannes.local> <1233130815.10992.39.camel@laptop>
	 <1233136487.4151.5.camel@johannes.local> <1233137581.10992.44.camel@laptop>
	 <1233140081.3936.21.camel@johannes.local>
	 <1233166017.4811.9.camel@johannes.local>  <1233236287.4495.77.camel@laptop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3yD0n4HtwnL2QYU+NT+I"
Date: Thu, 29 Jan 2009 15:25:52 +0100
Message-Id: <1233239152.4035.3.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3yD0n4HtwnL2QYU+NT+I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-29 at 14:38 +0100, Peter Zijlstra wrote:
> On Wed, 2009-01-28 at 19:06 +0100, Johannes Berg wrote:
>=20
> > +/*
> > + * All the indirection here is required to build the
> > + * "<file>:<line>" string and the pointer to it.
> > + */
> > +#define ___TIMER_INITIALIZER(_fn, _exp, _dat, _kn)			\
> > +	____TIMER_INITIALIZER(_fn, _exp, _dat, (_kn), &(_kn))
> > +#define __TIMER_INITIALIZER(_fn, _exp, _dat, _f, _c, _l)		\
> > +	___TIMER_INITIALIZER(_fn, _exp, _dat, _f # _c # _l)
> > +#define _TIMER_INITIALIZER(_fn, _exp, _dat, _f, _l)			\
> > +	__TIMER_INITIALIZER(_fn, _exp, _dat, _f, :, _l)
> > +#define TIMER_INITIALIZER(_function, _expires, _data)			\
> > +	_TIMER_INITIALIZER(_function, _expires, _data, __FILE__, __LINE__)
>=20
> The regular way to write that would be:
>=20
> #define __STR(foo) #foo
> #define STR(foo) __STR(foo)
>=20
> __FILE__ ":" STR(__LINE__)
>=20
> I'm sure I saw that stringify thing somewhere in the kernel before, but
> can't find it. I recently added it to lockdep.c, maybe we should add it
> to kernel.h ?

Ohh, hmm, my cpp could be stronger :) I'll try out with stringify and
send a complete v4.

johannes

--=-3yD0n4HtwnL2QYU+NT+I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgbxtAAoJEKVg1VMiehFY0BEQAJFTlgDRsX24WzS4NSc/tvmn
ttNkOSA5bHRgX/S1Og/EZQuG9IybxDR32wudIr0edvV8plumH5CBlOuXmpj1vFhz
zdWp9HIcd9Gu8lH3hQtCWYVFRKLKcFpjjAmIHtSmXGyUEgJXNlwDTKWhRyCcjPHK
67rrK6lw+Mk87ZbxzuPbv4h9KpGyGsjScTzzwcNAtww8QuHRmD+B3bdrf0CA6q5F
PU6ETTEa3fijnaACeW/qzUZm7KAX/OAnbdOk+yV6CRIwEEjQ4JO3ovAvo/cIYFlR
v8PCs578dz3bcz9UKcTZ/44bgcZmJG2+O5CRPWfYTQZqtpu8/HpiqPMok1t0l227
Sl7JyxGLvQ+5oCM4x5ImW0nr5sKiG/MW5l/MDpoA2hOmWTBaBWW7c/bS3biGaY5e
MWQ5UBJRE8WVdfgUtxG4j2MkqHieVHUfuM1LUoYQSSLE78j/asEZFdhRasAMnee/
pG9IdTXnswoD18Xxj12FrYE+IwyyPYe75pODZOsh3gy9HP6FDiQv2eO/9lzqiLQH
s5KoGOZDzGPU1a3uPxBBFeZ2Iowsz7CktxnPKO7XJ29S8Y52MkE5+F40ZOt6UWpr
BoZ5idInc/VVdaBVOa4gtk/umhg0AqnLh24i4UwZ7SL0oihcczRYLEjVlklwiqf2
wJYgYdxhWEUoIr6/ArVf
=AoGN
-----END PGP SIGNATURE-----

--=-3yD0n4HtwnL2QYU+NT+I--

