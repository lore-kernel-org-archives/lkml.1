Return-Path: <linux-kernel-owner+w=401wt.eu-S1161691AbXDXHiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161691AbXDXHiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161694AbXDXHiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:38:15 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:50329 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161691AbXDXHiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:38:14 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: linux-kernel@vger.kernel.org
Subject: [REPORT] cfs-v5 vs sd-0.46
Date: Tue, 24 Apr 2007 09:37:54 +0200
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>, ck list <ck@vds.kolivas.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1184117.Bt153Eetd2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704240938.07482.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1177400293;0d7101b2;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1184117.Bt153Eetd2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi list,

with cfs-v5 finally booting on my machine I have run my daily
numbercrunching jobs on both cfs-v5 and sd-0.46, 2.6.21-v7 on
top of a stock openSUSE 10.2 (X86_64). Config for both kernel
is the same except for the X boost option in cfs-v5 which on
my system didn't work (X still was @ -19; I understand this will
be fixed in -v6). HZ is 250 in both.

System is a Dell XPS M1710, Intel Core2 2.33GHz, 4GB,
NVIDIA GeForce Go 7950 GTX with proprietary driver 1.0-9755

I'm running three single threaded perl scripts that do double
precision floating point math with little i/o after initially
loading the data.

Both cfs and sd showed very similar behavior when monitored in top.
I'll show more or less representative excerpt from a 10 minutes
log, delay 3sec.

sd-0.46
top - 00:14:24 up  1:17,  9 users,  load average: 4.79, 4.95, 4.80
Tasks:   3 total,   3 running,   0 sleeping,   0 stopped,   0 zombie
Cpu(s): 99.8%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.2%hi,  0.0%si,  0.0=
%st
Mem:   3348628k total,  1648560k used,  1700068k free,    64392k buffers
Swap:  2097144k total,        0k used,  2097144k free,   828204k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND       =
                                                                           =
                                                          =20
 6671 mgd       33   0 95508  22m 3652 R  100  0.7  44:28.11 perl          =
                                                                           =
                                                          =20
 6669 mgd       31   0 95176  22m 3652 R   50  0.7  43:50.02 perl          =
                                                                           =
                                                          =20
 6674
 mgd       31   0 95368  22m 3652 R   50  0.7  47:55.29 perl               =
                                                                           =
                                                     =20

cfs-v5
top - 08:07:50 up 21 min,  9 users,  load average: 4.13, 4.16, 3.23
Tasks:   3 total,   3 running,   0 sleeping,   0 stopped,   0 zombie
Cpu(s): 99.5%us,  0.2%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.3%si,  0.0=
%st
Mem:   3348624k total,  1193500k used,  2155124k free,    32516k buffers
Swap:  2097144k total,        0k used,  2097144k free,   545568k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND       =
                                                                           =
                                                          =20
 6357 mgd       20   0 92024  19m 3652 R  100  0.6   8:54.21 perl          =
                                                                           =
                                                          =20
 6356 mgd       20   0 91652  18m 3652 R   50  0.6  10:35.52 perl          =
                                                                           =
                                                          =20
 6359 mgd       20   0 91700  18m 3652 R   50  0.6   8:47.32 perl          =
                                                                           =
                                                          =20

What did surprise me is that cpu utilization had been spread 100/50/50
(round robin) most of the time. I did expect 66/66/66 or so.

What I also don't understand is the difference in load average, sd
constantly had higher values, the above figures are representative
for the whole log. I don't know which is better though.


Here are excerpts from a concurrently run vmstat 3 200:

sd-0.46
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu--=
=2D-
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa
 5  0      0 1702928  63664 827876    0    0     0    67  458 1350 100  0  =
0  0
 3  0      0 1702928  63684 827876    0    0     0    89  468 1362 100  0  =
0  0
 5  0      0 1702680  63696 827876    0    0     0   132  461 1598 99  1  0=
  0
 8  0      0 1702680  63712 827892    0    0     0    80  465 1180 99  1  0=
  0
 3  0      0 1702712  63732 827884    0    0     0    67  453 1005 100  0  =
0  0
 4  0      0 1702792  63744 827920    0    0     0    41  461 1138 100  0  =
0  0
 3  0      0 1702792  63760 827916    0    0     0    57  456 1073 100  0  =
0  0
 3  0      0 1702808  63776 827928    0    0     0   111  473 1095 100  0  =
0  0
 3  0      0 1702808  63788 827928    0    0     0    81  461 1092 99  1  0=
  0
 3  0      0 1702188  63808 827928    0    0     0   160  463 1437 99  1  0=
  0
 3  0      0 1702064  63884 827900    0    0     0   229  479 1125 99  0  0=
  0
 4  0      0 1702064  63912 827972    0    0     1    77  460 1108 100  0  =
0  0
 7  0      0 1702032  63920 828000    0    0     0    40  463 1068 100  0  =
0  0
 4  0      0 1702048  63928 828008    0    0     0    68  454 1114 100  0  =
0  0
11  0      0 1702048  63928 828008    0    0     0     0  458 1001 100  0  =
0  0
 3  0      0 1701500  63960 828020    0    0     0   189  470 1538 99  1  0=
  0
 3  0      0 1701476  63968 828020    0    0     0    57  461 1111 100  0  =
0  0
 4  0      0 1701508  63996 828044    0    0     0   105  458 1093 99  1  0=
  0
 4  0      0 1701428  64012 828044    0    0     0   127  471 1341 100  0  =
0  0
 5  0      0 1701356  64028 828040    0    0     0    55  458 1344 100  0  =
0  0
 3  0      0 1701356  64028 828056    0    0     0    15  462 1291 100  0  =
0  0

cfs-v5
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu--=
=2D-
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa
 6  0      0 2157728  31816 545236    0    0     0   103  543  748 100  0  =
0  0
 4  0      0 2157780  31828 545256    0    0     0    63  435  752 100  0  =
0  0
 4  0      0 2157928  31852 545256    0    0     0   105  424  770 100  0  =
0  0
 4  0      0 2157928  31868 545268    0    0     0   261  457  763 100  0  =
0  0
 4  0      0 2157928  31884 545280    0    0     0   113  435  765 100  0  =
0  0
 4  0      0 2157928  31900 545288    0    0     0    52  422  745 100  0  =
0  0
 4  0      0 2157556  31932 545284    0    0     0   169  436 1010 100  0  =
0  0
 4  0      0 2157556  31952 545296    0    0     0    72  424  736 100  0  =
0  0
 4  0      0 2157556  31960 545304    0    0     0    35  428  743 100  0  =
0  0
 4  0      0 2157556  31984 545308    0    0     0    91  425  710 99  1  0=
  0
 4  0      0 2157556  31992 545320    0    0     0    35  428  738 100  0  =
0  0
 5  0      0 2157556  32016 545320    0    0     0   105  425  729 100  0  =
0  0
 4  0      0 2157432  32052 545336    0    0     0   197  434  989 99  1  0=
  0
 5  0      0 2157448  32060 545352    0    0     0    36  421  767 100  0  =
0  0
 4  0      0 2157448  32076 545356    0    0     0   127  441  752 100  0  =
0  0
 6  0      0 2157448  32092 545368    0    0     0    69  422  784 99  1  0=
  0
 4  0      0 2157324  32116 545388    0    0     0   191  445  734 100  0  =
0  0
 4  0      0 2157200  32148 545400    0    0     0   123  427  773 100  0  =
0  0
 4  0      0 2157200  32156 545412    0    0     0    39  428  713 100  0  =
0  0
 7  0      0 2156844  32184 545412    0    0     1   161  429 1360 99  1  0=
  0
 6  0      0 2156348  32192 545416    0    0     0    32  427  723 100  0  =
0  0


Last not least I'd like to add that at least on my system having X
niced to -19 does result in kind of "erratic" (for lack of a better
word) desktop behavior. I'll will reevaluate this with -v6 but for
now IMO nicing X to -19 is a regression at least on my machine despite
the claim that cfs doesn't suffer from it.

Best,
Michael

PS: Only learning how to test these things I'm happy to get pointed
out the shortcomings of what I tested above. Of course suggestions for
improvements are welcome.
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart1184117.Bt153Eetd2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGLbPfUYYhyuxDQc4RAvAQAKCV7m3myAWVkCmwL6UAGtJXODti1ACgnDT3
vdOrLs40v1p/k4+4tQUOKeA=
=tguO
-----END PGP SIGNATURE-----

--nextPart1184117.Bt153Eetd2--
