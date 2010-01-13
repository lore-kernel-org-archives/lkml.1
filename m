Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633Ab0AMKdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab0AMKdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635Ab0AMKdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:33:08 -0500
Received: from ms01.sssup.it ([193.205.80.99]:59747 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755654Ab0AMKdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:33:06 -0500
Subject: Re: [RFC 12/12][PATCH] SCHED_DEADLINE: modified sched_*_ex API
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
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1262088909.7135.136.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255708086.6228.469.camel@Palantir>  <1262088909.7135.136.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kw2SoB0Sez0oPLHZ2E9G"
Date: Wed, 13 Jan 2010 11:33:04 +0100
Message-ID: <1263378784.3853.67.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kw2SoB0Sez0oPLHZ2E9G
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-29 at 13:15 +0100, Peter Zijlstra wrote:
> >  	if (!param_ex || pid < 0)
> >  		return -EINVAL;
> > +	if (len < sizeof(struct sched_param_ex))
> > +		return -EINVAL;
> > =20
> >  	read_lock(&tasklist_lock);
> >  	p =3D find_process_by_pid(pid);
> > @@ -6837,7 +6844,7 @@ SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
> >  	/*
> >  	 * This one might sleep, we cannot do it with a spinlock held ...
> >  	 */
> > -	retval =3D copy_to_user(param_ex, &lp, sizeof(*param_ex)) ? -EFAULT :=
 0;
> > +	retval =3D copy_to_user(param_ex, &lp, len) ? -EFAULT : 0;
> > =20
> >  	return retval;
> > =20
>=20
> I think this doesn't even do what it claims to do, namely provide a
> flexible ABI, since you fail the operation when there is not enough room
> provided. Hence, when we grow the struct an older program that was
> compiled against the smaller one will become an insta-fail.
>=20
> What this should do is deal with smaller structs by ensuring the tail is
> 0 and simply copying out the head.
>=20
Yep... As said in the previous mail I wanted to do so, and I'll do it
now that I see how odd was what I wrote! :-P

> New bits in the flags field are also an interesting challenge.
>=20
Right... I think that a (partial?) solution could be to properly choose
default values for newcomer flags, could that be right?

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-kw2SoB0Sez0oPLHZ2E9G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktNoV8ACgkQk4XaBE3IOsQioACcCpQdWjdf0UyG5lW6kTVfozAz
qxsAn0AD4fSTsjCMSGwsXRLUIXdesqrR
=PaqL
-----END PGP SIGNATURE-----

--=-kw2SoB0Sez0oPLHZ2E9G--

