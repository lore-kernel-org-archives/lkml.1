Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZJFCCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZJFCCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 22:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZJFCCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 22:02:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60154 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbZJFCCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 22:02:49 -0400
Date: Tue, 6 Oct 2009 13:02:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: mfd tree build failure
Message-Id: <20091006130202.5e18a332.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_Oct_2009_13_02_02_+1100_iBWot3P=UnP1irTW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Oct_2009_13_02_02_+1100_iBWot3P=UnP1irTW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/built-in.o: In function `pm8607_write_device':
88pm8607.c:(.text+0xd02e9): undefined reference to `i2c_master_send'
drivers/built-in.o: In function `pm8607_read_device':
88pm8607.c:(.text+0xd033b): undefined reference to `i2c_master_send'
88pm8607.c:(.text+0xd035c): undefined reference to `i2c_master_recv'
drivers/built-in.o: In function `pm8607_init':
88pm8607.c:(.init.text+0xa9bd): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `pm8607_probe':
88pm8607.c:(.devinit.text+0x4db6): undefined reference to `mfd_add_devices'
drivers/built-in.o: In function `pm8607_exit':
88pm8607.c:(.exit.text+0x598): undefined reference to `i2c_del_driver'
drivers/built-in.o: In function `pm8607_remove':
88pm8607.c:(.devexit.text+0x198): undefined reference to `mfd_remove_device=
s'

Obviously caused by commit 9ec6cd8f2235ddeee5b39068956f14238a12a617
("mfd: Add 88PM8607 driver").

This build has CONFIG_I2C=3Dm and CONFIG_MFD_CORE=3Dm.

I have used the version of the mfd tree form next-20091005 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Oct_2009_13_02_02_+1100_iBWot3P=UnP1irTW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrKpRoACgkQjjKRsyhoI8xtTgCfa1x3CfmOs3HbefZeR/4Nw8g5
118AoLQAMmh1lQ/pqxzwZJKqzp29+WYr
=18is
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Oct_2009_13_02_02_+1100_iBWot3P=UnP1irTW--
