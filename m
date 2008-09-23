Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbYIWJBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbYIWJBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYIWJBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:01:44 -0400
Received: from postman.teamix.net ([194.150.191.120]:35619 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750849AbYIWJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:01:44 -0400
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: linux-kernel@vger.kernel.org
Subject: [PATCH] CFS scheduler: documentation about scheduling policies
Date: Tue, 23 Sep 2008 11:01:26 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1602792.QlSJ4OFECy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809231101.41624.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1602792.QlSJ4OFECy
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

The documentation about the CFS scheduler is scarse when it comes to=20
scheduling policies. This patch adds a chapter about the scheduling policie=
s=20
it supports. Peter Zijlstra provided most of the information for it in

http://marc.info/?l=3Dlinux-kernel&m=3D122210038326356&w=3D2

This patch is based on 2.6.27-rc7.

Signed-off-by: Martin Steigerwald <ms@teamix.de>

=2D--
=2D-- sched-design-CFS.txt-2.6.27-rc7     2008-07-13 23:51:29.000000000 +02=
00
+++ sched-design-CFS.txt        2008-09-23 10:33:01.107393509 +0200
@@ -118,6 +118,29 @@ Some implementation details:
    quite a bit simpler as a result.


+Supported scheduling policies
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+
+CFS implements three scheduling policies:
+
+  - SCHED_NORMAL (traditionally called SCHED_OTHER): The scheduling
+    policy that is used for regular tasks.
+
+  - SCHED_BATCH: Does not preempt nearly as often as regular tasks
+    would, thereby allowing tasks to run longer and make better use of
+    caches but at the cost of interactivity. This is well suited for
+    batch jobs.
+
+  - SCHED_IDLE: This is even weaker than nice 19, but its not a true
+    idle timer scheduler in order to avoid to get into priority
+    inversion problems which would deadlock the machine.
+
+SCHED_FIFO/_RR are implemented in sched_rt.c and are as specified by
+POSIX.
+
+The command chrt from util-linux-ng 2.13.1.1 can set all of these except
+SCHED_IDLE.
+
 Group scheduler extension to CFS
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D

=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart1602792.QlSJ4OFECy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjYsGcACgkQHhDFkwOZrpAB0QCdGdx/S8+kX8/QbnVh0PUliGbg
y08AmQF/I0SdGDQTyeyVJRkHYnd6TN8n
=bDC7
-----END PGP SIGNATURE-----

--nextPart1602792.QlSJ4OFECy--
