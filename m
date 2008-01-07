Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbYAGRsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbYAGRsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbYAGRsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:48:05 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:63933 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756176AbYAGRsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:48:04 -0500
Subject: Re: [PATCH] kthread: always create the kernel threads with normal
	priority
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Michal Schmidt <mschmidt@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jon Masters <jcm@redhat.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <20080107092956.419b5f91.akpm@linux-foundation.org>
References: <20071217234314.540b59bd@hammerfall>
	 <20071222013021.db2528cb.akpm@linux-foundation.org>
	 <20080107110603.09b72450@brian.englab.brq.redhat.com>
	 <20080107022513.3ac05734.akpm@linux-foundation.org>
	 <20080107110904.GB28481@elte.hu>
	 <20080107092956.419b5f91.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E542zhABk1e5bBzL7D/+"
Date: Mon, 07 Jan 2008 18:47:59 +0100
Message-Id: <1199728079.7143.52.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E542zhABk1e5bBzL7D/+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-01-07 at 09:29 -0800, Andrew Morton wrote:
> On Mon, 7 Jan 2008 12:09:04 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>=20
> >=20
> > > > This causes a practical problem. When a runaway real-time task is=20
> > > > eating 100% CPU and we attempt to put the CPU offline, sometimes we=
=20
> > > > block while waiting for the creation of the highest-priority=20
> > > > "kstopmachine" thread.
> >=20
> > sched-devel.git has new mechanisms against runaway RT tasks. There's a=20
> > new RLIMIT_RTTIME rlimit - if an RT task exceeds that rlimit then it is=
=20
> > sent SIGXCPU.
>=20
> Is that "total RT CPU time" or "elapsed time since last schedule()"?
>=20
> If the former, it is not useful for this problem.
>=20
> > there's also a new group scheduling extension that is driven via a=20
> > sysctl:
> >=20
> >   /proc/sys/kernel/sched_rt_ratio
> >=20
> > this way if a user has a runaway RT task, other users (and root) will=20
> > still have some CPU time left. (in Peter's latest patchset that is=20
> > replaced via rt_runtime_ns - but this is a detail)
>=20
> Doesn't this make the RT task non-RT?  Would need to understand more
> details to tell.

Its an artifact of rt group scheduling. Each group will have to specify
a period and runtime limit therein (and the normalized sum thereof must
not exceed the total time available - otherwise the set is not
schedulable).

So say we have two groups A and B. A has a period of 2 seconds and a
runtime limit of 1, that gives him an avg of 50% cpu time. If B then has
a period of 1 second with a runtime limit of .25s (avg 25%) the total
time required to schedule the realtime groups would be 75% on average.

Without group scheduling everything is considered one group but we still
have the period and runtime limits.

So as long as the realtime cpu usage fits within the given limits it
acts as before. Once it exceeds its limit it will be capped hard - which
is ok, since it exceeded its hard limit, and realtime applications are
supposed to be deterministic and thus be able to tell how much time
they'd require. [ If only this model were true, but its a model
frequently used and quite accepted ]



--=-E542zhABk1e5bBzL7D/+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHgmXPXA2jU0ANEf4RAp4NAJ9vmdRMb80x1QDW1RjweHCKzegkRQCcDdoV
1pwkoo0c9NdDIGTjunVcfjk=
=fKXs
-----END PGP SIGNATURE-----

--=-E542zhABk1e5bBzL7D/+--

