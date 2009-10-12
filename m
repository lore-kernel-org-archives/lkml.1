Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbZJLC1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbZJLC1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 22:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZJLC1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 22:27:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36506 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbZJLC1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 22:27:12 -0400
Date: Mon, 12 Oct 2009 13:26:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Haojian Zhuang <haojian.zhuang@gmail.com>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: linux-next: voltage tree build failure
Message-Id: <20091012132628.2f709e40.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__12_Oct_2009_13_26_28_+1100_TThlQx=AEvkzdf_/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Oct_2009_13_26_28_+1100_TThlQx=AEvkzdf_/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Liam,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/built-in.o: In function `pm8607_write_device':
88pm8607.c:(.text+0xd1359): undefined reference to `i2c_master_send'
drivers/built-in.o: In function `pm8607_read_device':
88pm8607.c:(.text+0xd13ab): undefined reference to `i2c_master_send'
88pm8607.c:(.text+0xd13cc): undefined reference to `i2c_master_recv'
drivers/built-in.o: In function `pm8607_init':
88pm8607.c:(.init.text+0xaa22): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `pm8607_probe':
88pm8607.c:(.devinit.text+0x50fb): undefined reference to `mfd_add_devices'
drivers/built-in.o: In function `pm8607_exit':
88pm8607.c:(.exit.text+0x5de): undefined reference to `i2c_del_driver'
drivers/built-in.o: In function `pm8607_remove':
88pm8607.c:(.devexit.text+0x1cc): undefined reference to `mfd_remove_device=
s'

Caused by commit 258e3427f83a573d738344c2f5499da5e026e1df ("regulator:
add 88PM8607 PMIC driver").  This is the same driver that has caused the
mfd tree to fail in the same way since next-20091006.  I have used the
version of the voltage tree from next-20091009 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__12_Oct_2009_13_26_28_+1100_TThlQx=AEvkzdf_/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrSk9QACgkQjjKRsyhoI8w8jACfcdXu86AvEWMgp4Mg6MYCUEZv
ENgAnRqMSZAlsAmXbSTDbTnnb6uPz5AR
=atb5
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Oct_2009_13_26_28_+1100_TThlQx=AEvkzdf_/--
