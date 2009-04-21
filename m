Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbZDUSCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbZDUSCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZDUSBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:01:53 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:63407 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZDUSBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:01:52 -0400
Message-ID: <49EE0A13.50403@dell.com>
Date: Tue, 21 Apr 2009 13:01:55 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: mjg59@srcf.ucam.org
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Don't load Dell-WMI on non WMI systems
References: <49ECBAE2.2080308@dell.com>
In-Reply-To: <49ECBAE2.2080308@dell.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5C0F3905616614173C27B6E0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5C0F3905616614173C27B6E0
Content-Type: multipart/mixed;
 boundary="------------000104010207040103090209"

This is a multi-part message in MIME format.
--------------000104010207040103090209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi:

I've noticed that the dell-wmi module will load on systems even if WMI
isn't supported.  As this is dependent upon BIOS version, dell-wmi
should return -ENODEV in these situations.

Regards
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com

--------------000104010207040103090209
Content-Type: text/x-patch;
 name="dell-wmi-dont-load-on-non-wmi-system.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="dell-wmi-dont-load-on-non-wmi-system.patch"

--- a/drivers/platform/x86/dell-wmi.c~	2009-04-21 12:41:50.000000000 -050=
0
+++ b/drivers/platform/x86/dell-wmi.c	2009-04-21 12:30:35.000000000 -0500=

@@ -255,8 +255,10 @@
 			return err;
 		}
=20
-	} else
-		printk(KERN_WARNING "dell-wmi: No known WMI GUID found\n");
+	} else {
+		printk(KERN_ERR "dell-wmi: No known WMI GUID found\n");
+		return -ENODEV;
+    }
=20
 	return 0;
 }

--------------000104010207040103090209--

--------------enig5C0F3905616614173C27B6E0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknuChQACgkQ2CrZjkA73Yv7kwCfaX3kaNY/+9c+usVu31p4OCMy
mWcAoIYyaOKLGQdSmeZrN7VywRalEbaH
=YsKN
-----END PGP SIGNATURE-----

--------------enig5C0F3905616614173C27B6E0--
