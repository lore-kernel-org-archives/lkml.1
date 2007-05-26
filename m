Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbXEZJyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbXEZJyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 05:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbXEZJxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 05:53:53 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:49420 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbXEZJxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 05:53:52 -0400
Subject: Re: software suspend doesn't work with 2.6.22-rc3
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Maximilian Engelhardt <maxi@daemonizer.de>,
       Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200705261128.57332.maxi@daemonizer.de>
References: <200705261128.57332.maxi@daemonizer.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BfGFvYITeF1zGT1nlVPy"
Date: Sat, 26 May 2007 19:53:53 +1000
Message-Id: <1180173233.9773.79.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BfGFvYITeF1zGT1nlVPy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Sat, 2007-05-26 at 11:28 +0200, Maximilian Engelhardt wrote:
> Hello,
>=20
> When I try software suspend on my laptop it always returns to my running=20
> system after some time.
> This is what's logged by the kernel:
>=20
> swsusp: Basic memory bitmaps created
> Stopping tasks ...=20
> Stopping kernel threads timed out after 20 seconds (1 tasks refusing to=20
> freeze):
>  cryptd
> Restarting tasks ... done.
> swsusp: Basic memory bitmaps freed
>=20
> I have no idea what's the problem, but if you tell me what I should do I =
can=20
> create debugging information and/or test patches.

Could you try this patch, please? It should help.

Herbert, is this right? If cryptd is going to be used for block devs,
the task should probably be PF_NOFREEZE (or whatever it is today)
instead.

Regards,

Nigel

 crypto/cryptd.c         |    1 +
 include/linux/freezer.h |    3 +++
 kernel/power/process.c  |    2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)
diff -ruNp 991-fix-cryptd.patch-old/crypto/cryptd.c 991-fix-cryptd.patch-ne=
w/crypto/cryptd.c
--- 991-fix-cryptd.patch-old/crypto/cryptd.c	2007-05-19 18:16:47.000000000 =
+1000
+++ 991-fix-cryptd.patch-new/crypto/cryptd.c	2007-05-26 19:45:42.000000000 =
+1000
@@ -341,6 +341,7 @@ static int cryptd_thread(void *data)
=20
 		mutex_unlock(&state->mutex);
=20
+		try_to_freeze();
 		schedule();
 	} while (!stop);
=20


--=-BfGFvYITeF1zGT1nlVPy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWAOxN0y+n1M3mo0RAiEeAJ9XMuC+q5A0iQzKdGicg3z3ZODNXwCgnq59
+H/Zja+/qirRH0qugPtcNJI=
=nJ9r
-----END PGP SIGNATURE-----

--=-BfGFvYITeF1zGT1nlVPy--

