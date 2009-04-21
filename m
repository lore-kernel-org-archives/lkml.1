Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbZDUSBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbZDUSBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZDUSAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:00:51 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:9845 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZDUSAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:00:50 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <49EE09D9.2060209@dell.com>
Date: Tue, 21 Apr 2009 13:00:57 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: mjg59@srcf.ucam.org
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Add support for more dell-wmi hotkeys
References: <49ECBAE2.2080308@dell.com>
In-Reply-To: <49ECBAE2.2080308@dell.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF7EA5C0855333F77F934E727"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF7EA5C0855333F77F934E727
Content-Type: multipart/mixed;
 boundary="------------080906000100010301080404"

This is a multi-part message in MIME format.
--------------080906000100010301080404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi:

I've got another patch to stack on top of yesterday's patch for Eject.=20
These are more scancode/keycode combinations that will be supported via
WMI.  Many of them are commented out with an explanation of what their
true functionality is.

Regards
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com

--------------080906000100010301080404
Content-Type: text/x-patch;
 name="dell-wmi-additional-keys.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="dell-wmi-additional-keys.patch"

--- a/drivers/platform/x86/dell-wmi.c~	2009-04-21 11:19:04.000000000 -050=
0
+++ a/drivers/platform/x86/dell-wmi.c	2009-04-21 11:51:39.000000000 -0500=

@@ -49,8 +49,70 @@
 enum { KE_KEY, KE_SW, KE_END };
=20
 static struct key_entry dell_wmi_keymap[] =3D {
-	{KE_KEY, 0xe045, KEY_PROG1},
 	{KE_KEY, 0xe009, KEY_EJECTCD},
+   =20
+    /* Inside the structure for a brightness keycode, a new brightness
+     * level will be reported after the scancode (at offset 6)
+     */
+    {KE_KEY, 0xe006, KEY_BRIGHTNESSUP},
+    {KE_KEY, 0xe005, KEY_BRIGHTNESSDOWN},
+   =20
+    /* The volume hotkeys are here so that the the OS
+     * can be notified and show an OSD. The keys will still
+     * send out a scan code via the EC.
+    {KE_KEY, 0xe030, KEY_VOLUMEUP},
+    {KE_KEY, 0xe02e, KEY_VOLUMEDOWN},
+    {KE_KEY, 0xe020, KEY_MUTE},
+    */
+   =20
+    /* A majority of platforms support a simple toggle event, but
+     * some actually have support to raise or lower the backlit keyboard=

+     * brightness with different keys.
+     * The brightness is changed by the EC, these are here just to repor=
t
+     * that information to the OS to show an OSD.
+    {KE_KEY, 0xe00c, KEY_KBDILLUMTOGGLE},
+    {KE_KEY, 0xe033, KEY_KBDILLUMUP},
+    {KE_KEY, 0xe034, KEY_KBDILLUMDOWN},
+    */
+   =20
+    /* Inside the structure for a display switch, the next device is
+     * reported at offset 6, the active devices at offset 8, and the
+     * attached devices at offset 10
+     */
+    {KE_KEY, 0xe00b, KEY_DISPLAYTOGGLE},
+
+    /* This is actually for all radios on one button */
+    {KE_SW, 0xe008, KEY_WLAN},
+
+    /* Wifi Catcher */
+    {KE_KEY, 0xe011, KEY_PROG1},
+
+    /* Battery health status button */
+    {KE_KEY, 0xe007, KEY_BATTERY},
+   =20
+    /* This is the scan code sent when there is a BIOS error detected.
+     * What happens in these situations will need to be further elaborat=
ed
+     * upon
+    {KE_KEY, 0xe00d, error scan code},
+    */
+
+    /* Ambient light sensor is actually toggled by the BIOS and/or EC.
+     * This is for informative purposes of notifying the OS via an OSD.
+     * The new status will be at offset 6, the current limit at offset 8=

+     * and the absolute limit at offset 10
+    {KE_KEY, 0xe013, ambient light sensor code},
+    */
+
+    /* The *lock keys are here so that the the OS
+     * can be notified and show an OSD. The keys will still
+     * send out a scan code via the EC.
+     * If the system contains LEDs for these buttons, the WMI
+     * events will not be sent out
+    {KE_KEY, 0x003a, KEY_CAPSLOCK},
+    {KE_KEY, 0xe045, KEY_NUMLOCK},
+    {KE_KEY, 0xe046, KEY_SCROLLLOCK},
+    */
+   =20
 	{KE_END, 0}
 };
=20

--------------080906000100010301080404--

--------------enigF7EA5C0855333F77F934E727
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknuCdkACgkQ2CrZjkA73YuvLgCfdCWtJz5cmonQFDrD4tgisMjE
m/0An3md+fHfjlcgmQAbE3fu656yDvSg
=AKA6
-----END PGP SIGNATURE-----

--------------enigF7EA5C0855333F77F934E727--
