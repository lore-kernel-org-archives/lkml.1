Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272Ab0AMJdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0AMJdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228Ab0AMJdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:33:12 -0500
Received: from ms01.sssup.it ([193.205.80.99]:34567 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755201Ab0AMJdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:33:10 -0500
Subject: Re: [RFC 8/12][PATCH] SCHED_DEADLINE: wait next instance syscall
 added.
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
In-Reply-To: <1262010601.7135.113.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707898.6228.463.camel@Palantir>  <1262010601.7135.113.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vyM0kkgGjeCG1N731EAj"
Date: Wed, 13 Jan 2010 10:33:04 +0100
Message-ID: <1263375184.3853.6.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vyM0kkgGjeCG1N731EAj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-28 at 15:30 +0100, Peter Zijlstra wrote:
> > However, for SCHED_DEADLINE tasks, it should be the call with which eac=
h
> > job closes its current instance. In fact, in this case, the task is put=
 to
> > sleep and, when it wakes up, the scheduler is informed that a new job
> > arrived, saving the overhead that usually comes with a task activation
> > to enforce maximum task bandwidth.
>=20
> The changelog suggests (and a very brief looks seems to confirm) that
> this code could be much smaller by using hrtimer_nanosleep().
>=20
> The implementation as presented seems to only call ->wait_interval()
> when the timer arms, which seems like a bug, we should always call it,
> regardless of whether we're on a period boundary.
>=20
Ok, thanks, I'll look carefully at that! The current code is an attempt
of mine to replicate the behaviour of clock_nanosleep, but you're
definitely right here, it can be done much better.

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-vyM0kkgGjeCG1N731EAj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktNk08ACgkQk4XaBE3IOsQQ1gCeKl1m6UhDUrG4/ap99Tbs2txe
XU8An1yj9cJKPNIxNKxC/jqvTMjgwFl5
=zIE7
-----END PGP SIGNATURE-----

--=-vyM0kkgGjeCG1N731EAj--

