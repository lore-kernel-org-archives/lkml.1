Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252Ab0AMJac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab0AMJac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402Ab0AMJaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:30:30 -0500
Received: from ms01.sssup.it ([193.205.80.99]:45414 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755213Ab0AMJa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:30:27 -0500
Subject: Re: [RFC 7/12][PATCH] SCHED_DEADLINE: signal delivery when
 overrunning
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1262009964.7135.109.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707856.6228.461.camel@Palantir>  <1262009964.7135.109.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8DpthYMcEpVeLKdxbH7q"
Date: Wed, 13 Jan 2010 10:30:23 +0100
Message-ID: <1263375023.3853.3.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8DpthYMcEpVeLKdxbH7q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-28 at 15:19 +0100, Peter Zijlstra wrote:=20
> > A runtime overrun will be quite common, e.g. due to coarse execution ti=
me
> > accounting, wrong parameter assignement, etc.
> > A deadline miss --since the deadlines the scheduler sees are ``scheduli=
ng
> > deadlines'' which have not necessarily to be equal to task's deadlines-=
- is
> > much more unlikely, and should only happen in an overloaded system.
>=20
> Right, I think its much better to not do this in posix-cpu-timers.c,
> that code is shite.
>=20
> Its probably possible to set SIGXCPU pending and raise TIF_SIGPENDING
> from within the scheduler code, and that will be triggered when we
> return to userspace.
>=20
Ok, this sounds a lot better to me too... I'll go for this!

> That also gets rid of that coarse execution time accounting muck, since
> the scheduler has ns accurate accounting.
>=20
Yes --at least when the hrtick is enabled-- I agree that this is another
very interesting benefit of this approach.

It'll be done like this in the next version of the patchset I'm
preparing.

Thanks for the answer and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-8DpthYMcEpVeLKdxbH7q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktNkpMACgkQk4XaBE3IOsQeUACdH1mREXh229OJ5S1jcDtVMq2G
OKkAnRltb6qZsxXCf6Pb5E/Yu8rsyekO
=rSYj
-----END PGP SIGNATURE-----

--=-8DpthYMcEpVeLKdxbH7q--

