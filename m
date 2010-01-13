Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023Ab0AMQc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab0AMQc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967Ab0AMQcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:32:25 -0500
Received: from ms01.sssup.it ([193.205.80.99]:50253 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752299Ab0AMQcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:32:24 -0500
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
In-Reply-To: <1262097042.7135.150.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707614.6228.453.camel@Palantir>  <1262097042.7135.150.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eN2cqnnqwjUW1aQpW+Gs"
Date: Wed, 13 Jan 2010 17:32:21 +0100
Message-ID: <1263400341.3853.287.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eN2cqnnqwjUW1aQpW+Gs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-29 at 15:30 +0100, Peter Zijlstra wrote:
> On Fri, 2009-10-16 at 17:40 +0200, Raistlin wrote:
> > +struct task_struct *pick_next_task_deadline(struct rq *rq)
> > +{
> > +       struct sched_dl_entity *dl_se;
> > +       struct task_struct *p;
> > +       struct dl_rq *dl_rq;
> > +
> > +       dl_rq =3D &rq->dl;
> > +
> > +       if (likely(!dl_rq->dl_nr_running))
> > +               return NULL;
> > +
> > +       dl_se =3D pick_next_deadline_entity(rq, dl_rq);
> > +       BUG_ON(!dl_se);
> > +
> > +       p =3D deadline_task_of(dl_se);
> > +       p->se.exec_start =3D rq->clock;
> > +#ifdef CONFIG_SCHED_HRTICK
> > +       if (hrtick_enabled(rq))
> > +               start_hrtick_deadline(rq, p);
> > +#endif
> > +       return p;
> > +}=20
>=20
> I'm not sure about actually using hrtick like this, I'd expect
> SCHED_DEADLINE to always use hrtimers when available.  The only reason
> to use some of the hrtick infrastructure is to re-use the hrtick_start()
> logic which uses IPIs to ensure we program the timer on the right cpu
> (so we can schedule from it).
>=20
Yeah, that and the fact that it seemed to me very easy and clean to:
- check for runtime enforcement inside the task_tick_deadline function,
  as other scheduling classes do, and then
- if possible, ask that task_tick_deadline function to be called right=20
  at the time instant I expect my runtime to be depleted. If that won't=20
  happen --because of no-hrtick or no-hires-hrtimers-- the check will
  still be performed during the next tick.

> The whole IPI mess requires USE_GENERIC_SMP_HELPERS, which makes
> CONFIG_HRTICK useful (ensures we have hrtimers enabled and have generic
> IPI bits)
>=20
> The problem is that things like hrtick_enabled() also check
> sched_feat(HRTICK) which is disabled by default (because programming the
> clock hw on each schedule was found too expensive) but that should not
> stop SCHED_DEADLINE from using it.
>=20
Mmm... I might have lost you here... :-(

Do you think that keep using hrtick_start and alike, even if
sched_feat(HRTICK) is disabled, could be good enough? Or are you
suggesting something different?
IOTH, should I simply bypass the sched_feat()/hrtick_enabled() check or
you think I need something more?

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-eN2cqnnqwjUW1aQpW+Gs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktN9ZUACgkQk4XaBE3IOsR/dACfZvUNB+az9AgOZ787ma8bdp7V
jpsAniloRKO8fNVKhyuXn5L3H15kSlkt
=LM2F
-----END PGP SIGNATURE-----

--=-eN2cqnnqwjUW1aQpW+Gs--

