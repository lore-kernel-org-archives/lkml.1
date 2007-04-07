Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbXDGX07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbXDGX07 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 19:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXDGX07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 19:26:59 -0400
Received: from b01.ext.isohunt.com ([208.71.112.51]:55938 "EHLO
	mail.isohunt.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751592AbXDGX06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 19:26:58 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Apr 2007 19:26:58 EDT
Date: Sat, 7 Apr 2007 16:20:19 -0700
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: "Robin H. Johnson" <robbat2@gentoo.org>, mpm@selenic.com, mingo@redhat.com
Subject: netconsole module unload broken between 2.6.19 and 2.6.20 (and
	still broken as of 2.6.21-rc6)
Message-ID: <20070407232019.GC16376@curie-int.orbis-terrarum.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(Please CC me on emails, I'm not on LKML).

Somewhere between 2.6.19 and 2.6.20, unloading of the netconsole module
got broken. It's still broken as of 2.6.21-rc6.

If you try to unload the module, the rmmod/modprobe-r just sits there
forever. I can reproduce it on tg3, forcedeth and e1000 hardware (all in
various Opteron machines)

Looking at the differences in netconsole itself between .19 and .20,
they are extremely small, so I'd guess that the problem probably lies in
netpoll itself.

Originally, I was trying to unload the module to reconfigure the log
destination - maybe a sysfs interface for (re-)configuration would be a
good addition as well?

--=20
Robin Hugh Johnson
Gentoo Linux Developer & Council Member
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.2 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks - The text below is a digital signature. If it doesn't make any sense to you, ignore it.

iD8DBQFGGCczPpIsIjIzwiwRAh7RAJ9t4pAmMLT20mA6VGJ/zHVgoDJyygCeIrnW
9TbtPookMUpNWWCrSa+Z9cA=
=izhQ
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
