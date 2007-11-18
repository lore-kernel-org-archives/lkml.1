Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbXKRJq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbXKRJq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 04:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbXKRJqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 04:46:04 -0500
Received: from paperboy.netsplit.com ([82.108.80.242]:34226 "EHLO
	paperboy.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbXKRJqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 04:46:01 -0500
Subject: [PATCH] wait_task_stopped: pass correct exit_code to
	wait_noreap_copyout
From: Scott James Remnant <scott@ubuntu.com>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EYBTzqzJ2Bql74elVsCH"
Date: Sun, 18 Nov 2007 09:13:24 +0000
Message-Id: <1195377204.6070.3.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EYBTzqzJ2Bql74elVsCH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

In wait_task_stopped() exit_code already contains the right value for
the si_status member of siginfo, and this is simply set in the non
WNOWAIT case.
   =20
Pass it unchanged to wait_noreap_copyout();  we would only need to
shift it and add 0x7f if we were returning it in the user status field
and that isn't used for any function that permits WNOWAIT.
   =20
Signed-off-by: Scott James Remnant <scott@ubuntu.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Roland McGrath <roland@redhat.com>

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1389,7 +1389,7 @@ static int wait_task_stopped(struct task_struct
*p, int delayed_group_leader,
 		if (unlikely(!exit_code) || unlikely(p->exit_state))
 			goto bail_ref;
 		return wait_noreap_copyout(p, pid, uid,
-					   why, (exit_code << 8) | 0x7f,
+					   why, exit_code,
 					   infop, ru);
 	}
=20


--=-EYBTzqzJ2Bql74elVsCH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHQAI0SnQiFMl4yK4RApSrAKCtNzGkRN2cGS07o+314Y4GO7eBZQCdEbAE
3k0PjEXoHN/fHtGfgvpixcw=
=W0Tb
-----END PGP SIGNATURE-----

--=-EYBTzqzJ2Bql74elVsCH--

