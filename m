Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbXDZNWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbXDZNWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbXDZNWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:22:48 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:51686 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672AbXDZNWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:22:46 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [REPORT] cfs-v6-rc2 vs sd-0.46 vs 2.6.21-rc7
Date: Thu, 26 Apr 2007 15:22:28 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>, ck list <ck@vds.kolivas.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
References: <200704261312.25571.mgd@technosis.de> <20070426120723.GA4092@elte.hu>
In-Reply-To: <20070426120723.GA4092@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1698765.oImTP26FQD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704261522.43347.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1177593765;7b82eecc;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1698765.oImTP26FQD
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> as a summary: i think your numbers demonstrate it nicely that the=20
> shorter 'timeslice length' that both CFS and SD utilizes does not have a=
=20
> measurable negative impact on your workload.

That's my impression as well. In particular I think that for this
type of workload it is pretty much irrelevant which scheduler I'm
using :-)

> To measure the total impact =20
> of 'timeslicing' you might want to try the exact same workload with a=20
> much higher 'timeslice length' of say 400 msecs, via:
>=20
>     echo 400000000 > /proc/sys/kernel/sched_granularity_ns  # on CFS
>     echo 400 > /proc/sys/kernel/rr_interval                 # on SD

I just finished building cfs and sd against 2.6.21 and will try with
these over the next days.

> your existing numbers are a bit hard to analyze because the 3 workloads=20
> were started at the same time and they overlapped differently and=20
> utilized the system differently.

Right. However the differences w/r to which job finished when, in
particular the change in who "came in" 2. and 3. between sd and cfs
had been consistent with other similar such jobs I ran over the last
couple of days.

In general sd tends to finish all three such jobs at roughly the
same time while cfs clearly "favors" the LTMM-type jobs (which
admittedly involve the least computations). I don't really know
why that is so. However the jobs does some minimal I/O after each
successfully finish run and that might be different w/r to sd and
cfs. Not really knowing what both scheduler do internally I'm in
no position to discuss that with either you or Con :)

> i think the primary number that makes sense to look at (which is perhaps=
=20
> the least sensitive to the 'overlap effect') is the 'combined user times=
=20
> of all 3 workloads' (in order of performance):
>=20
> > 2.6.21-rc7:                              20589.423    100.00%
> > 2.6.21-rc7-cfs-v6-rc2 (X @ nice -10):    20613.845     99.88%
> > 2.6.21-rc7-sd046:                        20617.945     99.86%
> > 2.6.21-rc7-cfs-v6-rc2 (X @ nice 0):      20743.564     99.25%
>=20
> to me this gives the impression that it's all "within noise".

I think so too. But then I didn't seriously expect any different.

> In =20
> particular the two CFS results suggest that there's at least a ~100=20
> seconds noise in these results, because the renicing of X should have no=
=20
> impact on the result (the workloads are pure number-crunchers, and all=20
> use up the CPUs 100%, correct?),

Correct.

The differences could as well result from small fluctuations in my
work on the machine during the test (like reading mail, editing sources
and similar stuff).

> another (perhaps less reliable) number is the total wall-clock runtime=20
> of all 3 jobs. Provided i did not make any mistakes in my calculations,=20
> here are the results:
>=20
> > 2.6.21-rc7-sd046:                        10512.611 seconds
> > 2.6.21-rc7-cfs-v6-rc2 (X @ nice -10):    10605.946 seconds
> > 2.6.21-rc7:                              10650.535 seconds
> > 2.6.21-rc7-cfs-v6-rc2 (X @ nice 0):      10788.125 seconds
>=20
> (the numbers are lower than the first numbers because this is a 2 CPU=20
> system)
>=20
> both SD and CFS-nice-10 was faster than mainline, but i'd say this too=20
> is noise - especially because this result highly depends on the way the=20
> workloads overlap in general, which seems to be different for SD.

I don't think that's noise. As I wrote above IMO this is the one
difference I personally consider significant. While running I could
watch intermediate output of all 3 jobs intermixed on a console.

With sd the jobs were -within reason- head to head while with cfs
and mainline LTMM quickly got ahead and remained there.

As I speculated above this (IMO real) difference in the way sd and
cfs (and mainline) schedule the jobs might be related to the way
the schedulers react on I/O but I don't know.

> system time is interesting too:
>=20
> > 2.6.21-rc7:                              35.379
> > 2.6.21-rc7-cfs-v6-rc2 (X @ nice -10):    40.399
> > 2.6.21-rc7-cfs-v6-rc2 (X @ nice 0):      44.239
> > 2.6.21-rc7-sd046:                        45.515

Over the weekend I might try to repeat these tests while doing
nothing else on the machine (i.e. no editing or reading mail).

> combined system+user time:
>=20
> > 2.6.21-rc7:                              20624.802
> > 2.6.21-rc7-cfs-v6-rc2 (X @ nice 0):      20658.084
> > 2.6.21-rc7-sd046:                        20663.460
> > 2.6.21-rc7-cfs-v6-rc2 (X @ nice -10):    20783.963
>=20
> perhaps it might make more sense to run the workloads serialized, to=20
> have better comparabality of the individual workloads. (on a real system=
=20
> you'd naturally want to overlap these workloads to utilize the CPUs, so=20
> the numbers you did are very relevant too.)

Yes. In fact the workloads used to be run serialized and only
recently I tried to easily have them run on multicore systems.

The whole set of such jobs consists of 312 tasks and thus the
idea is to get a couple of PS3 and have them run there...
(once I found the time to port the software).

> The vmstat suggested there is occasional idle time in the system - is=20
> the workload IO-bound (or memory bound) in those cases?

There is writing out stats after each run (i.e. every 5-8 sec) both
to the PostgreSQL DB as well as to the console.

I could get rid of the console I/O (i.e. make it conditional) and
for testing purpose could switch off the DB if that would make be
helpful.

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart1698765.oImTP26FQD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGMKejUYYhyuxDQc4RAsUFAJ4pJqz9OEEm0vZiyrQWde9GS54CLQCcCB4j
7fM6D/QFiY3e5B1qNdJpAn4=
=4XBz
-----END PGP SIGNATURE-----

--nextPart1698765.oImTP26FQD--
