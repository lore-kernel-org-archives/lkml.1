Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYJFReO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYJFReO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYJFRd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:33:58 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:39609 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbYJFRd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:33:57 -0400
Message-ID: <79c9d4530810061033g3630dc2dwabb4d3c2a3f17337@mail.gmail.com>
Date: Mon, 6 Oct 2008 13:33:56 -0400
From: "Jean-Marc Spaggiari" <jean-marc@spaggiari.org>
To: LKML <linux-kernel@vger.kernel.org>,
       "LM Sensors" <lm-sensors@lm-sensors.org>
Subject: [PATCH] Allow it87.c to handle IT8720
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_55141_27961942.1223314436172"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_55141_27961942.1223314436172
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The goal of this patch is to allow it87.c to handle IT8720 chipset
like IT8718 in order to retreive voltage, temperatures and fans speed
from sensors tools.

JMS

Patch also attached.

--- linux-2.6.27-rc8/drivers/hwmon/it87.c.orig  2008-10-02
09:04:44.000000000 -0400
+++ linux-2.6.27-rc8/drivers/hwmon/it87.c       2008-10-06
13:27:08.000000000 -0400
@@ -14,6 +14,7 @@
              IT8712F  Super I/O chip w/LPC interface
              IT8716F  Super I/O chip w/LPC interface
              IT8718F  Super I/O chip w/LPC interface
+             IT8720F  Super I/O chip w/LPC interface
              IT8726F  Super I/O chip w/LPC interface
              Sis950   A clone of the IT8705F

@@ -50,7 +51,7 @@

 #define DRVNAME "it87"

-enum chips { it87, it8712, it8716, it8718 };
+enum chips { it87, it8712, it8716, it8718, it8720 };

 static unsigned short force_id;
 module_param(force_id, ushort, 0);
@@ -112,6 +113,7 @@ superio_exit(void)
 #define IT8716F_DEVID 0x8716
 #define IT8718F_DEVID 0x8718
 #define IT8726F_DEVID 0x8726
+#define IT8720F_DEVID 0x8720
 #define IT87_ACT_REG  0x30
 #define IT87_BASE_REG 0x60

@@ -278,7 +280,8 @@ static inline int has_16bit_fans(const s
       return (data->type == it87 && data->revision >= 0x03)
           || (data->type == it8712 && data->revision >= 0x08)
           || data->type == it8716
-           || data->type == it8718;
+           || data->type == it8718
+           || data->type == it8720;
 }

 static int it87_probe(struct platform_device *pdev);
@@ -982,6 +985,9 @@ static int __init it87_find(unsigned sho
       case IT8718F_DEVID:
               sio_data->type = it8718;
               break;
+       case IT8720F_DEVID:
+               sio_data->type = it8720;
+               break;
       case 0xffff:    /* No device at all */
               goto exit;
       default:
@@ -1040,6 +1046,7 @@ static int __devinit it87_probe(struct p
               "it8712",
               "it8716",
               "it8718",
+               "it8720",
       };

       res = platform_get_resource(pdev, IORESOURCE_IO, 0);
@@ -1190,7 +1197,7 @@ static int __devinit it87_probe(struct p
       }

       if (data->type == it8712 || data->type == it8716
-        || data->type == it8718) {
+        || data->type == it8718 || data->type == it8720) {
               data->vrm = vid_which_vrm();
               /* VID reading from Super-I/O config space if available */
               data->vid = sio_data->vid_value;
@@ -1571,7 +1578,7 @@ static void __exit sm_it87_exit(void)

 MODULE_AUTHOR("Chris Gauthron, "
             "Jean Delvare <khali@linux-fr.org>");
-MODULE_DESCRIPTION("IT8705F/8712F/8716F/8718F/8726F, SiS950 driver");
+MODULE_DESCRIPTION("IT8705F/8712F/8716F/8718F/8720F/8726F, SiS950 driver");
 module_param(update_vbat, bool, 0);
 MODULE_PARM_DESC(update_vbat, "Update vbat if set else return powerup value");
 module_param(fix_pwm_polarity, bool, 0);

------=_Part_55141_27961942.1223314436172
Content-Type: application/octet-stream; name=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flzdsgm20
Content-Disposition: attachment; filename=patch

LS0tIGxpbnV4LTIuNi4yNy1yYzgvZHJpdmVycy9od21vbi9pdDg3LmMub3JpZwkyMDA4LTEwLTAy
IDA5OjA0OjQ0LjAwMDAwMDAwMCAtMDQwMAorKysgbGludXgtMi42LjI3LXJjOC9kcml2ZXJzL2h3
bW9uL2l0ODcuYwkyMDA4LTEwLTA2IDEzOjI3OjA4LjAwMDAwMDAwMCAtMDQwMApAQCAtMTQsNiAr
MTQsNyBAQAogICAgICAgICAgICAgICBJVDg3MTJGICBTdXBlciBJL08gY2hpcCB3L0xQQyBpbnRl
cmZhY2UKICAgICAgICAgICAgICAgSVQ4NzE2RiAgU3VwZXIgSS9PIGNoaXAgdy9MUEMgaW50ZXJm
YWNlCiAgICAgICAgICAgICAgIElUODcxOEYgIFN1cGVyIEkvTyBjaGlwIHcvTFBDIGludGVyZmFj
ZQorCSAgICAgIElUODcyMEYgIFN1cGVyIEkvTyBjaGlwIHcvTFBDIGludGVyZmFjZQogICAgICAg
ICAgICAgICBJVDg3MjZGICBTdXBlciBJL08gY2hpcCB3L0xQQyBpbnRlcmZhY2UKICAgICAgICAg
ICAgICAgU2lzOTUwICAgQSBjbG9uZSBvZiB0aGUgSVQ4NzA1RgogCkBAIC01MCw3ICs1MSw3IEBA
CiAKICNkZWZpbmUgRFJWTkFNRSAiaXQ4NyIKIAotZW51bSBjaGlwcyB7IGl0ODcsIGl0ODcxMiwg
aXQ4NzE2LCBpdDg3MTggfTsKK2VudW0gY2hpcHMgeyBpdDg3LCBpdDg3MTIsIGl0ODcxNiwgaXQ4
NzE4LCBpdDg3MjAgfTsKIAogc3RhdGljIHVuc2lnbmVkIHNob3J0IGZvcmNlX2lkOwogbW9kdWxl
X3BhcmFtKGZvcmNlX2lkLCB1c2hvcnQsIDApOwpAQCAtMTEyLDYgKzExMyw3IEBAIHN1cGVyaW9f
ZXhpdCh2b2lkKQogI2RlZmluZSBJVDg3MTZGX0RFVklEIDB4ODcxNgogI2RlZmluZSBJVDg3MThG
X0RFVklEIDB4ODcxOAogI2RlZmluZSBJVDg3MjZGX0RFVklEIDB4ODcyNgorI2RlZmluZSBJVDg3
MjBGX0RFVklEIDB4ODcyMAogI2RlZmluZSBJVDg3X0FDVF9SRUcgIDB4MzAKICNkZWZpbmUgSVQ4
N19CQVNFX1JFRyAweDYwCiAKQEAgLTI3OCw3ICsyODAsOCBAQCBzdGF0aWMgaW5saW5lIGludCBo
YXNfMTZiaXRfZmFucyhjb25zdCBzCiAJcmV0dXJuIChkYXRhLT50eXBlID09IGl0ODcgJiYgZGF0
YS0+cmV2aXNpb24gPj0gMHgwMykKIAkgICAgfHwgKGRhdGEtPnR5cGUgPT0gaXQ4NzEyICYmIGRh
dGEtPnJldmlzaW9uID49IDB4MDgpCiAJICAgIHx8IGRhdGEtPnR5cGUgPT0gaXQ4NzE2Ci0JICAg
IHx8IGRhdGEtPnR5cGUgPT0gaXQ4NzE4OworCSAgICB8fCBkYXRhLT50eXBlID09IGl0ODcxOAor
CSAgICB8fCBkYXRhLT50eXBlID09IGl0ODcyMDsKIH0KIAogc3RhdGljIGludCBpdDg3X3Byb2Jl
KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpOwpAQCAtOTgyLDYgKzk4NSw5IEBAIHN0YXRp
YyBpbnQgX19pbml0IGl0ODdfZmluZCh1bnNpZ25lZCBzaG8KIAljYXNlIElUODcxOEZfREVWSUQ6
CiAJCXNpb19kYXRhLT50eXBlID0gaXQ4NzE4OwogCQlicmVhazsKKwljYXNlIElUODcyMEZfREVW
SUQ6CisJCXNpb19kYXRhLT50eXBlID0gaXQ4NzIwOworCQlicmVhazsKIAljYXNlIDB4ZmZmZjoJ
LyogTm8gZGV2aWNlIGF0IGFsbCAqLwogCQlnb3RvIGV4aXQ7CiAJZGVmYXVsdDoKQEAgLTEwNDAs
NiArMTA0Niw3IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IGl0ODdfcHJvYmUoc3RydWN0IHAKIAkJ
Iml0ODcxMiIsCiAJCSJpdDg3MTYiLAogCQkiaXQ4NzE4IiwKKwkJIml0ODcyMCIsCiAJfTsKIAog
CXJlcyA9IHBsYXRmb3JtX2dldF9yZXNvdXJjZShwZGV2LCBJT1JFU09VUkNFX0lPLCAwKTsKQEAg
LTExOTAsNyArMTE5Nyw3IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IGl0ODdfcHJvYmUoc3RydWN0
IHAKIAl9CiAKIAlpZiAoZGF0YS0+dHlwZSA9PSBpdDg3MTIgfHwgZGF0YS0+dHlwZSA9PSBpdDg3
MTYKLQkgfHwgZGF0YS0+dHlwZSA9PSBpdDg3MTgpIHsKKwkgfHwgZGF0YS0+dHlwZSA9PSBpdDg3
MTggfHwgZGF0YS0+dHlwZSA9PSBpdDg3MjApIHsKIAkJZGF0YS0+dnJtID0gdmlkX3doaWNoX3Zy
bSgpOwogCQkvKiBWSUQgcmVhZGluZyBmcm9tIFN1cGVyLUkvTyBjb25maWcgc3BhY2UgaWYgYXZh
aWxhYmxlICovCiAJCWRhdGEtPnZpZCA9IHNpb19kYXRhLT52aWRfdmFsdWU7CkBAIC0xNTcxLDcg
KzE1NzgsNyBAQCBzdGF0aWMgdm9pZCBfX2V4aXQgc21faXQ4N19leGl0KHZvaWQpCiAKIE1PRFVM
RV9BVVRIT1IoIkNocmlzIEdhdXRocm9uLCAiCiAJICAgICAgIkplYW4gRGVsdmFyZSA8a2hhbGlA
bGludXgtZnIub3JnPiIpOwotTU9EVUxFX0RFU0NSSVBUSU9OKCJJVDg3MDVGLzg3MTJGLzg3MTZG
Lzg3MThGLzg3MjZGLCBTaVM5NTAgZHJpdmVyIik7CitNT0RVTEVfREVTQ1JJUFRJT04oIklUODcw
NUYvODcxMkYvODcxNkYvODcxOEYvODcyMEYvODcyNkYsIFNpUzk1MCBkcml2ZXIiKTsKIG1vZHVs
ZV9wYXJhbSh1cGRhdGVfdmJhdCwgYm9vbCwgMCk7CiBNT0RVTEVfUEFSTV9ERVNDKHVwZGF0ZV92
YmF0LCAiVXBkYXRlIHZiYXQgaWYgc2V0IGVsc2UgcmV0dXJuIHBvd2VydXAgdmFsdWUiKTsKIG1v
ZHVsZV9wYXJhbShmaXhfcHdtX3BvbGFyaXR5LCBib29sLCAwKTsK
------=_Part_55141_27961942.1223314436172--
