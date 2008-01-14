Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbYANKwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbYANKwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYANKwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:52:00 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:39433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbYANKv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:51:59 -0500
Subject: Re: 2.6.24-rc7 lockdep warning when poweroff
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1200307288.7415.11.camel@twins>
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
	 <1200302644.7415.6.camel@twins>  <1200306902.5887.39.camel@johannes.berg>
	 <1200307288.7415.11.camel@twins>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-loXNRcDsSOBlMf7QLYyZ"
Date: Mon, 14 Jan 2008 11:51:36 +0100
Message-Id: <1200307896.5887.42.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-loXNRcDsSOBlMf7QLYyZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The warning that triggered (lockdep.c:700) means that one class (key)
> was used with more than one name.

Right.

> Looking at cleanup_workqueue_thread(), the lock_acquire() there works on
> wq->lockdep_map, and that is only initialized at one spot:
> __create_workqueue_key(), thus it stands to reason that that was
> mis-used.

Oh ok, yes, makes sense. Maybe something is generating a workqueue with
a name that's passed in but the key is statically from that place. I'll
try to find it.

johannes

--=-loXNRcDsSOBlMf7QLYyZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4s+t6Vg1VMiehFYAQJbMw/7BLpWemb/HqCfqqdy5vB11mgXNc7cb4lr
tKfbY3UR1frnEbfIB160ohO+W5qv2M4xWLPuPO8+q1KdZKTV6VunqoAa1Rb7rZdG
fTKDyr0Ca01uJsK64ji+VdC0dE1UVj/STAeSnhcCgam+6B0rGw/TwrD1WvUdNhOF
C8fXxX+V0ic9UZydQQl/SgxC9K+N2WVZT69RymrSUHUEHhkMlEsOjYLSfeEXylOa
HF5JR+gkXx00Ts9M4ePb6z0ZUcG/R3pNAg+URl33gxV0Z7AkSv1htSTJyq/K+zOx
yyrf51xJKxDXC0ugbWnnmA/68nW2r3jdQyjaEhi9RPEkJCw2J4/j1tSBYdGRtnN1
HmOpRbukCh08A3sCx9EvRYan1DsDOqbG26ylakkVNWmkZedkkN7J5Xbu2PPIkPbt
OER4E9wvOWgSJecADn5K/B9QKZjptVjsc1t0B5OUbsIg7N/t0nHSFaRnfs5RYLZ1
OCwUJNcZ259Il38eQBViNkaUGxyTzn0JVx6Fj4nxv8kpKI/9GXTxdhIG85B9I5UI
NdPQ6fYvV3qmH+txtY3P4MZGevSEKwt+UhvaGfcbUMhrA3l5wZLzqIcUFHzt66nL
7NBBIRHXTm0WCfhiHy98W1AgUwgYoqvW/ytHMD0EECQxyxhj1+MdJ+SRoD0ReYXR
rDUnOalU1ek=
=bW0I
-----END PGP SIGNATURE-----

--=-loXNRcDsSOBlMf7QLYyZ--

