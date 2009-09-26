Return-Path: <linux-kernel-owner+w=401wt.eu-S1751176AbZIZGud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbZIZGud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 02:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbZIZGuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 02:50:32 -0400
Received: from ms01.sssup.it ([193.205.80.99]:52190 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750843AbZIZGuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 02:50:32 -0400
Subject: Re: massive_intr on CFS, BFS, and EDF
From: Raistlin <raistlin@linux.it>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       sat <takeuchi_satoru@jp.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4ABD36CE.3080400@nortel.com>
References: <4ABC068A.6070704@jp.fujitsu.com>
	 <4ABCEABC.4050200@gandalf.sssup.it>  <4ABD36CE.3080400@nortel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LQH16N3vXJ/LlUGcw5f3"
Date: Sat, 26 Sep 2009 08:50:26 +0200
Message-Id: <1253947826.4924.9.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LQH16N3vXJ/LlUGcw5f3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-09-25 at 15:31 -0600, Chris Friesen wrote:
> Do you allow oversubscription with EDF?  It would seem so based on these
> results.  Would it maybe make sense to disallow oversubscription, or
> make it an option?
>=20
What I want is the user to be able to achieve whatever result he likes.

Thus, with EDF_GROUP_SCHED enabled, you first have to assign a bandwidth
value, at least to the root group. If 100% (e.g., on UP) is used as such
value, oversubscription will never happen.

If EDF_GROUP_SCHED is off, nothing is in place right now, but I already
planned to add it, and I'm just introducing something like
sysctl_sched_rt_runtime, sysctl_sched_rt_period, in the new version I'm
working on right now.

> If you have massive oversubscription with EDF, what is the design
> intent?  Do you try to meet the goals on as many tasks as possible,
> while the oversubscribed tasks get nothing?
>=20
No, nothing like that... So using this scheduler without avoiding system
overload will be nonsene, unless some kind of logic (as you was
describing) is not implemented in userspace, and that's why I think
oversubscription avoidance should be an available, but also,
configurrable feature... Comments on that?

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-LQH16N3vXJ/LlUGcw5f3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq9uaAACgkQk4XaBE3IOsTjSQCfVInckr8C39YWhDgcad1ZZ92p
iIcAmwXGZq4G95IVYpvVifozCN5ZVrJA
=XfRP
-----END PGP SIGNATURE-----

--=-LQH16N3vXJ/LlUGcw5f3--

