Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYGYVhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYGYVhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYGYVg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:36:56 -0400
Received: from cl11.gs01.gridserver.com ([64.13.192.20]:42429 "EHLO
	cl11.gs01.gridserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbYGYVg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:36:56 -0400
X-Greylist: delayed 2126 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2008 17:36:56 EDT
From: Trever Fischer <wm161@wm161.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] cypress_m8 driver is broken with my GPS device
Date: Fri, 25 Jul 2008 17:00:41 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1341423.pZfRbgs0k4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200807251700.56399.wm161@wm161.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1341423.pZfRbgs0k4
Content-Type: multipart/mixed;
  boundary="Boundary-01=_57jiItyU7ZicpIR"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_57jiItyU7ZicpIR
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi, I've got a DeLORME Earthmate LT-20 USB GPS unit. A year or so ago it us=
ed=20
to work with the cypress_m8 driver, but now when I try to read from the=20
device, the kernel spits out:

drivers/usb/serial/cypress_m8.c: cypress_serial_control - failed to retriev=
e=20
serial line settings - -32
drivers/usb/serial/cypress_m8.c: cypress_m8 suspending failing port 3 -=20
interval might be too short

I dug into the source and created the attached patch. Its my first (albeit=
=20
tiny) patch to the linux kernel, so any feedback is graciously welcome.

--Boundary-01=_57jiItyU7ZicpIR
Content-Type: text/x-diff;
  charset="us-ascii";
  name="earthmate.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="earthmate.patch"

=2D-- /usr/src/kernels/linux-2.6.26/drivers/usb/serial/cypress_m8.c	2008-07=
=2D13 17:51:29.000000000 -0400
+++ ./drivers/usb/serial/cypress_m8.c	2008-07-25 16:49:53.000000000 -0400
@@ -410,6 +410,11 @@
 			/* set initial values in feature buffer */
 			memset(feature_buffer, 0, sizeof(feature_buffer));
=20
+			/* The LT-20 doesn't really work too well with trying to get the serial=
 settings. */
+			if (port->serial->dev->descriptor.idProduct =3D=3D PRODUCT_ID_EARTHMATE=
USB_LT20) {
+				return retval;
+			}
+
 			do {
 				retval =3D usb_control_msg(port->serial->dev,
 						usb_rcvctrlpipe(port->serial->dev, 0),

--Boundary-01=_57jiItyU7ZicpIR--

--nextPart1341423.pZfRbgs0k4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkiKPwgACgkQNg53/sQPKZgSmwCfc/4vsdom+wLXMmgZIHXAluDw
qWQAoJOD21pXBC/lmGZkuS/Z37nCRI51
=ZyaF
-----END PGP SIGNATURE-----

--nextPart1341423.pZfRbgs0k4--
