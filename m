Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbZJPPjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbZJPPjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760567AbZJPPjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:39:37 -0400
Received: from ms01.sssup.it ([193.205.80.99]:49526 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760431AbZJPPjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:39:36 -0400
Subject: [RFC 1/12][PATCH] Extended scheduling parameters structure added.
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
In-Reply-To: <1255707324.6228.448.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fSQKiV1GCtjJhkK/lUqv"
Date: Fri, 16 Oct 2009 17:38:55 +0200
Message-Id: <1255707535.6228.451.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fSQKiV1GCtjJhkK/lUqv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

An extended scheduling parameter structure, sched_param_ex, is defined in
this commit, as the starting point for supporting task models more
sophisticated than fixed-priority.

One that is both popular and (hopefully!) general enough is the so-called
sporadic task model, in which tasks' computation is divided into instances,
each one with:
 * a (maximum/typical) execution time,
 * a minimum interval between the activation of two consecutive instances,
 * a time instant by which the computation of the instance must be complete=
d.

The new sched_param_ex reflects this model, and thus allows for better
specification of time sensitive workloads typical, for example, in real-tim=
e,
control and/or continuous media applications.

Signed-off-by: Raistlin <raistlin@linux.it>
---
 include/linux/sched.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..ac9837c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -94,6 +94,14 @@ struct sched_param {
=20
 #include <asm/processor.h>
=20
+struct sched_param_ex {
+	int sched_priority;
+	struct timespec sched_runtime;
+	struct timespec sched_deadline;
+	struct timespec sched_period;
+	int sched_flags;
+};
+
 struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
--=20
1.6.0.4

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-fSQKiV1GCtjJhkK/lUqv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrYk48ACgkQk4XaBE3IOsRbJgCfVSe9I2hkbsPgIRtmWI/LsikX
yYcAn0r5dsx8Qaaq3k1pnjVHCRj4/aTH
=lop9
-----END PGP SIGNATURE-----

--=-fSQKiV1GCtjJhkK/lUqv--

