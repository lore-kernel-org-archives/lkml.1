Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYAZVib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYAZVib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 16:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbYAZViX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 16:38:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:59631 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753868AbYAZViW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 16:38:22 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/FJGgVm/XFxJUA/wpCCsJbruegYq/dC+SOTME6Dh
	FXz7O+3e75PIKW
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Date: Sat, 26 Jan 2008 22:38:15 +0100
User-Agent: KMail/1.9.7
References: <479B69D2.5050603@wpkg.org>
In-Reply-To: <479B69D2.5050603@wpkg.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10017701.1ml98KHcxf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801262238.19222.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10017701.1ml98KHcxf
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

It seems to be rather a scheduler issue than a governor issue b/c
the issue went away after unsetting CONFIG_FAIR_GROUP_SCHED.

If I unselect CONFIG_FAIR_GROUP_SCHED then the %CPU value raises 80%
=2D which forces the ondemand governor do speed up the CPU frequency:


  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7137 tfoerste  20   0  1796  488  428 R 95.5  0.0   0:01.40 factor
 7083 dnetc     39  19   664  348  264 R  2.1  0.0   3:08.33 dnetc
 4033 root      20   0 97252 9420 4008 R  0.7  0.9   0:09.43 X
=20

Am Samstag, 26. Januar 2008 schrieben Sie:
> Toralf F=C3=B6rster wrote:
>=20
> > I use a 1-liner for a simple performance check : "time factor 819734028=
463158891"
> > Here is the result for the new (Gentoo) kernel 2.6.24:
> >=20
> > With the  ondemand governor of the  I get:
> >=20
> > tfoerste@n22 ~/tmp $ time factor 819734028463158891
> > 819734028463158891: 3 273244676154386297
> >=20
> > real    0m32.997s
> > user    0m15.732s
> > sys     0m0.014s
> >=20
> > With the ondemand governor the CPU runs at 600 MHz,
> > whereas with the performance governor I get :
> >=20
> > tfoerste@n22 ~/tmp $ time factor 819734028463158891
> > 819734028463158891: 3 273244676154386297
> >=20
> > real    0m10.893s
> > user    0m5.444s
> > sys     0m0.000s
> >=20
> > (~5.5 sec as I expected) b/c the CPU is set to 1.7 GHz.
> >=20
> > The ondeman governor of previous kernel versions however automatically =
increased
> > the CPU speed from 600 MHz to 1.7 GHz.
> >=20
> > My system is a ThinkPad T41, I'll attach the .config=20
>=20
> During the test, run top, and watch your CPU usage. Does it go above 80%=
=20
> (the default for=20
> /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold).
>=20
> ondemand CPUfreq governor has a few tunables, described in=20
> Documentation/cpu-freq. One of them is up_threshold:
>=20
> up_threshold: defines what the average CPU usaged between the samplings
> of 'sampling_rate' needs to be for the kernel to make a decision on
> whether it should increase the frequency. For example when it is set
> to its default value of '80' it means that between the checking
> intervals the CPU needs to be on average more than 80% in use to then
> decide that the CPU frequency needs to be increased.
>=20
> What CPUFreq processor driver are you using?
>=20
>=20
> I had a similar problem with CPUfreq and dm-crypt (slow reads), see=20
> (more setup problem than something kernel-related):
>=20
> http://blog.wpkg.org/2008/01/22/cpufreq-and-dm-crypt-performance-problems/
>=20
>=20

=2D-=20
MfG/Sincerely

Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart10017701.1ml98KHcxf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHm6hLhyrlCH22naMRAg74AKChsQiD1aPbAG2jHqTPNDwoOYSJ+QCfRVNf
HTdCYlc0DpCm03l6C0gIzRM=
=qdhe
-----END PGP SIGNATURE-----

--nextPart10017701.1ml98KHcxf--
