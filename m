Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbZIWMTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbZIWMTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZIWMTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:19:53 -0400
Received: from ms01.sssup.it ([193.205.80.99]:44996 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752354AbZIWMTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:19:52 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: claudio@evidence.eu.com, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <1253644603.18939.25.camel@laptop>
References: <1253615424.20345.76.camel@Palantir>
	 <1253617510.7695.23.camel@twins>  <1253623867.20345.156.camel@Palantir>
	 <1253644603.18939.25.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HNTacQrjAR17KuFh61NS"
Date: Wed, 23 Sep 2009 14:19:52 +0200
Message-Id: <1253708392.5631.408.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HNTacQrjAR17KuFh61NS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-22 at 20:36 +0200, Peter Zijlstra wrote:
> > The, let's say, proper task period is left to the userspace, i.e.,
> > suspending until the next period/sporadic activation is not done in the
> > kernel, it is up to the task.
> > This is the most flexible interface we have been able to design, while
> > trying to reduce the amount of information that has to be added to the
> > minimum... Different ideas are more than welcome. :-)
>=20
> No bright ideas at the moment, but it might be worth-while to describe
> this task model somewhere near sched_param_ex :-)
>
Well, when you have a good point... You have a good point! :-D

> > Well, I think it might be possible, if rt is bandwidth constrained, as
> > it is/it is becoming... Don't you?
>=20
> Ah, the problem I see there is that your minimum deadline gets
> constrained by whatever you configure your SCHED_FIFO bit to, this
> doesn't seem ideal.
>=20
Agree again, not the ideal behaviour... However, as said, I would like
to experiment some more on this, and to (re)read the papers where they
introduces the analysis for EDF-under-RM. :-)

However, I should start thinking moving it upward, should I?

> I would argue that kstopmachine is going to break pretty much
> everything, so a workload that contains one (module unload, cpu-hotplug)
> will not be analyzable.=20
>
Ok, I think most of the people can stand this! :-P

> I'd rather say that anything kstopmachine will violate RT guarantees.
>=20
> As to migrate, I think we can model that as a regular non-preempt
> section (we could actually remove the migrate thread and actually make
> it such).=20
>=20
I see... and do you think one more scheduling class would be needed, or
something like 0 deadline would do the trick?

> > This may be suboptimal and rise at least overhead, clock synchronizatio=
n
> > and locking issue, but I hope, again, it could be a start... A (bad?)
> > solution to compare against, when designing better implementations, at
> > least.
>=20
> Agreed, its a pragmatic starting point, and only by implementing it can
> we evaluate it.
>=20
Hope it will be ready soon...

> > Another thing I would like to have, is a task receiving a SIGXCPU if it
> > misses its deadline, which might happen actually, e.g., if you load an
> > UP system/a CPU more than 100% with EDF tasks.
>=20
> Missing a deadline, and possibly over-running a deadline too.
>=20
> Maybe add a flags field to the sched_param_ex thing ;-)
>=20
Could be done as well... What do you mean by over-running a deadline?

By missing, I mean that at a certain instant t, typically during a
(hr)tick I notice that the scheduling deadline d is <=3D t, which means we
probably are in overload condition, is that the same? Just to
understand... :-)

> > At the current time, I'm just splitting the bandwidth, and nothing more=
.
> > Actually, I also think the solution is the right one, but I would reall=
y
> > like to discuss the issues it raises.
>=20
> Ooh, good point,.. yes we can put some exit hooks in there folding the
> runtime back.
>=20
> An alternative is starting the child out with 0 runtime, and have the
> parent run sched_setscheduler() on it giving us a clear point to run
> admission on.
>=20
I thought this too, we just have to chose whether the 'more natural' or,
let's say 'user friendly', behaviour is...

Thanks again for the comments.

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-HNTacQrjAR17KuFh61NS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq6EmEACgkQk4XaBE3IOsTyqwCbB30aqxTJW++gysQK1RlV44yY
BfYAn3JCoDfm4tQ+89gOmxNwgu0eO0fn
=2Vcf
-----END PGP SIGNATURE-----

--=-HNTacQrjAR17KuFh61NS--

