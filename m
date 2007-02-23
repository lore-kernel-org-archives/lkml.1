Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbXBWNaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbXBWNaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 08:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932339AbXBWNaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 08:30:23 -0500
Received: from RedStar.dorchain.net ([212.88.133.153]:58547 "EHLO
	Redstar.dorchain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336AbXBWNaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 08:30:12 -0500
Date: Fri, 23 Feb 2007 14:29:55 +0100
From: Joerg Dorchain <joerg@dorchain.net>
To: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Cc: linux-kernel@vger.kernel.org
Subject: [Patch] bug in gdth.c crashing machine
Message-ID: <20070223132955.GQ3250@Redstar.dorchain.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zKUz1/qH9cAHBnoy"
Content-Disposition: inline
X-message-flag: Formating hard disk. please wait...   10%...  20%...
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--zKUz1/qH9cAHBnoy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Achim,

wrt to your mail to the lkml from 13 Oct 2006 Message-ID:
<EF6AF37986D67948AD48624A3E5D93AFE72291@mtce2k01.adaptec.com>,
I'd be pleased if you could integrate the derived patch into a bugfix
release of the driver asap.

This bug kept me busy for three days, endangering  backup to tapes.

Patch is against vanilla 2.6.20.

Kind regards,

Joerg

Signed-off-by: Joerg Dorchain <joerg@dorchain.net>

--- gdth.c.orig	2007-02-23 12:48:56.000000000 +0100
+++ gdth.c	2007-02-23 12:51:44.000000000 +0100
@@ -3092,6 +3092,7 @@
             cmdp->u.raw64.direction  =3D=20
                 gdth_direction_tab[scp->cmnd[0]]=3D=3DDOU ? GDTH_DATA_OUT:=
GDTH_DATA_IN;
             memcpy(cmdp->u.raw64.cmd,scp->cmnd,16);
+            cmdp->u.raw64.sg_ranz    =3D 0;
         } else {
             cmdp->u.raw.reserved   =3D 0;
             cmdp->u.raw.mdisc_time =3D 0;
@@ -3108,6 +3109,7 @@
             cmdp->u.raw.direction  =3D=20
                 gdth_direction_tab[scp->cmnd[0]]=3D=3DDOU ? GDTH_DATA_OUT:=
GDTH_DATA_IN;
             memcpy(cmdp->u.raw.cmd,scp->cmnd,12);
+            cmdp->u.raw.sg_ranz    =3D 0;
         }
=20
         if (scp->use_sg) {

--zKUz1/qH9cAHBnoy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF3uxTjY4+4PdzvOARAvLgAJwKAHhquIXkk//DqXDFji04/GT2eQCfWpzu
+Cz5DEjRuPpNZgkQz6IljRI=
=9Hsc
-----END PGP SIGNATURE-----

--zKUz1/qH9cAHBnoy--
