Return-Path: <linux-kernel-owner+w=401wt.eu-S1762664AbXE2RYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762664AbXE2RYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759790AbXE2RYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:24:05 -0400
Received: from daemonizer.de ([87.230.16.230]:49367 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760313AbXE2RYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:24:01 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: "Gary Zambrano" <zambrano@broadcom.com>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Tue, 29 May 2007 19:23:22 +0200
User-Agent: KMail/1.9.7
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Michael Buesch" <mb@bu3sch.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Jeff Garzik" <jgarzik@pobox.com>, netdev@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705282255.56490.maxi@daemonizer.de> <1180447123.17146.4.camel@dhcp-10-12-136-115.broadcom.com>
In-Reply-To: <1180447123.17146.4.camel@dhcp-10-12-136-115.broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4060505.77Nsh39oUo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705291923.26438.maxi@daemonizer.de>
X-Spam-Score: -4.1 (----)
X-Spam-Report: No, hits=-4.1 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.1.7-deb 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.3 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4060505.77Nsh39oUo
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 29 May 2007, Gary Zambrano wrote:
> On Mon, 2007-05-28 at 13:55 -0700, Maximilian Engelhardt wrote:
> > On Monday 28 May 2007, Thomas Gleixner wrote:
> > > On Mon, 2007-05-28 at 19:44 +0200, Maximilian Engelhardt wrote:
> > > > > Can you please keep CONFIG_HIGH_RES_TIMERS and CONFIG_NOHZ and try
> > > > > the following combinations on the kernel command line:
> > > > >
> > > > > 1) highres=3Doff nohz=3Doff (should be the same as your working c=
onfig)
> > > > > 2) highres=3Doff
> > > > > 3) nohz=3Doff
> > > >
> > > > I tested this with my 2.6.22-rc3 kernel, here are the results:
> > > >
> > > > without any special boot parameters: problem does appear
> > > > highres=3Doff nohz=3Doff: problem does not appear
> > > > highres=3Doff: problem does not appear
> > > > nohz=3Doff: problem does appear
> > >
> > > Is there any other strange behavior of the high res enabled kernel th=
an
> > > the b44 problem ?
> >
> > I didn't notice anything.
> >
> > > > I additionally built my 2.6.22-rc2-mm1 kernel without High Resoluti=
on
> > > > Timer, but the high ping problem is still there.
> > >
> > > Hmm, that's mysterious. Wild guess is that highres exposes the hidden
> > > "feature" in a different way than rc2-mm1 does.
> >
> > I think the bug in 2.6.21/22-rc3 is a different one that the one in
> > 2.6.22-rc2-mm1, but that's also only a wild guess :)
> >
> > I'll explain this a bit:
> > In 2.6.21/22-rc3 is the same b44 driver that has been in the stock
> > kernels for some time. With this driver and High Resolution Timer turned
> > on I get problems using iperf. The problems are that the systems becomes
> > really slow and unresponsive.  Michael Buesch thought this could be an
> > IRQ storm which sounds logical to me. This bug did never happen to me
> > before I startet the iperf test.
>
> Can you please check to see if you notice anything out of the ordinary
> using netperf in place of iperf in your high res timer on/off testbed?

ok, here are the results, I also had a look at the cpu kernel usage.
'good' means that the kernel responsiveness during the test was as I would=
=20
expect it and I didn't notice any problems.

highres enabled:

netperf: 80%sy 15%si (good)
iperf: not really messureable (bad, problem described above)

highres disabled:

netperf: 80%sy 15%si (good)
iperf:  5%sy 30%hi 15%si (good)


for test tests I did run the following commands:
netperf -l 60 192.168.1.1
iperf -c 192.168.1.1 -r -t 60

I also tried to run iperf without any additional arguments (iperf -c=20
192.168.1.1) on the problematic kernel but the result is the same as the=20
command I wrote above.

Maxi

--nextPart4060505.77Nsh39oUo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXGGOOimwv528XGERAsw/AJ4m3Q0hahe28KIFZwtueQqHyE0kagCePF//
6jyHP5GW0uXcLTRFci3rXoU=
=8pPH
-----END PGP SIGNATURE-----

--nextPart4060505.77Nsh39oUo--
