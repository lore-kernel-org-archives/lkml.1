Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbZBKWFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbZBKWFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZBKWFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:05:09 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:51862 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbZBKWFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:05:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type;
        b=Tkll8tVuMyS14y1Q/UHrdqG47N/90SJQZw+xbCPZJfJ5ZNRM1+my3wDiGVvqwZScsA
         vhpEjtrxe2ENgYxXw5A+n+/QzSb9podCtV1wtKKHpSbUFfggj2mljbEqm2RsXhhliRRg
         zdrPNlSHM5Y/i0xLOEPGUzsY0DcNWfKHHYJcY=
Date: Wed, 11 Feb 2009 23:04:19 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: PATCH - Also update values to s1d13xxxfb.h
Message-Id: <20090211230419.fc987c98.kristoffer.ericson@gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Feb_2009_23_04_19_+0100_ac/M_CRq9=E+Pl66"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Feb_2009_23_04_19_+0100_ac/M_CRq9=E+Pl66
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__11_Feb_2009_23_04_19_+0100_.iPEufqQs4AE5cXv"


--Multipart=_Wed__11_Feb_2009_23_04_19_+0100_.iPEufqQs4AE5cXv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


This pach updates the s1d13xxxfb.h file to reflect the recent
changes to the driver.

Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

diff --git a/include/video/s1d13xxxfb.h b/include/video/s1d13xxxfb.h
index fe41b84..c3b2a2a 100644
--- a/include/video/s1d13xxxfb.h
+++ b/include/video/s1d13xxxfb.h
@@ -14,13 +14,16 @@
 #define	S1D13XXXFB_H
=20
 #define S1D_PALETTE_SIZE		256
-#define S1D13506_CHIP_REV		4	/* expected chip revision number for s1d13506=
 */
-#define S1D13806_CHIP_REV		7	/* expected chip revision number for s1d13806=
 */
-#define S1D_FBID			"S1D13806"
-#define S1D_DEVICENAME			"s1d13806fb"
+#define S1D_FBID			"S1D13xxx"
+#define S1D_DEVICENAME			"s1d13xxxfb"
+
+/* S1DREG_REV_CODE register =3D prod_id (6 bits) + revision (2 bits) */
+#define S1D13505_PROD_ID		0x3	/* 000011 */
+#define S1D13506_PROD_ID		0x4	/* 000100 */
+#define S1D13806_PROD_ID		0x7	/* 000111 */
=20
 /* register definitions (tested on s1d13896) */
-#define S1DREG_REV_CODE			0x0000	/* Revision Code Register */
+#define S1DREG_REV_CODE			0x0000	/* Prod + Rev Code Register */
 #define S1DREG_MISC			0x0001	/* Miscellaneous Register */
 #define S1DREG_GPIO_CNF0		0x0004	/* General IO Pins Configuration Register=
 0 */
 #define S1DREG_GPIO_CNF1		0x0005	/* General IO Pins Configuration Register=
 1 */
@@ -141,10 +144,11 @@ struct s1d13xxxfb_regval {
 	u8	value;
 };
=20
-
 struct s1d13xxxfb_par {
 	void __iomem	*regs;
 	unsigned char	display;
+	unsigned char	prod_id;
+	unsigned char	revision;
=20
 	unsigned int	pseudo_palette[16];
 #ifdef CONFIG_PM



--=20
Kristoffer Ericson <kristoffer.ericson@gmail.com>

--Multipart=_Wed__11_Feb_2009_23_04_19_+0100_.iPEufqQs4AE5cXv
Content-Type: application/octet-stream;
 name="s1d13xxxfb-proid-include-updated.patch"
Content-Disposition: attachment;
 filename="s1d13xxxfb-proid-include-updated.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvdmlkZW8vczFkMTN4eHhmYi5oIGIvaW5jbHVkZS92aWRlby9z
MWQxM3h4eGZiLmgKaW5kZXggZmU0MWI4NC4uYzNiMmEyYSAxMDA2NDQKLS0tIGEvaW5jbHVkZS92
aWRlby9zMWQxM3h4eGZiLmgKKysrIGIvaW5jbHVkZS92aWRlby9zMWQxM3h4eGZiLmgKQEAgLTE0
LDEzICsxNCwxNiBAQAogI2RlZmluZQlTMUQxM1hYWEZCX0gKIAogI2RlZmluZSBTMURfUEFMRVRU
RV9TSVpFCQkyNTYKLSNkZWZpbmUgUzFEMTM1MDZfQ0hJUF9SRVYJCTQJLyogZXhwZWN0ZWQgY2hp
cCByZXZpc2lvbiBudW1iZXIgZm9yIHMxZDEzNTA2ICovCi0jZGVmaW5lIFMxRDEzODA2X0NISVBf
UkVWCQk3CS8qIGV4cGVjdGVkIGNoaXAgcmV2aXNpb24gbnVtYmVyIGZvciBzMWQxMzgwNiAqLwot
I2RlZmluZSBTMURfRkJJRAkJCSJTMUQxMzgwNiIKLSNkZWZpbmUgUzFEX0RFVklDRU5BTUUJCQki
czFkMTM4MDZmYiIKKyNkZWZpbmUgUzFEX0ZCSUQJCQkiUzFEMTN4eHgiCisjZGVmaW5lIFMxRF9E
RVZJQ0VOQU1FCQkJInMxZDEzeHh4ZmIiCisKKy8qIFMxRFJFR19SRVZfQ09ERSByZWdpc3RlciA9
IHByb2RfaWQgKDYgYml0cykgKyByZXZpc2lvbiAoMiBiaXRzKSAqLworI2RlZmluZSBTMUQxMzUw
NV9QUk9EX0lECQkweDMJLyogMDAwMDExICovCisjZGVmaW5lIFMxRDEzNTA2X1BST0RfSUQJCTB4
NAkvKiAwMDAxMDAgKi8KKyNkZWZpbmUgUzFEMTM4MDZfUFJPRF9JRAkJMHg3CS8qIDAwMDExMSAq
LwogCiAvKiByZWdpc3RlciBkZWZpbml0aW9ucyAodGVzdGVkIG9uIHMxZDEzODk2KSAqLwotI2Rl
ZmluZSBTMURSRUdfUkVWX0NPREUJCQkweDAwMDAJLyogUmV2aXNpb24gQ29kZSBSZWdpc3RlciAq
LworI2RlZmluZSBTMURSRUdfUkVWX0NPREUJCQkweDAwMDAJLyogUHJvZCArIFJldiBDb2RlIFJl
Z2lzdGVyICovCiAjZGVmaW5lIFMxRFJFR19NSVNDCQkJMHgwMDAxCS8qIE1pc2NlbGxhbmVvdXMg
UmVnaXN0ZXIgKi8KICNkZWZpbmUgUzFEUkVHX0dQSU9fQ05GMAkJMHgwMDA0CS8qIEdlbmVyYWwg
SU8gUGlucyBDb25maWd1cmF0aW9uIFJlZ2lzdGVyIDAgKi8KICNkZWZpbmUgUzFEUkVHX0dQSU9f
Q05GMQkJMHgwMDA1CS8qIEdlbmVyYWwgSU8gUGlucyBDb25maWd1cmF0aW9uIFJlZ2lzdGVyIDEg
Ki8KQEAgLTE0MSwxMCArMTQ0LDExIEBAIHN0cnVjdCBzMWQxM3h4eGZiX3JlZ3ZhbCB7CiAJdTgJ
dmFsdWU7CiB9OwogCi0KIHN0cnVjdCBzMWQxM3h4eGZiX3BhciB7CiAJdm9pZCBfX2lvbWVtCSpy
ZWdzOwogCXVuc2lnbmVkIGNoYXIJZGlzcGxheTsKKwl1bnNpZ25lZCBjaGFyCXByb2RfaWQ7CisJ
dW5zaWduZWQgY2hhcglyZXZpc2lvbjsKIAogCXVuc2lnbmVkIGludAlwc2V1ZG9fcGFsZXR0ZVsx
Nl07CiAjaWZkZWYgQ09ORklHX1BNCg==

--Multipart=_Wed__11_Feb_2009_23_04_19_+0100_.iPEufqQs4AE5cXv--

--Signature=_Wed__11_Feb_2009_23_04_19_+0100_ac/M_CRq9=E+Pl66
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmTS2MACgkQPQls10ERAGc43wCbBOfXCgLIvsHUviMJy2SpuXQk
5MoAn3Wt/csnTIVMZrI+6oM/uFMSGwI4
=7c47
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Feb_2009_23_04_19_+0100_ac/M_CRq9=E+Pl66--
