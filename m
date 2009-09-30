Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZI3P6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZI3P6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZI3P6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:58:23 -0400
Received: from ms01.sssup.it ([193.205.80.99]:56091 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754265AbZI3P6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:58:21 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Raistlin <raistlin@linux.it>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Henrik Austad <henrik@austad.us>, Peter Zijlstra <peterz@infradead.org>,
       claudio@evidence.eu.com, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <4AC24525.9060607@nortel.com>
References: <1253615424.20345.76.camel@Palantir>
	 <1253623867.20345.156.camel@Palantir> <1253644603.18939.25.camel@laptop>
	 <200909270855.49367.henrik@austad.us> <1254240635.7775.44.camel@Palantir>
	 <4AC24525.9060607@nortel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eTU8UcIe+p/QejskF++s"
Date: Wed, 30 Sep 2009 17:58:26 +0200
Message-Id: <1254326306.11233.147.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eTU8UcIe+p/QejskF++s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-29 at 11:34 -0600, Chris Friesen wrote:
> Basically it boils down to a policy decision...
Yep. I know that, and I know that policies have to be avoided as much as
possible in this lands... :-(

> Personally I don't like the idea of fork() resulting in permanently
> reduced allocation for the parent. =20
Yeah, me neither.

> a) The child should get an identical bandwidth guarantee as the parent
> and if that can't be guaranteed then the fork() should fail, maybe with
> an errno of EBUSY.
>=20
Again, this could be done, pretty easily actually. :-)

> b) The child should start out with no guarantees (SCHED_OTHER nice 0
> maybe?) and should have to request a bandwidth guarantee.  This could
> complicate things in some circumstances because if it can't get the
> guarantee then it needs to inform the parent somehow.
>=20
Ok, I see and agree, again, to many extents.

> Given that any serious users of EDF are likely pretty specialized,
> either one would probably work.  Which is the best policy is a different
> question, and one that I don't have enough experience with to offer an
> opinion.
>=20
Yeah... Maybe, since I'm adding (in the next patch I'm going to send
soon) a flag field in the sched_param_ex structure, we can also use some
of the bits for deciding how the fork will behave... The main problem
would be the code will get more complicated, and we thus would have to
decide if it is worth...

Again, thanks for finding some time to comment.

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-eTU8UcIe+p/QejskF++s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrDgBQACgkQk4XaBE3IOsRoNwCeIqDSp3kJ5sibCpxxZsq0jjB1
lR4AnAnjVY1XqEOPJLiGNStjxirOzs9L
=CHiR
-----END PGP SIGNATURE-----

--=-eTU8UcIe+p/QejskF++s--

