Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823Ab0AMKkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab0AMKkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433Ab0AMKkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:40:52 -0500
Received: from ms01.sssup.it ([193.205.80.99]:40441 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755589Ab0AMKkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:40:51 -0500
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: core of the scheduling class
From: Dario Faggioli <faggioli@gandalf.sssup.it>
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
In-Reply-To: <1262089538.7135.139.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707614.6228.453.camel@Palantir>  <1262089538.7135.139.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SXsoQKL61xw6zmpt8dw4"
Date: Wed, 13 Jan 2010 11:40:48 +0100
Message-ID: <1263379248.3853.75.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SXsoQKL61xw6zmpt8dw4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-29 at 13:25 +0100, Peter Zijlstra wrote:
> On Fri, 2009-10-16 at 17:40 +0200, Raistlin wrote:
> > @@ -5966,10 +5982,14 @@ void rt_mutex_setprio(struct task_struct *p, in=
t prio)
> >         if (running)
> >                 p->sched_class->put_prev_task(rq, p);
> > =20
> > -       if (rt_prio(prio))
> > -               p->sched_class =3D &rt_sched_class;
> > -       else
> > -               p->sched_class =3D &fair_sched_class;
> > +       if (deadline_task(p))
> > +               p->sched_class =3D &deadline_sched_class;
> > +       else {
> > +               if (rt_prio(prio))
> > +                       p->sched_class =3D &rt_sched_class;
> > +               else
> > +                       p->sched_class =3D &fair_sched_class;
> > +       }=20
>=20
> This looks wrong.
>=20
Completely agree! :-P

> This is PI code, so the effective class should be determined based on
> the 'priority' not on the 'policy'.
>=20
Agree, but...

> I understand we don't yet have deadline inheritance like things in
> place, but this would be where we should make use of the simple ceiling
> protocol to boost things for now.
>=20
... You got it! This is me having no idea of what solution would be
better since no deadline/bandwidth/whatever inheritance is in place
right now.

Now that you gave a direction, I'll follow right that path! :-)

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-SXsoQKL61xw6zmpt8dw4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktNoy8ACgkQk4XaBE3IOsQF1QCeKBSvoK37wFqiSzk5j6fkenHw
dzgAnjW7H0yBY73yqHW0A00VahlXTKcr
=WPKR
-----END PGP SIGNATURE-----

--=-SXsoQKL61xw6zmpt8dw4--

