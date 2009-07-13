Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbZGMQG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbZGMQG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbZGMQG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:06:26 -0400
Received: from ms01.sssup.it ([193.205.80.99]:38672 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756296AbZGMQG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:06:26 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Henrik Austad <henrik@austad.us>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>
In-Reply-To: <1247480080.7529.66.camel@twins>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <1247478955.8107.24.camel@Palantir>
	 <1247480080.7529.66.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ryIXLi2tO2mV3Uj8JAon"
Date: Mon, 13 Jul 2009 18:06:22 +0200
Message-Id: <1247501182.8107.572.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ryIXLi2tO2mV3Uj8JAon
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-13 at 12:14 +0200, Peter Zijlstra wrote:
> > Nice... Only one question, doesn't this impact with task affinity
> > related issues?
>=20
> No :-), well maybe.
>=20
:-D

> Since the task is blocked and will this not actually run, we can place
> it on any CPU, only once it becomes runnable again should we take care
> to place it on a CPU that's part of its affinity mask.
>=20
Well, it's difficult to find an argument against this! :-)

Anyway, maybe if, on some architecture, for some kind of application,
the affinity may have been set to preserve some kind actual cache or
memory locality for the task access pattern, maybe this could be an
issue, couldn't it? :-)
I mean, in some case where being sure of having a task running on a
particular CPU is somehow of paramount importance...

Anyway, I know, I'm just wandering around, I'm not that "affinity
expert" and I'm far from having a real example of the scenario I tried
to describe! :-(

> Of course, underlying this is the question of what to do for
> 'partitioned' tasks sharing a resource. I think we've talked about this
> a few times.
>
Yes, there is a lot of chatting about partitioned task sets where
resource sharing crosses the partition in the literature...

> Since these 'partitioned' tasks do share a resource, they're not really
> all that partitioned,=20
... and I definitely agree with you on that: where's partitioning?
Anyway, I also think that, if that is true, e.g., for user-space
locks/resources, there are resources that two tasks _have_ to share,
even if being partitioned, e.g., when they come to compete, in kernel
space, e.g., for a lock on the virtual terminal... And that's the only
situation where such a problem make sense.

These just to point out one more reason why we are trying something
different (as explained in the other message), and light year far from
saying that the approach you proposed is not the good one!

On the contrary, I think all this make the problem even more
interesting! :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-ryIXLi2tO2mV3Uj8JAon
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpbW3cACgkQk4XaBE3IOsSw1QCfVsFqPAJLQitaiqI1jxWovZNy
SOQAn1mEaatC2VvlANiURnYBGm8aasbf
=T0ia
-----END PGP SIGNATURE-----

--=-ryIXLi2tO2mV3Uj8JAon--

