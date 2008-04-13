Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbYDMXO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbYDMXO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYDMXOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:14:43 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:49151 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbYDMXOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:14:42 -0400
Date: Sun, 13 Apr 2008 18:14:40 -0500
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 8/33 replaces 8/35 and 9/35] W1: feature, w1_therm.c use strong pullup and documentation
Message-ID: <20080413231440.GB15213@spacedout.fries.net>
References: <20080413225632.GA14058@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <20080413225632.GA14058@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 13 Apr 2008 18:14:41 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
This is an update to the previous set of patches, don't merge them
yet.  Some of the context was messed up and I don't expect patch to
apply the updates with the previous set cleanly.  I'll resubmit the
entire set if these updates look good.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

w1_therm.c 1.3 1.4 1.10 1.11
Use the strong pullup not the sleep.  Note that the pullup goes before
W1_CONVERT_TEMP not after.
+w1_next_pullup(dev, tm);
 w1_write_8(dev, W1_CONVERT_TEMP);
-msleep(tm);

Also added a module parameter strong_pullup to disable the strong
pullup and sleep if requested.

New directory for temperature sensor documentation.

Documentation/w1/00-INDEX 1.2
Added new subdirectory slaves

Documentation/w1/slaves/00-INDEX 1.1 1.2
Added index and w1_therm entry.

Documentation/w1/slaves/w1_therm 1.1 1.2 1.3
Initial entry for the temperature sensor.

Signed-off-by: David Fries <david@fries.net>
---
 Documentation/w1/00-INDEX        |    2 +
 Documentation/w1/slaves/00-INDEX |    4 +++
 Documentation/w1/slaves/w1_therm |   41 ++++++++++++++++++++++++++++++++++=
++++
 drivers/w1/slaves/w1_therm.c     |   15 ++++++++++++-
 4 files changed, 60 insertions(+), 2 deletions(-)

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
index 0000000..0403aaa
--- /dev/null
+++ b/Documentation/w1/slaves/w1_therm
@@ -0,0 +1,41 @@
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
+
+Support is provided through the sysfs w1_slave file.  Each open and
+read sequence will initiate a temperature conversion then provide two
+lines of ASCII output.  The first line contains the nine hex bytes
+read along with a calculated crc value and YES or NO if it matched.
+If the crc matched the returned values are retained.  The second line
+displays the retained values along with a temperature in millidegrees
+Centigrade after t=3D.
+
+Parasite powered devices are limited to one slave performing a
+temperature conversion at a time.  If none of the devices are parasite
+powered it would be possible to convert all the devices at the same
+time and then go back to read individual sensors.  That isn't
+currently supported.  The driver also doesn't support reduced
+precision (which would also reduce the conversion time).
+
+The module parameter strong_pullup can be set to 0 to disable the
+strong pullup or 1 to enable.  If enabled the 5V strong pullup will be
+enabled when the conversion is taking place provided the master driver
+must support the strong pullup (or it falls back to a pullup
+resistor).  The DS18b20 temperature sensor specification lists a
+maximum current draw of 1.5mA and that a 5k pullup resistor is not
+sufficient.  The strong pullup is designed to provide the additional
+current required.
diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index fb28aca..f659380 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -37,6 +37,14 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
 MODULE_DESCRIPTION("Driver for 1-wire Dallas network protocol, temperature=
 family.");
=20
+/* Allow the strong pullup to be disabled, but default to enabled.
+ * If it was disabled a parasite powered device might not get the require
+ * current to do a temperature conversion.  If it is enabled parasite powe=
red
+ * devices have a better chance of getting the current required.
+ */
+static int w1_strong_pullup=3D1;
+module_param_named(strong_pullup, w1_strong_pullup, int, 0);
+
 static u8 bad_roms[][9] =3D {
 				{0xaa, 0x00, 0x4b, 0x46, 0xff, 0xff, 0x0c, 0x10, 0x87},
 				{}
@@ -192,9 +200,12 @@ static ssize_t w1_therm_read_bin(struct kobject *kobj,
 			int count =3D 0;
 			unsigned int tm =3D 750;
=20
+			/* 750ms strong pullup (or delay) after the convert */
+			if(w1_strong_pullup)
+				w1_next_pullup(dev, tm);
 			w1_write_8(dev, W1_CONVERT_TEMP);
-
-			msleep(tm);
+			if(!w1_strong_pullup)
+				msleep(tm);
=20
 			if (!w1_reset_select_slave(sl)) {
=20
--=20
1.4.4.4

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIApPgAI852cse6PARAlZ2AJ9AJVs7kkVhRwZNrvUTNOduaMOabgCgu70Z
Y+h+djkEXCoY9eoMb4Sh52U=
=CBDH
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
