Return-Path: <linux-kernel-owner+w=401wt.eu-S1760832AbZD1Rkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832AbZD1Rkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZD1RkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:40:24 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:4763 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbZD1RkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:40:23 -0400
Message-ID: <49F73F92.9000201@dell.com>
Date: Tue, 28 Apr 2009 12:40:34 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Ignore garbage in dell-wmi events
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBE91C302E964777B58B0587D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBE91C302E964777B58B0587D
Content-Type: multipart/mixed;
 boundary="------------070907050000020300020104"

This is a multi-part message in MIME format.
--------------070907050000020300020104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi:

In debugging with some future machines that actually contain BIOS level
support for dell-wmi, I've determined that the upper half of the data
that comes back from wmi_get_event_data may sometimes contain extra
information that isn't currently relevant when pulling scan codes out of
the data.  This causes dell-wmi to improperly respond to these events.

I'm attaching a patch (Exchange would munge up the line breaks otherwise)=
=2E

Thanks,

--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com

--------------070907050000020300020104
Content-Type: text/x-patch;
 name="dell-wmi-mask-buffer.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="dell-wmi-mask-buffer.patch"

--- a/drivers/platform/x86/dell-wmi.c~	2009-04-28 12:32:32.000000000 -050=
0
+++ b/drivers/platform/x86/dell-wmi.c	2009-04-28 12:33:02.000000000 -0500=

@@ -182,7 +182,7 @@
=20
 	if (obj && obj->type =3D=3D ACPI_TYPE_BUFFER) {
 		int *buffer =3D (int *)obj->buffer.pointer;
-		key =3D dell_wmi_get_entry_by_scancode(buffer[1]);
+		key =3D dell_wmi_get_entry_by_scancode(0xFFFF & buffer[1]);
 		if (key) {
 			input_report_key(dell_wmi_input_dev, key->keycode, 1);
 			input_sync(dell_wmi_input_dev);
@@ -190,7 +190,7 @@
 			input_sync(dell_wmi_input_dev);
 		} else
 			printk(KERN_INFO "dell-wmi: Unknown key %x pressed\n",
-			       buffer[1]);
+			       0xFFFF & buffer[1]);
 	}
 }
=20

--------------070907050000020300020104--

--------------enigBE91C302E964777B58B0587D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn3P5IACgkQ2CrZjkA73YtCDwCfRkLkC/pwtbBkwJ5/WdbUcpfT
bIEAnArGeF/Hv08L64pb4X4kArJRMsid
=vOJp
-----END PGP SIGNATURE-----

--------------enigBE91C302E964777B58B0587D--
