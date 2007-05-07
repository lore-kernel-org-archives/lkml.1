Return-Path: <linux-kernel-owner+w=401wt.eu-S933844AbXEGNfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844AbXEGNfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933786AbXEGNfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:35:22 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:40831 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933781AbXEGNfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:35:21 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: linux-kernel@vger.kernel.org
Subject: [REPORT] cfs-v9 vs sd048 vs mainline
Date: Mon, 7 May 2007 15:34:55 +0200
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
  boundary="nextPart1328831.rvjRavnVBc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705071535.09223.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1178544921;4be369a9;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1328831.rvjRavnVBc
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi list,

here is another round of numbercrunching tests done with the following
schedulers/kernels:
    2.6.21.1 (mainline)
    2.6.21-sd046
    2.6.21.1-sd048
    2.6.21-cfs-v6
    2.6.21.1-cfs-v7
    2.6.21.1-cfs-v9
running on a dualcore x86_64.

The tests consist of 3 tasks (named LTMM, LTMB and LTBM). The only
I/O they do is during init and for logging the results, the rest
is just floating point math.

There are 3 scenarios:
    j1 - all 3 tasks run sequentially
	 /proc/sys/kernel/sched_granularity_ns=3D4000000
	 /proc/sys/kernel/rr_interval=3D16
    j3 - all 3 tasks run in parallel
	 /proc/sys/kernel/sched_granularity_ns=3D4000000
	 /proc/sys/kernel/rr_interval=3D16
    j3big - all 3 tasks run in parallel with timeslice extended
            by 2 magnitudes (not run for mainline)
            /proc/sys/kernel/sched_granularity_ns=3D400000000
            /proc/sys/kernel/rr_interval=3D400

All 3 tasks are run while the system does nothing else except for
the "normal" (KDE) daemons. The system had not been used for
interactive work during the tests.

I'm giving user time as provided by the "time" cmd followed by wallclock ti=
me
(all values in seconds).

                LTMM
                j1              j3              j3big
2.6.21.1-cfs-v9  8334.37/ 8388   5472.40/ 7459   5422.36/ 7832
  (repetition)   8288.56/ 8341                   5485.95/ 5647
2.6.21.1-cfs-v7  5690.27/ 5715   5396.31/ 9719   5424.92/ 8956
  (repetition)                   5860.11/ 8993
2.6.21-cfs-v6    5655.07/ 5682   5437.84/ 5531   5434.04/ 8072
  (repetition)   5677.39/ 5704   5509.13/ 8882
  (repetition)   5711.32/ 5732
2.6.21-sd-048    5309.64/ 5320   5517.64/ 8630   5416.81/ 8258
2.6.21-sd-046    5556.44/ 5583   5446.86/ 8037   5407.50/ 8274
2.6.21.1         5417.62/ 5439   5422.37/ 7132   na     /na

                LTMB
                j1              j3              j3big
2.6.21.1-cfs-v9 11647.24/11717   7519.84/ 9494   7477.55/10191
  (repetition)  11393.62/11460                   7557.37/10403
2.6.21.1-cfs-v7  7838.12/ 7869   7559.00/10922   7480.03/10955
  (repetition)                   7612.38/ 9874
2.6.21-cfs-v6    7729.81/ 7755   7470.10/10244   7449.16/10186
  (repetition)                   7597.83/10297
2.6.21-sd-048    7311.68/ 7323   7564.44/10591   7665.00/10435
2.6.21-sd-046    7611.00/ 7626   7573.16/10109   7458.10/10316
2.6.21.1         7438.31/ 7461   7620.72/11087   na     /na

                LTBM
                j1              j3              j3big
2.6.21.1-cfs-v9 10984.06/11058   8700.88/12373   7496.45/10300
  (repetition)  11961.47/12030                   7550.49/10382
2.6.21.1-cfs-v7  7899.38/ 7939   7558.41/ 9576   7514.79/ 9615
  (repetition)                   7833.86/11553
2.6.21-cfs-v6    7720.70/ 7746   7567.09/10362   7464.17/10335
  (repetition)                   7601.55/10578
2.6.21-sd-048    7344.96/ 7357   7589.05/10235   7547.09/10379
2.6.21-sd-046    7431.06/ 7452   7539.83/10600   7474.20/10222
2.6.21.1         7452.80/ 7481   7484.19/ 9570   na     /na

                LTMM+LTMB+LTBM
                j1              j3              j3big
2.6.21.1-cfs-v9 30965.67/31163  21693.12/29326  20396.36/28323
2.6.21.1-cfs-v7 21427.77/21523  20513.72/30217  20419.74/29526
2.6.21-cfs-v6	21105.58/21183  20475.03/26137  20347.37/28593
2.6.21-sd-048   19966.28/20000  20671.13/29456  20628.90/29072
2.6.21-sd-046	20598.50/20661  20559.85/28746  20339.80/28812
2.6.21.1	20308.73/20381  20527.28/27789  na      /na
=09

User time apparently is subject to some variance. I'm particularly surprised
by the wallclock time of scenario j1 and j3 for case LTMM with 2.6.21-cfs-v6
and in particular 2.6.21.1-cfs-v9.

I'm not sure what to make of this. Repetitions of this test show these resu=
lts
to be stable. Also surpising is the wallclock time difference between j1 an=
d j3
for LTMM with 2.6.21.1-cfs-v7. Repeating the test does give roughly the same
result though.

The reproduceable differences between j1 and j3 on 2.6.21.1-cfs-v9 IMO
suggests there is something very strange happening. It should not be possib=
le
for j1 to be faster than j3 because scenario j1 should constitute the "true"
time each task requires.

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart1328831.rvjRavnVBc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD4DBQBGPysNUYYhyuxDQc4RAl+jAJjXJozNcIhe9xMkb4E3uoF5frj1AJ9yE8We
Sfqynp77cS7f6NScRaPU4A==
=NRZ+
-----END PGP SIGNATURE-----

--nextPart1328831.rvjRavnVBc--
