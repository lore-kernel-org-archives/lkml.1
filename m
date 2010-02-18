Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab0BRSpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:45:52 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:43175 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab0BRSpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:45:50 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jMq8qHulsVqCCIMujYd0"
Date: Thu, 18 Feb 2010 19:45:35 +0100
Message-ID: <1266518735.3829.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jMq8qHulsVqCCIMujYd0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-02-18 at 08:31 -0800, Linus Torvalds wrote:

> > > halt/4071 is trying to acquire lock:
> > >  (s_active){++++.+}, at: [<c0000000001ef868>]
> > > .sysfs_addrm_finish+0x58/0xc0
> > >=20
> > > but task is already holding lock:
> > >  (&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}, at:
> [<c0000000004cd6ac>]
> > > .lock_policy_rwsem_write+0x84/0xf4
> > >=20
> > > which lock already depends on the new lock.
>=20
> You don't have a full backtrace for these things?

No, it deadlocks right there, unfortunately.

> We've had lots of trouble with the cpu governors, and I suspect the=20
> problem isn't new, but the lockdep warning is likely new (see commit=20
> 846f99749ab68bbc7f75c74fec305de675b1a1bf: "sysfs: Add lockdep
> annotations=20
> for the sysfs active reference").
>=20
> So it is likely to be an old issue that (a) now gets warned about and
> (b) might have had timing changes enough to trigger it.

Well, it used to not deadlock and actually shut down the machine :) So
in that sense it's definitely new. It might have printed a lockdep
warning before, which you wouldn't normally see since the machine turns
off right after this.

> I suspect it is G5-specific (or specific to whatever CPU frequency
> code=20
> that gets used there), since I think we'd have had lots of reports if
> this=20
> happened on x86.

Yeah, that's puzzling me as well.

johannes

--=-jMq8qHulsVqCCIMujYd0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLfYrKAAoJEODzc/N7+QmaFUIQAK3l2asXHlwPg6zYbHeBWhYm
Qm49GvWw6UEYelwTWwhLgJUJeZspMeW5ROBbRL0DH+I1qSBjq2B2Yp9dEHh96oIw
brdnd+JZmbR/Rx1vb9CfN+D/cEegj8HY3fvLYF0Tl0P8aj60bcky1xjdFkJhsOTl
qLJQFPFTDdrqpQ9S7ZxAumuLFz/R/qhcNl9/ir+B2ptSn3hqA2z6j80bfZckzj/0
U74E59w9kRzlq+NtoxlNM41JMEbY0lAow2Z53oaDS3XyXr0uW5NZuX8w1lcEjqvj
zNboicF+8CLW86Pmcf3sZl/WxDClGjt8O0tcy0JWJN7CwXS1BA8GcGrTSU7kZxVw
SnEiKWCFvCYTYhppQebGjRmbR23L1ahDiS+KGOx9OpyKjOXyUYwS/6JYs4fsN7rv
qQUKPPyEEaS4MQCZKyGOKl4gCLQcVuXoXTwwUCvmC5+BYmSWmLRS0XjC5C18XS/y
AvGn4ehH93146Wvwnd6Ckc2PKrDkiouu9L2rcySSKQ01Y8na+UhMKMbIEhFxaTLA
sL7N9E6ljf5AEMz/Ck+0QE7QHhxdtk47uQc61IxoDwkfyR0IRnyXJwUoJSw3n1qx
+L5ZGtWjy6Y6eQ1/4E44xlZ/CBDWgzkRFFVP7U65X1r/qUi34v2pjPk0GLsxgXJr
lWr1MEqdrqWIwMw48aiP
=/VWd
-----END PGP SIGNATURE-----

--=-jMq8qHulsVqCCIMujYd0--

