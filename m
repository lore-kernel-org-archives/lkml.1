Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbYCNSiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbYCNSiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYCNSiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:38:01 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:41340 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbYCNSiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:38:00 -0400
Date: Fri, 14 Mar 2008 19:37:58 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH] THERMAL must not select HWMON
Message-ID: <20080314183758.GA15028@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Randy Dunlap <rdunlap@xenotime.net>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Zhang Rui <rui.zhang@intel.com>
References: <20080314175501.GA11107@wavehammer.waldi.eu.org> <20080314112112.c00cbcdd.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20080314112112.c00cbcdd.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2008 at 11:21:12AM -0700, Randy Dunlap wrote:

[ select forces HWMON to yes even if deps are never applicable ]

> Yes, that's a known & longstanding problem (that select does not
> follow/honor dependencies).

Okay.

So THERMAL can't select HWMON, instead it needs to do a proper depends.

Bastian

Signed-off-by: Bastian Blank <waldi@debian.org>
Cc: Zhang Rui <rui.zhang@intel.com>

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 3ab313e..394912c 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -4,7 +4,7 @@
=20
 menuconfig THERMAL
 	bool "Generic Thermal sysfs driver"
-	select HWMON
+	depends on HWMON
 	default y
 	help
 	  Generic Thermal Sysfs driver offers a generic mechanism for
--=20
You canna change the laws of physics, Captain; I've got to have thirty minu=
tes!

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEUEARECAAYFAkfaxgYACgkQnw66O/MvCNHMqgCgjXRiWk654h1O+wOdJOZ9bFng
JxYAljwihHvlP4rY6wH2qE1yn9zVwS0=
=J7nH
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
