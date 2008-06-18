Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbYFRQud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbYFRQud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYFRQuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:50:23 -0400
Received: from trinity.fluff.org ([89.145.97.151]:45554 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYFRQuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:50:23 -0400
Date: Wed, 18 Jun 2008 17:50:21 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: fix vector initialisation when !CONFIG_KGDB
Message-ID: <20080618165021.GJ10351@trinity.fluff.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

It seems in the changes for adding CONFIG_KGDB that the ARM
trap initialisation has been turned off if the configuration
is not enabled. If CONFIG_KGDB is not set, the system locks
up as soon as the kernel turns the IRQs on for the first
time in init/main.c.

The fix is to remove the dependency on calling early_trap_init()
on CONFIG_KGDB, so that the vectors are initialised before
the init sequence enables the IRQs.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

--- linux-2.6.26-rc6-q1.orig/arch/arm/kernel/setup.c	2008-06-18 15:17:31.00=
0000000 +0100
+++ linux-2.6.26-rc6-q1/arch/arm/kernel/setup.c	2008-06-18 15:17:45.0000000=
00 +0100
@@ -855,9 +855,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
=20
-#if defined(CONFIG_KGDB)
 	early_trap_init();
-#endif
 }


--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIWTzMJZCApG2L7OYRApqrAJsFyl+1qq2lTUQ97tv240KUi6WsxQCZAfLe
XIfrNA+VqpfQLsPmPdvwYe0=
=duN8
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
