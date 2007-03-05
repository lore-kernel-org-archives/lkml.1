Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbXCEWBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbXCEWBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXCEWBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:01:50 -0500
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:39669 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbXCEWBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:01:47 -0500
Message-ID: <45EC9338.9090503@freedesktop.org>
Date: Mon, 05 Mar 2007 14:01:28 -0800
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Publish rcutorture module parameters via sysfs, read-only
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB1DCC0CC3AF715C9490761A5"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB1DCC0CC3AF715C9490761A5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

rcutorture's module parameters currently use permissions of 0, so they do=
n't
show up in /sys/module/rcutorture/parameters.  Change the permissions on =
all
module parameters to world-readable (0444).

Signed-off-by: Josh Triplett <josh@freedesktop.org>
---
rcutorture does all of its initialization and thread startup when loaded,=
 and
relies on the parameters not changing during execution, so they should no=
t
permit writing.  However, reading seems fine.

 kernel/rcutorture.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index df49eca..be5114b 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -60,19 +60,19 @@ static int test_no_idle_hz;	/* Test RCU's support for=
 tickless idle CPUs. */
 static int shuffle_interval =3D 5; /* Interval between shuffles (in sec)=
*/
 static char *torture_type =3D "rcu"; /* What RCU implementation to tortu=
re. */
=20
-module_param(nreaders, int, 0);
+module_param(nreaders, int, 0444);
 MODULE_PARM_DESC(nreaders, "Number of RCU reader threads");
-module_param(nfakewriters, int, 0);
+module_param(nfakewriters, int, 0444);
 MODULE_PARM_DESC(nfakewriters, "Number of RCU fake writer threads");
-module_param(stat_interval, int, 0);
+module_param(stat_interval, int, 0444);
 MODULE_PARM_DESC(stat_interval, "Number of seconds between stats printk(=
)s");
-module_param(verbose, bool, 0);
+module_param(verbose, bool, 0444);
 MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
-module_param(test_no_idle_hz, bool, 0);
+module_param(test_no_idle_hz, bool, 0444);
 MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs")=
;
-module_param(shuffle_interval, int, 0);
+module_param(shuffle_interval, int, 0444);
 MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles")=
;
-module_param(torture_type, charp, 0);
+module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, src=
u)");
=20
 #define TORTURE_FLAG "-torture:"
--=20
1.5.0.2


--------------enigB1DCC0CC3AF715C9490761A5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF7JNHGJuZRtD+evsRAuSBAJ0dbs5yDOgwasjKxHfesUxxanMldgCgr6wm
1x4c/Pq//DPqslQgBdIRttA=
=+XOa
-----END PGP SIGNATURE-----

--------------enigB1DCC0CC3AF715C9490761A5--
