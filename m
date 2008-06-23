Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYFWMcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYFWMcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 08:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbYFWMbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 08:31:40 -0400
Received: from [194.117.236.238] ([194.117.236.238]:58483 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbYFWMbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 08:31:40 -0400
Date: Mon, 23 Jun 2008 15:30:22 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: tzanussi@gmail.com
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Relay buffer-only channels and its prereqs (resubmit 2)
Message-ID: <20080623153022.03463499@linux360.ro>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//KOs+E1q9t+8ysef8KCANvu";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//KOs+E1q9t+8ysef8KCANvu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello everybody,

The changes since last submission are:
- Removed the git unignore stuff as it has been already merged.
- Fully converted all users to the new early_initcall() interface.
- Fixed patch 3 so that it works without locking the per-CPU buffer.
- Modified patch 3 as Pekka Enberg suggested.

Vegard Nossum expressed his interest in the first patch. However, he
suggested naming these initcalls 'pre-SMP' rather than 'early' ('early'
as in CPU hotplug docs and as they are now), suggesting the name should
reflect usage. Please pitch in and comment about this.

Also, please review and comment/(n)ack/ask on/about these patches.

Eduard - Gabriel Munteanu (3):
  Better interface for hooking early initcalls.
  Full conversion to early_initcall() interface, remove old interface.
  relay: Add buffer-only channels; useful for early logging.

 Documentation/filesystems/relay.txt |   11 +++
 include/asm-generic/vmlinux.lds.h   |    2 +
 include/linux/init.h                |    7 ++
 include/linux/relay.h               |    5 +
 include/linux/sched.h               |    9 --
 init/main.c                         |   21 +----
 kernel/relay.c                      |  170 +++++++++++++++++++++++++++++--=
----
 kernel/sched.c                      |    6 +-
 kernel/softirq.c                    |    4 +-
 kernel/softlockup.c                 |   27 +++++-
 10 files changed, 203 insertions(+), 59 deletions(-)

--Sig_//KOs+E1q9t+8ysef8KCANvu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUBSF+XYtxcOkuRpXptAQIqwg//f8G9vFnh/usRIe3+Qkwl34pQW2QPWbXh
8Wx2SHm9zwBtd5xT87r5pN2ZraJdFKGs9uf29PRQug9t2tvJ6aJaQ8II/egWy+qU
ywe9tMgctoR7VNKDYsqeyndbl110rLg0nCfupJIakV/3GEfNxtuGJ5tAIO0Za0hm
UJeV9QS898eAPJmhXuWUuky5YKsJaM3rVa4Vvhtwh71aSPvI0I61P/M+6ttw4R61
k1BzNGnwPDdPFyTlPX7ZI0bdKLTypSo32mi91FrAF5TRn6Gl7nrmkiDwIFYL9pWF
rgOHsGpQFHhyP4JJKK6ka7gJDUGmSTus3ozWmhqeTIM9urdiyhzioo2K1/IP323J
2eafWtlXxOfFzvNw3y0TKTdzuYkg2rFxOHP8HBgw12hoYbBay29UEvSbyeNXxkSZ
2OaHwy44HFEc3o16bi3+YIksEAZSnVuqPz4f2w8UvzImWf8ok7ynDbuKAFgd8HlH
ADXmFp7mhX3tZfmpOmvWok1HYWdYQlsRpuV3+3X1SUSLuXEbz67K9PbQhqbWk2iC
3KH01jDhKFEjcBm1RzN63CD59NVCZ892JEMfRW+QCzzFLoJiJvZ1UwCeGWLu8Vzx
BkaIkX0wTC/hU5wFsu0G9OF3XHxT/iJ58MPy2WZAzH/hUSb9F1IOK/Zc7z0BKMCc
Q0sy9v8Ojy8=
=J/vH
-----END PGP SIGNATURE-----

--Sig_//KOs+E1q9t+8ysef8KCANvu--
