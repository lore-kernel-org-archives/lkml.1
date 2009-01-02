Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbZABGGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbZABGGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 01:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbZABGGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 01:06:11 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:53708 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZABGGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 01:06:10 -0500
X-Greylist: delayed 1495 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2009 01:06:10 EST
Date: Fri, 2 Jan 2009 06:41:00 +0100
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [PATCH] Missing v4l2_prio_close in radio_release
Message-ID: <20090102064100.2e27464e@laptop.hypervisor.org>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2touK0xRjVM4kyU/Eu/8odY";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2touK0xRjVM4kyU/Eu/8odY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The radio_release function of the BTTV driver is missing a call to
v4l2_prio_close. As a result, after the radio device has been opened at
least once (e.g., by HAL during bootup), v4l2_priority will never drop below
V4L2_PRIORITY_INTERACTIVE again. With the following patch against 2.6.28,
applications that run with V4L2_PRIORITY_BACKGROUND are able to open devices
again. Previous Linux versions are affected as well.


Signed-off-by: Udo Steinberg <udo@hypervisor.org>

--- linux-2.6.28/drivers/media/video/bt8xx/bttv-driver.c	2008-10-10 00:13:5=
3.000000000 +0200
+++ linux-2.6.28/drivers/media/video/bt8xx/bttv-driver.new	2009-01-02 06:23=
:38.000000000 +0100
@@ -3473,6 +3474,7 @@
 	struct bttv *btv =3D fh->btv;
 	struct rds_command cmd;
=20
+	v4l2_prio_close(&btv->prio,&fh->prio);
 	file->private_data =3D NULL;
 	kfree(fh);
=20

--Sig_/2touK0xRjVM4kyU/Eu/8odY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkldqO0ACgkQnhRzXSM7nSmGLwCfdZwbJTX/SpI76do1emTobvIv
vrUAn1JHz2EL+JQyVkwpbcFX9LEW8DrX
=HwOM
-----END PGP SIGNATURE-----

--Sig_/2touK0xRjVM4kyU/Eu/8odY--
