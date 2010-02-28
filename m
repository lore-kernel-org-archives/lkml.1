Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936469Ab0B1TQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:16:11 -0500
Received: from ms01.sssup.it ([193.205.80.99]:42252 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936424Ab0B1TQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:16:06 -0500
Subject: [RFC][PATCH 01/11] sched: add sched_class->task_dead.
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>, Henrik Austad <henrik@austad.us>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@retis.sssup.it>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>,
       Nicola Manica <nicola.manica@gmail.com>,
       Luca Abeni <luca.abeni@unitn.it>
In-Reply-To: <1267383976.13676.79.camel@Palantir>
References: <1267383976.13676.79.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-J8Nsgp3aj1Ed0LHf70In"
Date: Sun, 28 Feb 2010 20:15:57 +0100
Message-ID: <1267384557.13676.85.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-J8Nsgp3aj1Ed0LHf70In
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add a new function to the scheduling class interface. It is called
at the end of a cointext switch, if the going out task is in
TASK_DEAD state.

It might be of help in case the scheduling class wants to be
notified when one of its task dies, e.g. to perform some
cleanup actions.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78efe7c..d1de995 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1119,6 +1119,7 @@ struct sched_class {
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_fork) (struct task_struct *p);
+	void (*task_dead) (struct task_struct *p);
=20
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
 			       int running);
diff --git a/kernel/sched.c b/kernel/sched.c
index 3a8fb30..532dcf1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2801,6 +2801,8 @@ static void finish_task_switch(struct rq *rq, struct =
task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state =3D=3D TASK_DEAD)) {
+		if (prev->sched_class->task_dead)
+			prev->sched_class->task_dead(prev);
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
--=20
1.7.0

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-J8Nsgp3aj1Ed0LHf70In
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuKwO0ACgkQk4XaBE3IOsRKOQCfUaMd9W+OSkDL6dqHSbqta928
V8cAnjc/jR7xw8uDtIDva+T3cs8A+TqR
=x1Ws
-----END PGP SIGNATURE-----

--=-J8Nsgp3aj1Ed0LHf70In--

