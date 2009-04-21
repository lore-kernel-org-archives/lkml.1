Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbZDUSDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbZDUSDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbZDUSDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:03:14 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:29455 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbZDUSDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:03:12 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <49EE0A64.9000506@dell.com>
Date: Tue, 21 Apr 2009 13:03:16 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: mjg59@srcf.ucam.org
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Mark OSD type scancodes
References: <49ECBAE2.2080308@dell.com>
In-Reply-To: <49ECBAE2.2080308@dell.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE834FA3340A35640224A1ED2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE834FA3340A35640224A1ED2
Content-Type: multipart/mixed;
 boundary="------------040400020306010702010406"

This is a multi-part message in MIME format.
--------------040400020306010702010406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi:

This patch introduces a new scan code type for the purpose of events
that shouldn't send a keycode but the WMI event is still relevant.=20
Eventually, these will need to be hooked up to the proper sysfs and
procfs interfaces for those types of events.

Regards
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com

--------------040400020306010702010406
Content-Type: text/x-patch;
 name="dell-wmi-osd-events.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="dell-wmi-osd-events.patch"

--- a/drivers/platform/x86/dell-wmi.c~	2009-04-21 12:56:26.000000000 -050=
0
+++ b/drivers/platform/x86/dell-wmi.c	2009-04-21 12:54:41.000000000 -0500=

@@ -46,7 +46,7 @@
 	u16 keycode;
 };
=20
-enum { KE_KEY, KE_SW, KE_END };
+enum { KE_KEY, KE_SW, KE_OSD, KE_END };
=20
 static struct key_entry dell_wmi_keymap[] =3D {
 	{KE_KEY, 0xe009, KEY_EJECTCD},
@@ -59,21 +59,20 @@
    =20
     /* The volume hotkeys are here so that the the OS
      * can be notified and show an OSD. The keys will still
-     * send out a scan code via the EC.
-    {KE_KEY, 0xe030, KEY_VOLUMEUP},
-    {KE_KEY, 0xe02e, KEY_VOLUMEDOWN},
-    {KE_KEY, 0xe020, KEY_MUTE},
-    */
+     * send out a scan code via the EC. */
+    {KE_OSD, 0xe030, KEY_VOLUMEUP},
+    {KE_OSD, 0xe02e, KEY_VOLUMEDOWN},
+    {KE_OSD, 0xe020, KEY_MUTE},
+   =20
    =20
     /* A majority of platforms support a simple toggle event, but
      * some actually have support to raise or lower the backlit keyboard=

      * brightness with different keys.
      * The brightness is changed by the EC, these are here just to repor=
t
-     * that information to the OS to show an OSD.
-    {KE_KEY, 0xe00c, KEY_KBDILLUMTOGGLE},
-    {KE_KEY, 0xe033, KEY_KBDILLUMUP},
-    {KE_KEY, 0xe034, KEY_KBDILLUMDOWN},
-    */
+     * that information to the OS to show an OSD. */
+    {KE_OSD, 0xe00c, KEY_KBDILLUMTOGGLE},
+    {KE_OSD, 0xe033, KEY_KBDILLUMUP},
+    {KE_OSD, 0xe034, KEY_KBDILLUMDOWN},
    =20
     /* Inside the structure for a display switch, the next device is
      * reported at offset 6, the active devices at offset 8, and the
@@ -82,7 +81,7 @@
     {KE_KEY, 0xe00b, KEY_DISPLAYTOGGLE},
=20
     /* This is actually for all radios on one button */
-    {KE_KEY, 0xe008, KEY_WLAN},
+    {KE_SW, 0xe008, SW_RFKILL_ALL},
=20
     /* Wifi Catcher */
     {KE_KEY, 0xe011, KEY_PROG1},
@@ -99,19 +98,17 @@
     /* Ambient light sensor is actually toggled by the BIOS and/or EC.
      * This is for informative purposes of notifying the OS via an OSD.
      * The new status will be at offset 6, the current limit at offset 8=

-     * and the absolute limit at offset 10
-    {KE_KEY, 0xe013, ambient light sensor code},
-    */
+     * and the absolute limit at offset 10 */
+    {KE_OSD, 0xe013, LED_MISC},
=20
     /* The *lock keys are here so that the the OS
      * can be notified and show an OSD. The keys will still
      * send out a scan code via the EC.
      * If the system contains LEDs for these buttons, the WMI
-     * events will not be sent out
-    {KE_KEY, 0x003a, KEY_CAPSLOCK},
-    {KE_KEY, 0xe045, KEY_NUMLOCK},
-    {KE_KEY, 0xe046, KEY_SCROLLLOCK},
-    */
+     * events will not be sent out */
+    {KE_OSD, 0x003a, LED_CAPSL},
+    {KE_OSD, 0xe045, LED_NUML},
+    {KE_OSD, 0xe046, LED_SCROLLL},
    =20
 	{KE_END, 0}
 };
@@ -223,6 +220,10 @@
 			set_bit(EV_SW, dell_wmi_input_dev->evbit);
 			set_bit(key->keycode, dell_wmi_input_dev->swbit);
 			break;
+        case KE_OSD:
+            /* TODO, hook up to the right proc or sysfs interface for sh=
owing
+             * these status bits */
+            break;
 		}
 	}
=20

--------------040400020306010702010406--

--------------enigE834FA3340A35640224A1ED2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknuCmQACgkQ2CrZjkA73YuchACfYsu0RpXU0TJCvv/gYBvfsvQI
hukAoICOE+RsczlbyAUJ+PP1IAmcl6aH
=3WFJ
-----END PGP SIGNATURE-----

--------------enigE834FA3340A35640224A1ED2--
