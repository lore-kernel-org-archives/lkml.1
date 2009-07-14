Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZGNTIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZGNTIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZGNTIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:08:01 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54265 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751522AbZGNTIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:08:00 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Noah Watkins <jayhawk@soe.ucsc.edu>, Douglas Niehaus <niehaus@ittc.ku.edu>,
       Henrik Austad <henrik@austad.us>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1247562912.7500.78.camel@twins>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop>  <1247499843.8107.548.camel@Palantir>
	 <1247505941.7500.39.camel@twins>
	 <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>
	 <1247562912.7500.78.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FL2phsTfXDbtORV5FVnf"
Date: Tue, 14 Jul 2009 21:07:15 +0200
Message-Id: <1247598435.4839.92.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FL2phsTfXDbtORV5FVnf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-14 at 11:15 +0200, Peter Zijlstra wrote:=20
> > Regarding the notion of charging proxy execution to the budget of
> > the client task, I have grave concerns. It is already hard enough
> > to estimate the amount of budget that a real-time task requires,
> > without this additional complication.=20
>=20
> I hope the above illustrates the use of this, furthermore I think Dario
> and team did some actual analysis on it wrt deadline schedulers. Dario
> could you expand?
>=20
Sure, I can try, again! :-)

I think what I said trying to answer Chris is of same help here as well,
and that it already clarified things at least a little bit. Does it?

Anyway, I think we are looking at the problem from slightly different
points standpoints.
I definitely agree with Prof. Baker with the fact that estimating
execution times is very difficult, and I think this extends to the
estimation of durations of critical sections too.

Moreover, there are scenarios where you don't really need strong
knowledge of these time intervals because, e.g., you are mainly
interested in:
 - providing an applications/components with some kind of quality of=20
   service --i.e., not hard real-time-- guarantees;
 - isolate the applications/components among themselves.
This is, I think, quite typical for soft real-time workloads that could
run on Linux, better if preempt-rt, without many problems.

With this in mind, what we think is interesting of BWI-like approaches
is, indeed, that they do require virtually no knowledge about tasks'
behaviour, at least to provide timing isolation... No tasks' wcet, no
tasks' accessed mutexes, no tasks' blocking times: just a budget and a
period of a server/group each application is enclosed within.
This is of some relevance, we think, not only in the real-time world,
but also when robustness, availability and dependability starts being
considered.

I think I already said how the thing basically works, and I don't want
to bother you all by explaining it again, unless you ask me for some
clarification... All I can add is that going this way is, actually,
moving toward trying to _remove_ the need of having exact prediction of
task execution and blocking.

Finally, but I already said this as well, if you need hard behaviour and
you have the data about tasks' wcet and blocking times, the paper I
pointed to (the last mail, with working links! :-D) contain all it is
needed to compute the group's budget properly taking into account
interferences... It is, brutally simplifying, something like using as
budget for task A's group the sum of A's wcet plus all the blocking
times of tasks that blocks on it.

And Peter is right, such analysis is done for EDF on UP configurations.
Finally, I unfortunately am not able to provide any clue on how this
applies to fair schedulers (e.g., SFQ/CFS), but don't think it's
impossible... :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-FL2phsTfXDbtORV5FVnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpc12MACgkQk4XaBE3IOsQHhgCeMXTwk76/XrE5BPMDgRyf0LT4
0VwAnRzpHHG0cKGJNWIRNyiDwkkOFXCd
=eUZF
-----END PGP SIGNATURE-----

--=-FL2phsTfXDbtORV5FVnf--

