Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbZLON16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbZLON16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 08:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759623AbZLON15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 08:27:57 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:33736 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbZLON14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 08:27:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=gxQDSyDOFLE1M0TnKY2bbZjzCNntiBrBcNNgz69YPvO8Wu1lipRypxppyJaDqTcBLr
         tDt67jKasbnTzqbFPDmH5zs8PBowqho+EDsYNr6MUv+K8gjqCJF4YKYMgmbOO1FttC5M
         gVKebQM0roRGJK91ZJE6US2HKzurSsJNY3CIw=
MIME-Version: 1.0
Date: Tue, 15 Dec 2009 21:27:50 +0800
Message-ID: <6304b52b0912150527v48056ccam8d1c318bcd7e085b@mail.gmail.com>
Subject: =?windows-1252?Q?=5BPATCH=5D_quota=3A_integer_constant_is_too_large_for_=91?=
	=?windows-1252?Q?long=92_type_in?=
From: Jerry Leo <jerryleo860202@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd11308440157047ac45b1a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd11308440157047ac45b1a
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi, Jan Kara,

the Patch is for this:

CC      fs/quota/quota_v2.o
fs/quota/quota_v2.c: In function =91v2_read_file_info=92:
fs/quota/quota_v2.c:123: warning: integer constant is too large for =91long=
=92 type
fs/quota/quota_v2.c:124: warning: integer constant is too large for =91long=
=92 type


Can this patch be fixed?


diff --git a/linux-2.6/fs/quota/quota_v2.c.orig b/linux-2.6/fs/quota/quota_=
v2.c
index 3dfc23e..be9ea1e 100644
--- a/linux-2.6/fs/quota/quota_v2.c.orig
+++ b/linux-2.6/fs/quota/quota_v2.c
@@ -120,8 +120,8 @@ static int v2_read_file_info(struct super_block
*sb, int type)
                info->dqi_maxilimit =3D 0xffffffff;
        } else {
                /* used space is stored as unsigned 64-bit value */
-               info->dqi_maxblimit =3D 0xffffffffffffffff;       /* 2^64-1=
 */
-               info->dqi_maxilimit =3D 0xffffffffffffffff;
+               info->dqi_maxblimit =3D 0xFFFFFFFFFFFFFFFFLL;     /* 2^64-1=
 */
+               info->dqi_maxilimit =3D 0xFFFFFFFFFFFFFFFFLL;
        }
        info->dqi_bgrace =3D le32_to_cpu(dinfo.dqi_bgrace);
        info->dqi_igrace =3D le32_to_cpu(dinfo.dqi_igrace);


Best Regards!

                                                                   JerryLeo

--000e0cd11308440157047ac45b1a
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g38pkm540

ZGlmZiAtLWdpdCBhL2xpbnV4LTIuNi9mcy9xdW90YS9xdW90YV92Mi5jLm9yaWcgYi9saW51eC0y
LjYvZnMvcXVvdGEvcXVvdGFfdjIuYwppbmRleCAzZGZjMjNlLi5iZTllYTFlIDEwMDY0NAotLS0g
YS9saW51eC0yLjYvZnMvcXVvdGEvcXVvdGFfdjIuYy5vcmlnCisrKyBiL2xpbnV4LTIuNi9mcy9x
dW90YS9xdW90YV92Mi5jCkBAIC0xMjAsOCArMTIwLDggQEAgc3RhdGljIGludCB2Ml9yZWFkX2Zp
bGVfaW5mbyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBpbnQgdHlwZSkKIAkJaW5mby0+ZHFpX21h
eGlsaW1pdCA9IDB4ZmZmZmZmZmY7CiAJfSBlbHNlIHsKIAkJLyogdXNlZCBzcGFjZSBpcyBzdG9y
ZWQgYXMgdW5zaWduZWQgNjQtYml0IHZhbHVlICovCi0JCWluZm8tPmRxaV9tYXhibGltaXQgPSAw
eGZmZmZmZmZmZmZmZmZmZmY7CS8qIDJeNjQtMSAqLwotCQlpbmZvLT5kcWlfbWF4aWxpbWl0ID0g
MHhmZmZmZmZmZmZmZmZmZmZmOworCQlpbmZvLT5kcWlfbWF4YmxpbWl0ID0gMHhGRkZGRkZGRkZG
RkZGRkZGTEw7CS8qIDJeNjQtMSAqLworCQlpbmZvLT5kcWlfbWF4aWxpbWl0ID0gMHhGRkZGRkZG
RkZGRkZGRkZGTEw7CiAJfQogCWluZm8tPmRxaV9iZ3JhY2UgPSBsZTMyX3RvX2NwdShkaW5mby5k
cWlfYmdyYWNlKTsKIAlpbmZvLT5kcWlfaWdyYWNlID0gbGUzMl90b19jcHUoZGluZm8uZHFpX2ln
cmFjZSk7Cg==
--000e0cd11308440157047ac45b1a--
