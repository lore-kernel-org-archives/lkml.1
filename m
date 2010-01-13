Return-Path: <linux-kernel-owner+w=401wt.eu-S932149Ab0AMQ26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0AMQ26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696Ab0AMQ26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:28:58 -0500
Received: from ms01.sssup.it ([193.205.80.99]:33133 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755431Ab0AMQ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:28:57 -0500
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: fork and terminate task logic
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
In-Reply-To: <1263399311.4244.230.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707661.6228.455.camel@Palantir>  <1262100041.7135.157.camel@laptop>
	 <1263381067.3853.103.camel@Palantir>  <1263399311.4244.230.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rifg5ctmIn1FqvSh0IH4"
Date: Wed, 13 Jan 2010 17:28:54 +0100
Message-ID: <1263400134.3853.283.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rifg5ctmIn1FqvSh0IH4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-13 at 17:15 +0100, Peter Zijlstra wrote:
> On Wed, 2010-01-13 at 12:11 +0100, Raistlin wrote:
>=20
> > > > +       } else if (rt_prio(p->prio))
> > > > +               p->sched_class =3D &rt_sched_class;
> > > > +       else
> > > >                 p->sched_class =3D &fair_sched_class;
> > > > =20
> > > >  #ifdef CONFIG_SMP
> > > > @@ -2744,6 +2756,10 @@ static void finish_task_switch(struct rq *rq=
, struct task_struct *prev)
> > > >         if (mm)
> > > >                 mmdrop(mm);
> > > >         if (unlikely(prev_state =3D=3D TASK_DEAD)) {
> > > > +               /* a deadline task is dying: stop the bandwidth tim=
er */
> > > > +               if (deadline_task(prev))
> > > > +                       hrtimer_cancel(&prev->dl.dl_timer);
> > > > +
> > > >                 /*
> > > >                  * Remove function-return probe instances associate=
d with this
> > > >                  * task and put them back on the free list.=20
> > >=20
> > > Shouldn't this be done in the ->dequeue_task() callback?
> > >
> > Not sure of this snippet... Actually, it is one of the most disturbing
> > piece of code of this whole scheduler. :-(
> >=20
> > The reason why it is here is that I think it is needed to call
> > hrtimer_cancel() _without_ holding the rq->lock, is that correct?
>=20
> I think we can nest the hrtimer base lock inside the rq->lock these
> days, so it should be safe to call while holding it, anyway, lockdep
> will quickly tell you if you try ;-)
>=20
Nice, I'll try this soon, thanks.

> > It is=20
>=20
> Is that a stmt or an unfinished sentence?
>=20
No, this is nothing, sorry! :-P

Regards,
Dario


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-rifg5ctmIn1FqvSh0IH4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktN9MYACgkQk4XaBE3IOsQipgCdGOD0vqXjB95RkOVMEzHXlBEk
qEUAn0NTlYBTDXkx79HkWwHt88SEw7tI
=s3ve
-----END PGP SIGNATURE-----

--=-rifg5ctmIn1FqvSh0IH4--

