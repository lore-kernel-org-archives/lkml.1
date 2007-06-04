Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbXFDUxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbXFDUxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbXFDUxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:53:32 -0400
Received: from daemonizer.de ([87.230.16.230]:38432 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbXFDUxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:53:30 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: iperf: performance regression (was b44 driver problem?)
Date: Mon, 4 Jun 2007 22:52:36 +0200
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@gmail.com>, Michael Buesch <mb@bu3sch.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200706042148.02450.maxi@daemonizer.de> <20070604130225.08e45b72@freepuppy>
In-Reply-To: <20070604130225.08e45b72@freepuppy>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1781395.qdN5C00hYe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706042252.40025.maxi@daemonizer.de>
X-Spam-Score: -4.2 (----)
X-Spam-Report: No, hits=-4.2 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.1.7-deb 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.2 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1781395.qdN5C00hYe
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 04 June 2007, Stephen Hemminger wrote:
> On Mon, 4 Jun 2007 21:47:59 +0200
>
> Maximilian Engelhardt <maxi@daemonizer.de> wrote:
> > On Monday 04 June 2007, Ingo Molnar wrote:
> > > * Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > > > Yes, the following patch makes iperf work better than ever. But are
> > > > other broken applications going to have same problem. Sounds like t=
he
> > > > old "who runs first" fork() problems.
> > >
> > > this is the first such app and really, and even for this app: i've be=
en
> > > frequently running iperf on -rt kernels for _years_ and never noticed
> > > how buggy its 'locking' code was, and that it would under some
> > > circumstances use up the whole CPU on high-res timers.
> >
> > I must admit I don't know much about that topic, but there is one thing=
 I
> > don't understand. Why is iperf (even if it's buggy) able to use up the
> > whole cpu? I didn't run it as root but as my normal user so it should
> > have limited rights. Shouldn't the linux scheduler distribute cpu time
> > among all running processes?
>
> In this case, there are two threads. One is receiving data and the other
> is spinning checking on progress. If the spinning thread doesn't yield,
> it will end up using it's whole quantum (10ms at 100hz), before the
> scheduler lets the receiver run again. If the receiving thread doesn't
> get to run then on a UP the performance stinks.
>
Ok, let's see if I got this right:
If there are other processes that want cpu time they will get it after the=
=20
quantum for the iperf thread is used up. So cpu time will be distributed=20
among other processes, but it takes some time until they get it and this=20
increases latency.

> The problem only showed up laptop because most of my other systems are
> SMP (or fake SMP/HT), and usually set HZ to 1000 not 100.

Hm, on my laptop (Pentium M) I have configured CONFIG_HZ_300 and CONFIG_NO_=
HZ.
On my desktop PC (Athlon 2000+, also UP) I also have CONFIG_HZ_300 and=20
CONFIG_NO_HZ but didn't notice the problem.

Maxi

--nextPart1781395.qdN5C00hYe
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGZHuXOimwv528XGERArEsAKDgMGu94r/glT+KaM30/ryWhocb3QCgsxPc
ENx/hbwtIaDWZCeEcpHEjRk=
=Yhkf
-----END PGP SIGNATURE-----

--nextPart1781395.qdN5C00hYe--
