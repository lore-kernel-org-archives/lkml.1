Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbZDQHi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbZDQHi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZDQHio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:38:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:47066 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbZDQHio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:38:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,203,1239001200"; 
   d="asc'?scan'208";a="682365701"
Subject: [PATCH -v2 1/2] kvm userspace: Add handler_8/9/10 support to
 monitor
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/ka9WEs7XzxaXSddQxS/"
Date: Fri, 17 Apr 2009 15:38:38 +0800
Message-Id: <1239953918.6842.20.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/ka9WEs7XzxaXSddQxS/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This is needed by MCE simulation.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 qemu/monitor.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/qemu/monitor.c
+++ b/qemu/monitor.c
@@ -2514,6 +2514,15 @@ static void monitor_handle_command(Monit
                       void *arg3, void *arg4, void *arg5);
     void (*handler_7)(Monitor *mon, void *arg0, void *arg1, void *arg2,
                       void *arg3, void *arg4, void *arg5, void *arg6);
+    void (*handler_8)(Monitor *mon, void *arg0, void *arg1, void *arg2,
+		      void *arg3, void *arg4, void *arg5, void *arg6,
+		      void *arg7);
+    void (*handler_9)(Monitor *mon, void *arg0, void *arg1, void *arg2,
+		      void *arg3, void *arg4, void *arg5, void *arg6,
+		      void *arg7, void *arg8);
+    void (*handler_10)(Monitor *mon, void *arg0, void *arg1, void *arg2,
+		       void *arg3, void *arg4, void *arg5, void *arg6,
+		       void *arg7, void *arg8, void *arg9);
=20
 #ifdef DEBUG
     monitor_printf(mon, "command=3D'%s'\n", cmdline);
@@ -2811,6 +2820,21 @@ static void monitor_handle_command(Monit
         handler_7(mon, args[0], args[1], args[2], args[3], args[4], args[5=
],
                   args[6]);
         break;
+    case 8:
+        handler_8 =3D cmd->handler;
+        handler_8(mon, args[0], args[1], args[2], args[3], args[4], args[5=
],
+		  args[6], args[7]);
+        break;
+    case 9:
+        handler_9 =3D cmd->handler;
+        handler_9(mon, args[0], args[1], args[2], args[3], args[4], args[5=
],
+		  args[6], args[7], args[8]);
+        break;
+    case 10:
+        handler_10 =3D cmd->handler;
+        handler_10(mon, args[0], args[1], args[2], args[3], args[4], args[=
5],
+		   args[6], args[7], args[8], args[9]);
+        break;
     default:
         monitor_printf(mon, "unsupported number of arguments: %d\n", nb_ar=
gs);
         goto fail;


--=-/ka9WEs7XzxaXSddQxS/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknoMe0ACgkQKhFGF+eHlpjJ6ACfZ6V4KXH2N1cAEIat59DzRfRu
SaIAn0QOAqIdMKkQftOeRkL+eNe1YwUD
=u0t0
-----END PGP SIGNATURE-----

--=-/ka9WEs7XzxaXSddQxS/--

