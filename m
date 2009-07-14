Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbZGNQ4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbZGNQ4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbZGNQ4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:56:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:56400 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbZGNQ4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:56:47 -0400
Date: Tue, 14 Jul 2009 18:57:22 +0200
From: Kurt Garloff <garloff@suse.de>
To: Linux kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] Resend: [PATCH 1/3]: Store SRAT revision
Message-ID: <20090714165722.GE31657@tpkurt2.suse.de>
Mail-Followup-To: Kurt Garloff <garloff@suse.de>,
	Linux kernel list <linux-kernel@vger.kernel.org>
References: <20090518093352.GC15531@tpkurt2.garloff.de> <20090622140522.GA5378@sgi.com> <20090714165508.GD31657@tpkurt2.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mrJd9p1Ce66CJMxE"
Content-Disposition: inline
In-Reply-To: <20090714165508.GD31657@tpkurt2.suse.de>
X-Operating-System: Linux 2.6.27.23-0.1-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
Organization: SUSE Linux Products GmbH (a Novell company), Nuernberg, GF:
	Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mrJd9p1Ce66CJMxE
Content-Type: multipart/mixed; boundary="jTMWTj4UTAEmbWeb"
Content-Disposition: inline


--jTMWTj4UTAEmbWeb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregard reserved fields.
In order to know whether to disregard or not, we must know what=20
version the SRAT table has.

This patch stores the SRAT table revision for later consumption
by arch specific __init functions.

This is patch 1/3.

Signed-off-by: Kurt Garloff <garloff@suse.de>
--=20
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.

--jTMWTj4UTAEmbWeb
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="01_srat-pxm-rev-store.diff"
Content-Transfer-Encoding: quoted-printable

=46rom: Kurt Garloff <garloff@suse.de>
Subject: Store SRAT table revision

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregard reserved fields.
In order to know whether to disregard or not, we must know what=20
version the SRAT table has.

This patch stores the SRAT table revision for later consumption
by arch specific __init functions.

This is patch 1/3.

Signed-off-by: Kurt Garloff <garloff@suse.de>

diff -r a28eb89d1fe1 drivers/acpi/numa.c
--- a/drivers/acpi/numa.c	Tue Jul 14 02:00:45 2009 +0000
+++ b/drivers/acpi/numa.c	Tue Jul 14 16:44:35 2009 +0200
@@ -42,6 +42,8 @@
 static int node_to_pxm_map[MAX_NUMNODES]
 				=3D { [0 ... MAX_NUMNODES - 1] =3D PXM_INVAL };
=20
+unsigned char acpi_srat_revision __initdata;
+
 int pxm_to_node(int pxm)
 {
 	if (pxm < 0)
@@ -266,6 +268,7 @@
 		return -EINVAL;
=20
 	srat =3D (struct acpi_table_srat *)table;
+	acpi_srat_revision =3D srat->header.revision;
=20
 	return 0;
 }
diff -r a28eb89d1fe1 include/acpi/acpi_numa.h
--- a/include/acpi/acpi_numa.h	Tue Jul 14 02:00:45 2009 +0000
+++ b/include/acpi/acpi_numa.h	Tue Jul 14 16:44:35 2009 +0200
@@ -15,6 +15,7 @@
 extern int node_to_pxm(int);
 extern void __acpi_map_pxm_to_node(int, int);
 extern int acpi_map_pxm_to_node(int);
+extern unsigned char acpi_srat_revision;
=20
 #endif				/* CONFIG_ACPI_NUMA */
 #endif				/* __ACP_NUMA_H */

--jTMWTj4UTAEmbWeb--

--mrJd9p1Ce66CJMxE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFKXLjyxmLh6hyYd04RApkSAKDHV+7hMEIlzsV1P27XsXE9s/vw7wCguMRt
auyIiSGMeWKKZr6Vp2WWo+c=
=aJ9f
-----END PGP SIGNATURE-----

--mrJd9p1Ce66CJMxE--
