Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbXBWLG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbXBWLG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbXBWLG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:06:56 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:53092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbXBWLGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:06:55 -0500
Subject: ata workqueue corruption
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RECDe9DmIMaVQoo+jcWP"
Date: Fri, 23 Feb 2007 02:07:16 +0100
Message-Id: <1172192836.15769.3.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RECDe9DmIMaVQoo+jcWP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

While debugging why I keep having problems with suspend to disk on my
quad with more recent kernels (2.6.20 worked fine), I managed to capture
this weird ata workqueue corruption via netconsole, just a bit later the
system froze (I was in X but this seems like a reason to panic):

[  243.981215] ata/0         S 0000000000000000     0    80     19         =
   81    77 (L-TLB)
[  243.981225] Call Trace:
[  243.981231] [C00000007EC63AA0] [C000000000529B18] devinet_sysctl+0xb8/0x=
968 (unreliable)
[  243.981245] [C00000007EC63C70] [C00000000000FB28] .__switch_to+0xe4/0x11=
8
[  243.981257] [C00000007EC63D00] [C00000000035BEA4] .schedule+0x73c/0x894
[  243.981267] [C00000007EC63E00] [C0000000000597C8] .worker_thread+0x120/0=
x1b4
[  243.981278] [C00000007EC63EE0] [C00000000005E4D8] .kthread+0x11c/0x16c
[  243.981289] [C00000007EC63F90] [C000000000021780] .kernel_thread+0x4c/0x=
68
[  243.981298] ata/1         S 0000000000000000     0    81     19         =
   82    80 (L-TLB)
[  243.981308] Call Trace:
[  243.981313] [C00000007EC67AA0] [5A5A5A5A5A5A5A5A] 0x5a5a5a5a5a5a5a5a (un=
reliable)
[  243.981325] [C00000007EC67C70] [C00000000000FB28] .__switch_to+0xe4/0x11=
8
[  243.981336] [C00000007EC67D00] [C00000000035BEA4] .schedule+0x73c/0x894
[  243.981347] [C00000007EC67E00] [C0000000000597C8] .worker_thread+0x120/0=
x1b4
[  243.981357] [C00000007EC67EE0] [C00000000005E4D8] .kthread+0x11c/0x16c
[  243.981368] [C00000007EC67F90] [C000000000021780] .kernel_thread+0x4c/0x=
68
[  243.981377] ata/2         S 0000000000000000     0    82     19         =
   84    81 (L-TLB)
[  243.981387] Call Trace:
[  243.981393] [C00000007EC6BAA0] [5A5A5A5A5A5A5A5A] 0x5a5a5a5a5a5a5a5a (un=
reliable)
[  243.981404] [C00000007EC6BC70] [C00000000000FB28] .__switch_to+0xe4/0x11=
8
[  243.981415] [C00000007EC6BD00] [C00000000035BEA4] .schedule+0x73c/0x894
[  243.981426] [C00000007EC6BE00] [C0000000000597C8] .worker_thread+0x120/0=
x1b4
[  243.981437] [C00000007EC6BEE0] [C00000000005E4D8] .kthread+0x11c/0x16c
[  243.981448] [C00000007EC6BF90] [C000000000021780] .kernel_thread+0x4c/0x=
68
[  243.981456] ata_aux       S 0000000000000000     0    84     19         =
  107    82 (L-TLB)
[  243.981466] Call Trace:
[  243.981472] [C00000007EC77AA0] [5A5A5A5A5A5A5AA5] 0x5a5a5a5a5a5a5aa5 (un=
reliable)
[  243.981483] [C00000007EC77C70] [C00000000000FB28] .__switch_to+0xe4/0x11=
8
[  243.981495] [C00000007EC77D00] [C00000000035BEA4] .schedule+0x73c/0x894
[  243.981505] [C00000007EC77E00] [C0000000000597C8] .worker_thread+0x120/0=
x1b4
[  243.981516] [C00000007EC77EE0] [C00000000005E4D8] .kthread+0x11c/0x16c
[  243.981527] [C00000007EC77F90] [C000000000021780] .kernel_thread+0x4c/0x=
68

Unfortunately I have no more than this to offer and it doesn't seem to
be reproducible.

johannes

--=-RECDe9DmIMaVQoo+jcWP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF3j5D/ETPhpq3jKURApzQAJ0YBIqcq88qn2O8D76FQUBDI5cEmQCfVv+a
CMCnNyoAgNSHVUAuiQprt94=
=9Aoo
-----END PGP SIGNATURE-----

--=-RECDe9DmIMaVQoo+jcWP--

