Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbXFVGHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbXFVGHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 02:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbXFVGHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 02:07:37 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:57236 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbXFVGHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 02:07:36 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Failure to properly reinit i8042 post suspend-to-ram
Date: Fri, 22 Jun 2007 16:07:33 +1000
User-Agent: KMail/1.9.6
Cc: dmitry.torokhov@gmail.com
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1589555.YTJeM2GKqB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706221607.33274.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1589555.YTJeM2GKqB
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

I have recently begun to try and use suspend to ram more, and have an=20
intermittent problem. Actually, it's a couple of (possibly related) problem=
s,=20
but I'll start with the one that's easiest.

Sometimes, when I resume, the keyboard stops responding. I then need to hol=
d=20
down the power button for 4 seconds. At the next boot, things are still not=
=20
right. The i8042 controller seems to be confused about it's mode, because I=
=20
get the following differences in dmesg to a 'normal' boot:

=2D-- good-boot-dmesg-no-timestamp.txt	2007-06-22 15:54:03.000000000 +1000
+++ problem-boot-dmesg-no-timestamp.txt	2007-06-22 15:54:18.000000000 +1000
@@ -203,14 +203,11 @@
 pnp: the driver 'i8042 aux' has been registered
 pnp: match found with the PnP device '00:01' and the driver 'i8042 aux'
 at 0x60,0x64 irq 1,12
=2Di8042.c: Detected active multiplexing controller, rev 1.1.
 serio: i8042 KBD port at 0x60,0x64 irq 1
=2Dserio: i8042 AUX0 port at 0x60,0x64 irq 12
=2Dserio: i8042 AUX1 port at 0x60,0x64 irq 12
=2Dserio: i8042 AUX2 port at 0x60,0x64 irq 12
=2Dserio: i8042 AUX3 port at 0x60,0x64 irq 12
+serio: i8042 AUX port at 0x60,0x64 irq 12
 mice: PS/2 mouse device common for all mice
 input: PC Speaker as /class/input/input0
+input: AT Translated Set 2 keyboard as /class/input/input1
 pnp: the driver 'rtc_cmos' has been registered
 pnp: match found with the PnP device '00:03' and the driver 'rtc_cmos'
 rtc_cmos: dev (254:0)

I've been able to log in remotely after suspending to ram, and see the "fai=
led=20
to resume active multiplexor" message in dmesg at that stage. Dmitry (or=20
others), is this a known issue? I'm more than happy to probe further if not.

In case it's relevant, the other issue is that sometimes the hard drive sta=
ys=20
on constantly and the system becomes unresponsive. The controller is an=20
ALI15X3. I'm using the old drivers.

Nigel

--nextPart1589555.YTJeM2GKqB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGe2clN0y+n1M3mo0RAmJvAJwJFHdiA+9XbVMcPNXw3a8hGrTJxgCgmjN3
ztBxRctuEGXiTJAMDZdprKI=
=bQCc
-----END PGP SIGNATURE-----

--nextPart1589555.YTJeM2GKqB--
