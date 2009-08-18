Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZHRIbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZHRIbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZHRIa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:30:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43251 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbZHRIa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:30:58 -0400
Date: Tue, 18 Aug 2009 18:30:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: suspend tree build failure
Message-Id: <20090818183049.8bde1ee6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_Aug_2009_18_30_49_+1000_sfpZCuVfD+K/ESEU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Aug_2009_18_30_49_+1000_sfpZCuVfD+K/ESEU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next build (i386 defconfig) failed like this:

drivers/base/power/main.c: In function 'device_pm_init':
drivers/base/power/main.c:59: error: 'struct dev_pm_info' has no member nam=
ed 'lock'

Caused by commit ea8e84f27325d9ddc7692f728a10e0a22cd59f52 ("PM: Introduce
core framework for run-time PM of I/O devices (rev. 17)") from the
suspend tree.  The i386 defconfig does not have CONFIG_PM_RUNTIME set but
does have CONFIG_PM_SLEEP=3Dy ...

I have reverted that commit for today.

When you add a new CONFIG variable, it is worth doing test builds both
with it turned on and turned off ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__18_Aug_2009_18_30_49_+1000_sfpZCuVfD+K/ESEU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqKZrkACgkQjjKRsyhoI8zhlQCgucpGMKrjfWoSV7I6ngCIKLB5
VhYAoI9YQVUZP6gGauhQqveJR6O86Bi0
=1Etz
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Aug_2009_18_30_49_+1000_sfpZCuVfD+K/ESEU--
