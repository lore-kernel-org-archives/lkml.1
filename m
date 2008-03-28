Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYC1MzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYC1MzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbYC1Mww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:52:52 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56332 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbYC1Mwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:52:50 -0400
Date: Fri, 28 Mar 2008 07:25:15 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 9/35] W1: create documentation for the w1_therm slave device
Message-ID: <20080328122515.GJ3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SBT+cnFS/G3NVgv4"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:25:15 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SBT+cnFS/G3NVgv4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

New directory for temperature sensor documentation.

Documentation/w1/00-INDEX 1.2
Added new subdirectory slaves

Documentation/w1/slaves/00-INDEX 1.1 1.2
Added index and w1_therm entry.

Documentation/w1/slaves/w1_therm 1.1 1.2
Initial entry for the temperature sensor.

Signed-off-by: David Fries <david@fries.net>
---
 Documentation/w1/00-INDEX        |    2 ++
 Documentation/w1/slaves/00-INDEX |    4 ++++
 Documentation/w1/slaves/w1_therm |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/Documentation/w1/00-INDEX b/Documentation/w1/00-INDEX
index 5270cf4..cb49802 100644
--- a/Documentation/w1/00-INDEX
+++ b/Documentation/w1/00-INDEX
@@ -1,5 +1,7 @@
 00-INDEX
 	- This file
+slaves/
+	- Drivers that provide support for specific family codes.
 masters/
 	- Individual chips providing 1-wire busses.
 w1.generic
diff --git a/Documentation/w1/slaves/00-INDEX b/Documentation/w1/slaves/00-=
INDEX
new file mode 100644
index 0000000..f8101d6
--- /dev/null
+++ b/Documentation/w1/slaves/00-INDEX
@@ -0,0 +1,4 @@
+00-INDEX
+	- This file
+w1_therm
+	- The Maxim/Dallas Semiconductor ds18*20 temperature sensor.
diff --git a/Documentation/w1/slaves/w1_therm b/Documentation/w1/slaves/w1_=
therm
new file mode 100644
index 0000000..7b045ae
--- /dev/null
+++ b/Documentation/w1/slaves/w1_therm
@@ -0,0 +1,35 @@
+Kernel driver w1_therm
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Supported chips:
+  * Maxim ds18*20 based temperature sensors.
+
+Author: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+
+
+Description
+-----------
+
+w1_therm provides basic temperature conversion for ds18*20 devices.
+supported family codes:
+W1_THERM_DS18S20	0x10
+W1_THERM_DS1822		0x22
+W1_THERM_DS18B20	0x28
+Support is provided through the sysfs w1_slave file.  Each open and
+read sequence will initiate a temperature conversion then provide two
+lines of ASCII output.  The first line contains the nine hex bytes
+read along with a calculated crc value and YES or NO if it matched.
+If the crc matched the returned values are retained.  The second line
+displays the retained values along with a temperature in millidegrees
+Centigrade after t=3D.
+
+w1_therm selects the current slave device for temperature conversion
+and provides a strong pullup if the master devices supports one and
+delays 750ms for the conversion.
+
+Parasite powered devices are limited to one slave performing a
+temperature conversion at a time.  If none of the devices are parasite
+powered it would be possible to convert all the devices at the same
+time and then go back to read individual sensors.  That isn't
+currently supported.  The driver also doesn't support reduced
+precision (which would also reduce the conversion time).
--=20
1.4.4.4

--SBT+cnFS/G3NVgv4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OOrAI852cse6PARAmxUAKDK3NbiTJ26qvz/h7BmapMPotkYfgCfeuca
9Be22n7AgAXCqoun3DsR2es=
=M8JJ
-----END PGP SIGNATURE-----

--SBT+cnFS/G3NVgv4--
