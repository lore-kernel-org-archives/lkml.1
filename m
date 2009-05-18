Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbZERJv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbZERJv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbZERJqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:46:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:53990 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758350AbZERJp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:45:56 -0400
Date: Mon, 18 May 2009 11:46:12 +0200
From: Kurt Garloff <garloff@suse.de>
To: Linux kernel list <linux-kernel@vger.kernel.org>,
       Norbert Eicker <N.Eicker@fz-juelich.de>,
       Greg Kroah-Hartman <GregKH@suse.de>,
       Alexey Starikovskiy <AStarikovskiy@suse.cz>,
       Len Brown <LenB@kernel.org>, xb <xavier.bru@bull.net>
Subject: [PATCH 1/3]: Store SRAT revision
Message-ID: <20090518094612.GE15531@tpkurt2.garloff.de>
Mail-Followup-To: Kurt Garloff <garloff@suse.de>,
	Linux kernel list <linux-kernel@vger.kernel.org>,
	Norbert Eicker <N.Eicker@fz-juelich.de>,
	Greg Kroah-Hartman <GregKH@suse.de>,
	Alexey Starikovskiy <AStarikovskiy@suse.cz>,
	Len Brown <LenB@kernel.org>, xb <xavier.bru@bull.net>
References: <20090518093352.GC15531@tpkurt2.garloff.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CXFpZVxO6m2Ol4tQ"
Content-Disposition: inline
In-Reply-To: <20090518093352.GC15531@tpkurt2.garloff.de>
X-Operating-System: Linux 2.6.27.21-5.1-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
Organization: SUSE Linux Products GmbH (a Novell company), Nuernberg, GF:
	Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CXFpZVxO6m2Ol4tQ
Content-Type: multipart/mixed; boundary="//IivP0gvsAy3Can"
Content-Disposition: inline


--//IivP0gvsAy3Can
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

This patch stores the SRAT table revision for later consumption
by arch specific __init functions.

This is patch 1/3.
--=20
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.

--//IivP0gvsAy3Can
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="srat-pxm-rev-store.diff"
Content-Transfer-Encoding: quoted-printable

=46rom: Kurt Garloff <garloff@suse.de>
Subject: Store SRAT table revision
References: bnc#503038

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregrard reserved fields.
In order to know whether or not, we must know what version the SRAT
table has.

This patch stores the SRAT table revision for later consumption
by arch specific __init functions.

This is patch 1/3.

Signed-off-by: Kurt Garloff <garloff@suse.de>

diff -r a4ed8abcc815 drivers/acpi/numa.c
--- a/drivers/acpi/numa.c	Sat May 16 13:41:28 2009 -0700
+++ b/drivers/acpi/numa.c	Mon May 18 10:45:40 2009 +0200
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
diff -r a4ed8abcc815 include/acpi/acpi_numa.h
--- a/include/acpi/acpi_numa.h	Sat May 16 13:41:28 2009 -0700
+++ b/include/acpi/acpi_numa.h	Mon May 18 10:45:40 2009 +0200
@@ -15,6 +15,7 @@
 extern int node_to_pxm(int);
 extern void __acpi_map_pxm_to_node(int, int);
 extern int acpi_map_pxm_to_node(int);
+extern unsigned char acpi_srat_revision;
=20
 #endif				/* CONFIG_ACPI_NUMA */
 #endif				/* __ACP_NUMA_H */

--//IivP0gvsAy3Can--

--CXFpZVxO6m2Ol4tQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFKES5kxmLh6hyYd04RAkuwAJwMmPx9j+XHlTZq5E8Rsu0Ru1MRHgCgjb7O
J69olebtIi4Nw4yagzbdEG0=
=Edh9
-----END PGP SIGNATURE-----

--CXFpZVxO6m2Ol4tQ--
