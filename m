Return-Path: <linux-kernel-owner+w=401wt.eu-S1763861AbXGKMRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763861AbXGKMRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760739AbXGKMRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:17:03 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:54074 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758967AbXGKMRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:17:01 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 22:17:18 +1000
User-Agent: KMail/1.9.6
Cc: rjw@sisk.pl, a1426z@gawab.com, jeremy@goop.org, jbms@cmu.edu, pavel@ucw.cz,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707112200.43613.nigel@nigel.suspend2.net> <E1I8b0l-0000DB-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I8b0l-0000DB-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3194981.oKP9ORUtj3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707112217.19220.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3194981.oKP9ORUtj3
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Wednesday 11 July 2007 22:09:39 Miklos Szeredi wrote:
> > > Freezing of tasks is slowing down suspend.  Don't know how serious
> > > this is, suspend is pretty fast, but could possibly be even faster.
> >=20
> > It's FUD. Freezing of tasks normally takes next to no time. I've never=
=20
> > understood the rediculously long timeout it has. If freezing succeeds, =
all=20
> > processes are frozen within 1/2 a second tops. If it fails, nothing is=
=20
going=20
> > to change in the following 19.5 seconds (or whatever it is if I don't=20
> > remember the value properly).
>=20
> Right.  The 20s timeout is again a sign of brokenness.
>=20
> If we expect something to fail, it should fail immediately, without
> waiting for arbitrary timeouts.
>=20
> And if we don't expect it to fail, why the timeout?

Two reasons:

1) The processing does take time. We're sending (pseudo-)signals to other=20
processes, and the amount of time it will take for them to enter the=20
refrigerator will depend upon the number of processes there are, the=20
scheduling algorithm being used, the rate at which they're forking and what=
=20
other activity is occuring. That's why I said "normally" above.

2) Things do get broken. New functionality gets added which sometimes doesn=
't=20
immediately play well with the freezer. In such cases, we want to fail nice=
ly=20
rather than wrongly assuming it will always work and waiting indefinitely.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart3194981.oKP9ORUtj3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGlMpPN0y+n1M3mo0RAqtEAJ9Vbzuig+b5+SPuENvp4Vtp4PhOqwCggxKI
s6qrdNCp9/X4WclOqpCoPFY=
=Oqee
-----END PGP SIGNATURE-----

--nextPart3194981.oKP9ORUtj3--
