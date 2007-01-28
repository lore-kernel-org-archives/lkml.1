Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbXA1MJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbXA1MJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 07:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXA1MJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 07:09:13 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:40417 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbXA1MJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 07:09:12 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: markus.lidel@shadowconnect.com
Subject: [patch] use __u8/__u32 in userspace ioctl defines for I2O
Date: Sun, 28 Jan 2007 07:09:47 -0500
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_MKJvFY8g9SDivZg"
Message-Id: <200701280709.48793.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_MKJvFY8g9SDivZg
Content-Type: multipart/signed;
  boundary="nextPart2303355.5RN38299D7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2303355.5RN38299D7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

two of the ioctl defines in the i2o-dev.h header break when used from=20
userspace as they are defined in terms of u8/u32 ... trivial attached patch=
=20
fixes this to use __u8/__u32
=2Dmike

--nextPart2303355.5RN38299D7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iQIVAwUARbySjEFjO5/oN/WBAQLWGg//TzBOvs8kcj2xqhKJm4chNK0nDXHp9aBQ
AlCxbvrLBGi3sVmJjA5frhU5Z8qKBT7HS8M/jNp1QSMB7rLR2WNQlCxz6Zx4dpK0
68oH/yIX2WPn+CjIRNfkbiJYfuNHeUMbGx8sx4mDdbdu3Rc2SoBoLESZMuYDdVwP
a+kV5f8b+wv31ZCNDpxhglgykUMwO2efwiEZuD0caiWDoDgPB912hfvpdkF4JTGe
izE/znbeaavLoGytsBSE68Q4M8TnJwY5NKv6OHnQDkbmK73OaEdAjxWWynCxNbiT
5TMBHGbEg73GjxskpTJ6FFvCrj3XEOq24x1yLPDn7o9iIhif9AS3rruAKPf4iU10
GblQI0lgMMAtsEje1Xk7T0W27qVyg7Bd6O4nMSn7wZrItOx9oWotzRhTbHFe8H0S
KHa/CR2d/4l7OuBNXgQOzUggcBaADWIQAtWvSpulbZUEAL01gJvqUVt2/Bfqa/Cx
eTpsbkck0hG+l1DyqsFEhyH/XWlWh8ZLeCGicYqs+oeBItEC6PyU1VmHh/pmdUVs
ArvU38Au/f4usiRMgdlBnkaTW5F0EFeb9fO+Yhmo/pYz94S+1tbjMpdz5NGfsDHl
y4ybEABdITy+mz45XShkdXNIfS+IVacE8SDhhzBeMGQKf8jUV4hjnVmhVzw1DrwM
Bk1MGrZ1bGs=
=29zf
-----END PGP SIGNATURE-----

--nextPart2303355.5RN38299D7--

--Boundary-00=_MKJvFY8g9SDivZg
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-use-__-types-in-i2o-header.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="linux-use-__-types-in-i2o-header.patch"

Make sure exported I2O ioctls utilize userspace safe types.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>

--- a/include/linux/i2o-dev.h
+++ b/include/linux/i2o-dev.h
@@ -24,12 +24,13 @@
 #define MAX_I2O_CONTROLLERS	32
 
 #include <linux/ioctl.h>
+#include <linux/types.h>
 
 /*
  * I2O Control IOCTLs and structures
  */
 #define I2O_MAGIC_NUMBER	'i'
-#define I2OGETIOPS		_IOR(I2O_MAGIC_NUMBER,0,u8[MAX_I2O_CONTROLLERS])
+#define I2OGETIOPS		_IOR(I2O_MAGIC_NUMBER,0,__u8[MAX_I2O_CONTROLLERS])
 #define I2OHRTGET		_IOWR(I2O_MAGIC_NUMBER,1,struct i2o_cmd_hrtlct)
 #define I2OLCTGET		_IOWR(I2O_MAGIC_NUMBER,2,struct i2o_cmd_hrtlct)
 #define I2OPARMSET		_IOWR(I2O_MAGIC_NUMBER,3,struct i2o_cmd_psetget)
@@ -37,7 +38,7 @@
 #define I2OSWDL 		_IOWR(I2O_MAGIC_NUMBER,5,struct i2o_sw_xfer)
 #define I2OSWUL 		_IOWR(I2O_MAGIC_NUMBER,6,struct i2o_sw_xfer)
 #define I2OSWDEL		_IOWR(I2O_MAGIC_NUMBER,7,struct i2o_sw_xfer)
-#define I2OVALIDATE		_IOR(I2O_MAGIC_NUMBER,8,u32)
+#define I2OVALIDATE		_IOR(I2O_MAGIC_NUMBER,8,__u32)
 #define I2OHTML 		_IOWR(I2O_MAGIC_NUMBER,9,struct i2o_html)
 #define I2OEVTREG		_IOW(I2O_MAGIC_NUMBER,10,struct i2o_evt_id)
 #define I2OEVTGET		_IOR(I2O_MAGIC_NUMBER,11,struct i2o_evt_info)

--Boundary-00=_MKJvFY8g9SDivZg--
