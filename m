Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbZKXFhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbZKXFhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 00:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbZKXFhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 00:37:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41314 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZKXFhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 00:37:53 -0500
Date: Tue, 24 Nov 2009 16:37:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: mfd tree build failure
Message-Id: <20091124163753.381d9a83.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Nov_2009_16_37_53_+1100_Zt2GNVQFs.ijk/XB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Nov_2009_16_37_53_+1100_Zt2GNVQFs.ijk/XB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/built-in.o: In function `wm831x_i2c_remove':
wm831x-core.c:(.text+0xd108b): undefined reference to `mfd_remove_devices'
drivers/built-in.o: In function `wm831x_i2c_write_device':
wm831x-core.c:(.text+0xd119c): undefined reference to `i2c_master_send'
drivers/built-in.o: In function `wm831x_i2c_read_device':
wm831x-core.c:(.text+0xd1208): undefined reference to `i2c_master_send'
wm831x-core.c:(.text+0xd1237): undefined reference to `i2c_master_recv'
drivers/built-in.o: In function `wm831x_i2c_probe':
wm831x-core.c:(.text+0xd2099): undefined reference to `mfd_add_devices'
wm831x-core.c:(.text+0xd20cd): undefined reference to `mfd_add_devices'
wm831x-core.c:(.text+0xd2105): undefined reference to `mfd_add_devices'
wm831x-core.c:(.text+0xd2139): undefined reference to `mfd_add_devices'
wm831x-core.c:(.text+0xd21dd): undefined reference to `mfd_add_devices'
wm831x-core.c:(.text+0xd22c3): undefined reference to `mfd_remove_devices'
drivers/built-in.o: In function `wm831x_i2c_init':
wm831x-core.c:(.init.text+0xae6b): undefined reference to `i2c_register_dri=
ver'
drivers/built-in.o: In function `wm831x_i2c_exit':
wm831x-core.c:(.exit.text+0x522): undefined reference to `i2c_del_driver'

Caused by commit 4f7231a3ff624ad8a0fdace424b10a8b262071cf ("mfd: Don't
allow wm831x to be built as a module").  CONFIG_MFD_CORE is "m" and
CONFIG_I2C is "m" while CONFIG_MFD_WM831X is "y".  "select" is a real
problem :-(

I have used the version of the mfd tree from next-20091120 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Nov_2009_16_37_53_+1100_Zt2GNVQFs.ijk/XB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksLcTEACgkQjjKRsyhoI8x/EwCgvD7+e0yd4ifJcJgvV0//wDWg
6GIAnjBXM4YvOEbOID3hoVtx3Si4KbjM
=FI8l
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Nov_2009_16_37_53_+1100_Zt2GNVQFs.ijk/XB--
