Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbXDXIRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbXDXIRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbXDXIR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:17:28 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:37546 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754589AbXDXIRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:17:13 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [REPORT] cfs-v5 vs sd-0.46
Date: Tue, 24 Apr 2007 10:16:58 +0200
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
References: <200704240938.07482.mgd@technosis.de> <20070424075319.GA30909@elte.hu>
In-Reply-To: <20070424075319.GA30909@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4517838.omb7fcXGQB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704241017.10610.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1177402633;757ec221;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4517838.omb7fcXGQB
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> > What I also don't understand is the difference in load average, sd=20
> > constantly had higher values, the above figures are representative for=
=20
> > the whole log. I don't know which is better though.
>=20
> hm, it's hard from here to tell that. What load average does the vanilla=
=20
> kernel report? I'd take that as a reference.

I will redo this test with sd-0.46, cfs-v5 and mainline later today.

> interesting - CFS has half the context-switch rate of SD. That is=20
> probably because on your workload CFS defaults to longer 'timeslices'=20
> than SD. You can influence the 'timeslice length' under SD via=20
> /proc/sys/kernel/rr_interval (milliseconds units) and under CFS via=20
> /proc/sys/kernel/sched_granularity_ns. On CFS the value is not=20
> necessarily the timeslice length you will observe - for example in your=20
> workload above the granularity is set to 5 msec, but your rescheduling=20
> rate is 13 msecs. SD default to a rr_interval value of 8 msecs, which in=
=20
> your workload produces a timeslice length of 6-7 msecs.
>=20
> so to be totally 'fair' and get the same rescheduling 'granularity' you=20
> should probably lower CFS's sched_granularity_ns to 2 msecs.

I'll change default nice in cfs to -10.

I'm also happy to adjust /proc/sys/kernel/sched_granularity_ns to 2msec.
However checking /proc/sys/kernel/rr_interval reveals it is 16 (msec)
on my system.

Anyway, I'll have to do some urgent other work and won't be able to
do lots of testing until tonight (but then I will).

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart4517838.omb7fcXGQB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGLb0GUYYhyuxDQc4RAg0RAJ9eFbbq4wFoze53DQVRn0Y5krcazgCcCtp1
WNJwe+vVP5bwxg2+WJmd8Hk=
=ERBx
-----END PGP SIGNATURE-----

--nextPart4517838.omb7fcXGQB--
