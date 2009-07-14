Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZGNQsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZGNQsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbZGNQsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:48:38 -0400
Received: from ms01.sssup.it ([193.205.80.99]:36711 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755607AbZGNQsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:48:37 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <4A5C9ABA.9070909@nortel.com>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	 <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir>
	 <4A5C9ABA.9070909@nortel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-a3XbtIbHgMooya90Thxg"
Date: Tue, 14 Jul 2009 18:48:32 +0200
Message-Id: <1247590112.9086.936.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a3XbtIbHgMooya90Thxg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-14 at 08:48 -0600, Chris Friesen wrote:
> Let's call the highest priority task A, while the task holding the lock
> (that A wants) is called B.  Suppose we're on an dual-cpu system.
>=20
Ok.

> According to your proposal above we would have A busy-waiting while B
> runs with A's priority.  When B gives up the lock it gets downgraded and
> A acquires it and continues to run.
>=20
Yes. The first part of my proposal --the "theoretically safe" one.

> Alternately, we could have A blocked waiting for the lock, a separate
> task C running, and B runs with A's priority on the other cpu.  When B
> gives up the lock it gets downgraded and A acquires it and continues to r=
un.
>=20
Right. And this is in my proposal as well.

I'm just saying that the analysis gets more complicated, that some of
the nice properties may be lost, and suggested a first draft of idea to
turn it back to be easy again... With, unfortunately, a lot of flaws in
there yet. :-(

In fact, I'm suggesting that, in the scenario you described, C should be
able to run, but B's budget have to be affected somehow.

> From an overall system perspective we allowed C to make additional
> forward progress, increasing the throughput.
As said, I agre with this from the very beginning of the whole
thing! :-)

>  On the other hand, there
> is a small window where A isn't running and it theoretically should be.
>   If we can bound it, would this window really cause so much difficulty
> to the schedulability analysis?
>=20
Well, I'm not sure right now... I would need to do some math to be!

Remember that all my points are concerned with budgets, i.e., a scenario
where you have some mean to limit the capability of a task to ask for
CPU time over some kind of period.
And here it is where the problem comes since running C instead of having
A busy waiting means:
- that A is actually blocked, as said before;
- that A's budget is not diminished.
And this certainly improves system throughput but may affect its
predictability and, in this particular case, task's isolation among each
other...

Anyway, if you are saying that this could be a possible theory-practice
compromise, well, could be... And I'm open and ready to (try to)
contribute even in a discussion of such kind. :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-a3XbtIbHgMooya90Thxg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpcttoACgkQk4XaBE3IOsSXXQCfXH6qWxbjttUGo5TIwFBeanhS
WYMAn1+blGt2ZWRTfI3Jp2dITKv6ogIi
=idP9
-----END PGP SIGNATURE-----

--=-a3XbtIbHgMooya90Thxg--

