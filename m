Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZILL0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZILL0m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 07:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZILL0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 07:26:41 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36445 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZILL0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 07:26:41 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Sat, 12 Sep 2009 13:26:29 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc7-tp42-toi-3.0.1-04741-g57e61c0; KDE/4.3.1; i686; ; )
Cc: Mat <jackdachef@gmail.com>
References: <20090906205952.GA6516@elte.hu> <200909102319.36524.Martin@lichtvoll.de> <loom.20090911T111945-871@post.gmane.org> (sfid-20090912_124409_718115_F3C1DF2C)
In-Reply-To: <loom.20090911T111945-871@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1950431.QEMPu0zUHs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909121326.38400.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1950431.QEMPu0zUHs
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Freitag 11 September 2009 schrieb Mat:
> Martin Steigerwald <Martin <at> lichtvoll.de> writes:
> > Am Donnerstag 10 September 2009 schrieb Ingo Molnar:
>=20
> [snip]
>=20
> > > what is /debug/sched_features - is NO_NEW_FAIR_SLEEPERS set? If not
> > > set yet then try it:
> > >
> > >   echo NO_NEW_FAIR_SLEEPERS > /debug/sched_features
> > >
> > > that too might make things more fluid.
>=20
> Hi Martin,

Hi Mat,

> it made an tremendous difference which still has to be tested out :)

[...]

> Concerning that "NO_NEW_FAIR_SLEEPERS" switch - isn't it as easy as to
>=20
> do the following ? (I'm not sure if there's supposed to be another
>  debug)
>=20
> echo NO_NEW_FAIR_SLEEPERS > /sys/kernel/debug/sched_features
>=20
> which after the change says:
>=20
> cat /sys/kernel/debug/sched_features
> NO_NEW_FAIR_SLEEPERS NO_NORMALIZED_SLEEPER ADAPTIVE_GRAN WAKEUP_PREEMPT
> START_DEBIT AFFINE_WAKEUPS CACHE_HOT_BUDDY SYNC_WAKEUPS NO_HRTICK
>  NO_DOUBLE_TICK ASYM_GRAN LB_BIAS LB_WAKEUP_UPDATE ASYM_EFF_LOAD
>  NO_WAKEUP_OVERLAP LAST_BUDDY OWNER_SPIN
>=20
> I hope that's the correct switch ^^

Thanks. Appears to work here nicely ;-). I thought this might be a debug=20
fs that I need to mount separately, but its already there here. I will see=
=20
how it works out.

I wondered whethere it might be a good idea to have a

echo default >  /sys/kernel/kernel-tuning-knob

that will reset it to the compiled in factory defaults. Would be a nice=20
way to go back to safe settings again once you got carried away to far=20
with trying those tuning knobs.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1950431.QEMPu0zUHs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqrhWUACgkQmRvqrKWZhMd1KgCgiS8b4AJpOhsky5lJ0l95+oUG
NIsAnixZrs362Y3xXGYBP7sMh2UUxfoc
=xpYg
-----END PGP SIGNATURE-----

--nextPart1950431.QEMPu0zUHs--
