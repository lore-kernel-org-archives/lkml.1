Return-Path: <linux-kernel-owner+w=401wt.eu-S1761230AbZBEATi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230AbZBEATi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760982AbZBEATE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:19:04 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:59186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760971AbZBEATC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:19:02 -0500
Subject: Re: [PATCH] add b+tree library
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1231631840.13420.24.camel@twins>
References: <1231584446.3685.21.camel@johannes>
	 <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com>
	 <1231587428.3803.0.camel@johannes>
	 <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com>
	 <20090110183921.GD20611@logfs.org> <1231613042.3706.16.camel@johannes>
	 <87fxjrgd9s.fsf@basil.nowhere.org> <20090110202315.GE20611@logfs.org>
	 <20090110212740.GE31579@mit.edu> <20090110220135.GF20611@logfs.org>
	 <20090110142330.295a8847.akpm@linux-foundation.org>
	 <1231631840.13420.24.camel@twins>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JnPATAYmUV3RTEk1M4Pe"
Date: Thu, 05 Feb 2009 01:17:46 +0100
Message-Id: <1233793066.7390.34.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JnPATAYmUV3RTEk1M4Pe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Let me get back to this...

> > The IDR code there wasn't very well designed and still has holes.  The
> > radix-tree code afaik is solid, but look at all the stuff it does!
>=20
> Yeah, its a bit of a mess, but solvable, as radix trees show.

To be fair, it hasn't been attempted yet though.

> B-tree's however have one thing over RB-trees, B-trees can be made
> RCU-safe whereas RB-trees cannot be -- the only problem is that Joern's
> doesn't do that.
>=20
> I've been poking at my B-tree implementation but got distracted by the
> mutex spin stuff, its still buggy (still the insert sibling overflow --
> the rest should be ok-ish, although I need a hard look at the memory
> barriers).

Joern may need arbitrary key lengths, don't. But I've just looked around
a little:

 * radix trees are completely unsuitable for use as a sort of hash table
   because of their behaviour when keys are not at last mostly
   contiguous
 * rbtrees require lots of boilerplate code, and have much worse cache
   behaviour

In my use case, tracking the wifi APs around you, you have to scale from
a single one to >1k (yes, it's happening!), and lookups better be fast
because you might be doing them a lot (dozens of times per second).

johannes

--=-JnPATAYmUV3RTEk1M4Pe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJijAnAAoJEKVg1VMiehFYGAsP/ieGuZmjGkB9nF532Uy6dhN/
mErz6BCY14CjiLpoQSGZgdS3qV2xMiB/1you9MoNzEL2ce60tsO1eXzszpTD6G6K
0pTh6W4waB8fX+Or2yXrHly2kiEIqd5eKRtbcYU3SLg8rkGO6iTcOWkQp5fYhNy2
n7VL+HFjoyLZiY1CfDnbPvAhI1Ad6JUPv2wddVf/wquWJRergK4SCy3ODzls2cZj
9yQkOhJrktiPLBtQgpqZ5rxm52pgRqZvuYXmiymYmljD6A0M7i5we9syGI0xTI3F
/K54iOMPOlyV2crrE0A1+zkLo2v2/zFitrjbAbxA66uju60hSvx0FzJoUSuZwfJT
ruRZe+VFF0UhbpGqDTW2br6v8E+8Me2xKcQQR45QeRVnhzfWu7VpVv5V31ijh6ht
jsokpl5/0kEvjENAT4uKyhQUoDWCfp1QwLEnQ7DdKte1f0xweewoG9gRZ8oacMEe
n4EQxU3YyT0eukb0VBR6k+I8wLBFqUod7nLMoMjSpJnpa2VUp0IeNGT5Is56IByd
b1oHdMqzLUMIwF2HVGGkwkvKz6/yHr4MWsGkGAf4BND0dSmy80JemZdpgVov6BZj
07cLna8OSy9ZrDUc8gt9eaLLcAwU11mLkpn42g/Zuzs+lc0nAqJ4q2+74guV5CRp
k6ZttbYUY2Gm5m1yFUiw
=LMMA
-----END PGP SIGNATURE-----

--=-JnPATAYmUV3RTEk1M4Pe--

