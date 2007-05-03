Return-Path: <linux-kernel-owner+w=401wt.eu-S1161872AbXECMqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161872AbXECMqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161873AbXECMqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:46:09 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:47598 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161872AbXECMqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:46:06 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [REPORT] 2.6.21.1 vs 2.6.21-sd046 vs 2.6.21-cfs-v6
Date: Thu, 3 May 2007 14:45:45 +0200
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
References: <200704301005.33884.mgd@technosis.de> <20070503122851.GA32222@elte.hu>
In-Reply-To: <20070503122851.GA32222@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3411527.rI3Y2aZGUZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705031445.58178.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1178196366;1bdbc252;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3411527.rI3Y2aZGUZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> regarding the fairness of the different schedulers, please note the=20
> different runtimes for each component of the workload:
>=20
>      LTMM:   5655.07/ 5682
>      LTMB:   7729.81/ 7755
>      LTBM:   7720.70/ 7746
>=20
> this means that a fair scheduler would _not_ be the one that finishes=20
> them first on wall-clock time (!). A fair scheduler would run each of=20
> them at 33% capacity until the fastest one (LTMM) reaches ~5650 seconds=20
> runtime and finishes, and _then_ the remaining ~2050 seconds of runtime=20
> would be done at 50%/50% capacity between the remaining two jobs. I.e.=20
> the fair wall-clock results should be around:
>=20
>     LTMM:  ~8500 seconds
>     LTMB: ~10600 seconds=20
>     LTBM: ~10600 seconds
>=20
> (but the IO portion of the workloads and other scheduling effects could=20
> easily shift these numbers by a few minutes.)

Correct. I will try to cook up some statistics for the next round
of results (been redoing cfs-v6, done cfs-v7 and then redone it
because of strange results and hopefully will do cfs-v8 tonight
as well as sd048 during the next days -- not easy to keep up with
you guys rolling out new versions ;-)

> regarding the results: it seems the wallclock portion of LTMM/j3 is too=20
> small - even though the 3 tasks ran in parallel, in the CFS test LTMM=20
> finished just as fast as if it were running alone, right?

Right. I'm really very surprised but this remained while redoing both
LTMM/j1 (twice!) and LTMM/j3 with cfs-v6.

I don't really understand that and now think it shows some hidden
"fairness deficiency" that hopefully is corrected in cfs-v8. At least
cfs-v7 did behave differently.

> That does not =20
> seem to be logical and indeed suggests some sort of testing artifact.

Since it doesn't appear with any other scheduler tested I'd not rule
out a feature of the code.

> That makes it hard to judge which scheduler achieved the above 'ideal=20
> fair distribution' of the workloads better - for some of the results it=20
> was SD, for some it was CFS - but the missing LTMM/j3 number makes it=20
> hard to decide it conclusively. They are certainly both close enough and=
=20
> the noise of the results seems quite high.

Oh, I'm confident both are excellent scheduler. On the other hand
I find mainline isn't that bad either, at least for this type of
load.

Anyway, as I wrote above I'm continuing my tests and am collecting
data for the various scheduler. Presumably over the weekend I'll
mail out the next round.

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart3411527.rI3Y2aZGUZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGOdmGUYYhyuxDQc4RAp8jAJsFedtIjSkpKBZpikYO7WZPULXPywCfZvpI
dmDgnfzwW67ji4OVn0oiwcw=
=gi1p
-----END PGP SIGNATURE-----

--nextPart3411527.rI3Y2aZGUZ--
