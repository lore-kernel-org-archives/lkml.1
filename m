Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbXJ1Noh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbXJ1Noh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 09:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXJ1No3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 09:44:29 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:32489 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbXJ1No2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 09:44:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=qmtjldfpgeSAQ/kUYAeztqnrm5VJvy7lSCbBOBTVwyWFChQ2yxFqxslZ9RWaBxdbycRVMfqn3lDE66LpGjYaZMeLG5GrbK3FEZ52w0riOBKvBv8wBNpSd7fjURMCwZNRzR8MmkVL6uWIovfa2Qgj90qsqGC0pWAwfW5a+GPDWLs=
Message-ID: <6101e8c40710280644x54871d83m1e7df533d773ce73@mail.gmail.com>
Date: Sun, 28 Oct 2007 14:44:25 +0100
From: "=?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?=" <oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] coding style cleanups for drivers/md/mktables.c
Cc: akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_6770_22392595.1193579065725"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_6770_22392595.1193579065725
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ingo!

it is a needed cleanups for mktables

---

commit 00c8a2f969f9fdc3f02dd52b867bb2a64d5870d9
Author: oliver <oliver@pancs.(none)>
Date:   Sun Oct 28 14:48:34 2007 +0100

    fix coding style in drivers/md/mktables.c

    Signed-off-by: Oliv=E9r Pint=E9r <oliver.pntr@gmail.com>

diff --git a/drivers/md/mktables.c b/drivers/md/mktables.c
index adef299..339afd0 100644
--- a/drivers/md/mktables.c
+++ b/drivers/md/mktables.c
@@ -26,100 +26,104 @@

 static uint8_t gfmul(uint8_t a, uint8_t b)
 {
-  uint8_t v =3D 0;
-
-  while ( b ) {
-    if ( b & 1 ) v ^=3D a;
-    a =3D (a << 1) ^ (a & 0x80 ? 0x1d : 0);
-    b >>=3D 1;
-  }
-  return v;
+=09uint8_t v =3D 0;
+
+=09while (b) {
+=09=09if (b & 1)
+=09=09=09v ^=3D a;
+=09=09a =3D (a << 1) ^ (a & 0x80 ? 0x1d : 0);
+=09=09b >>=3D 1;
+=09}
+
+=09return v;
 }

 static uint8_t gfpow(uint8_t a, int b)
 {
-  uint8_t v =3D 1;
-
-  b %=3D 255;
-  if ( b < 0 )
-    b +=3D 255;
-
-  while ( b ) {
-    if ( b & 1 ) v =3D gfmul(v,a);
-    a =3D gfmul(a,a);
-    b >>=3D 1;
-  }
-  return v;
+=09uint8_t v =3D 1;
+
+=09b %=3D 255;
+=09if (b < 0)
+=09=09b +=3D 255;
+
+=09while (b) {
+=09=09if (b & 1)
+=09=09=09v =3D gfmul(v, a);
+=09=09a =3D gfmul(a, a);
+=09=09b >>=3D 1;
+=09}
+
+=09return v;
 }

 int main(int argc, char *argv[])
 {
-  int i, j, k;
-  uint8_t v;
-  uint8_t exptbl[256], invtbl[256];
-
-  printf("#include \"raid6.h\"\n");
-
-  /* Compute multiplication table */
-  printf("\nconst u8  __attribute__((aligned(256)))\n"
-=09 "raid6_gfmul[256][256] =3D\n"
-=09 "{\n");
-  for ( i =3D 0 ; i < 256 ; i++ ) {
-    printf("\t{\n");
-    for ( j =3D 0 ; j < 256 ; j +=3D 8 ) {
-      printf("\t\t");
-      for ( k =3D 0 ; k < 8 ; k++ ) {
-=09printf("0x%02x, ", gfmul(i,j+k));
-      }
-      printf("\n");
-    }
-    printf("\t},\n");
-  }
-  printf("};\n");
-
-  /* Compute power-of-2 table (exponent) */
-  v =3D 1;
-  printf("\nconst u8 __attribute__((aligned(256)))\n"
-=09 "raid6_gfexp[256] =3D\n"
-=09 "{\n");
-  for ( i =3D 0 ; i < 256 ; i +=3D 8 ) {
-    printf("\t");
-    for ( j =3D 0 ; j < 8 ; j++ ) {
-      exptbl[i+j] =3D v;
-      printf("0x%02x, ", v);
-      v =3D gfmul(v,2);
-      if ( v =3D=3D 1 ) v =3D 0;=09/* For entry 255, not a real entry */
-    }
-    printf("\n");
-  }
-  printf("};\n");
-
-  /* Compute inverse table x^-1 =3D=3D x^254 */
-  printf("\nconst u8 __attribute__((aligned(256)))\n"
-=09 "raid6_gfinv[256] =3D\n"
-=09 "{\n");
-  for ( i =3D 0 ; i < 256 ; i +=3D 8 ) {
-    printf("\t");
-    for ( j =3D 0 ; j < 8 ; j++ ) {
-      invtbl[i+j] =3D v =3D gfpow(i+j,254);
-      printf("0x%02x, ", v);
-    }
-    printf("\n");
-  }
-  printf("};\n");
-
-  /* Compute inv(2^x + 1) (exponent-xor-inverse) table */
-  printf("\nconst u8 __attribute__((aligned(256)))\n"
-=09 "raid6_gfexi[256] =3D\n"
-=09 "{\n");
-  for ( i =3D 0 ; i < 256 ; i +=3D 8 ) {
-    printf("\t");
-    for ( j =3D 0 ; j < 8 ; j++ ) {
-      printf("0x%02x, ", invtbl[exptbl[i+j]^1]);
-    }
-    printf("\n");
-  }
-  printf("};\n\n");
-
-  return 0;
+=09int i, j, k;
+=09uint8_t v;
+=09uint8_t exptbl[256], invtbl[256];
+
+=09printf("#include \"raid6.h\"\n");
+
+=09/* Compute multiplication table */
+=09printf("\nconst u8  __attribute__((aligned(256)))\n"
+=09=09"raid6_gfmul[256][256] =3D\n"
+=09=09"{\n");
+=09for (i =3D 0; i < 256; i++) {
+=09=09printf("\t{\n");
+=09=09for (j =3D 0; j < 256; j +=3D 8) {
+=09=09=09printf("\t\t");
+=09=09=09for (k =3D 0; k < 8; k++)
+=09=09=09=09printf("0x%02x, ", gfmul(i, j+k));
+=09=09=09printf("\n");
+=09=09}
+=09=09printf("\t},\n");
+=09}
+=09printf("};\n");
+
+=09/* Compute power-of-2 table (exponent) */
+=09v =3D 1;
+=09printf("\nconst u8 __attribute__((aligned(256)))\n"
+=09=09"raid6_gfexp[256] =3D\n"
+=09=09"{\n");
+=09for (i =3D 0; i < 256; i +=3D 8) {
+=09=09printf("\t");
+=09=09for (j =3D 0; j < 8; j++) {
+=09=09=09exptbl[i+j] =3D v;
+=09=09=09printf("0x%02x, ", v);
+=09=09=09v =3D gfmul(v, 2);
+=09=09=09if (v =3D=3D 1)
+=09=09=09=09v =3D 0;=09/* For entry 255, not a real entry */
+=09=09}
+=09=09printf("\n");
+=09}
+=09printf("};\n");
+
+=09/* Compute inverse table x^-1 =3D=3D x^254 */
+=09printf("\nconst u8 __attribute__((aligned(256)))\n"
+=09=09"raid6_gfinv[256] =3D\n"
+=09=09"{\n");
+=09for (i =3D 0; i < 256; i +=3D 8) {
+=09=09printf("\t");
+=09=09for (j =3D 0; j < 8; j++) {
+=09=09=09v =3D gfpow(i+j, 254);
+=09=09=09invtbl[i+j] =3D v;
+=09=09=09printf("0x%02x, ", v);
+=09=09}
+=09=09printf("\n");
+=09}
+=09printf("};\n");
+
+=09/* Compute inv(2^x + 1) (exponent-xor-inverse) table */
+=09printf("\nconst u8 __attribute__((aligned(256)))\n"
+=09=09"raid6_gfexi[256] =3D\n"
+=09=09"{\n");
+=09for (i =3D 0; i < 256; i +=3D 8) {
+=09=09printf("\t");
+=09=09for (j =3D 0; j < 8; j++)
+=09=09=09printf("0x%02x, ", invtbl[exptbl[i+j]^1]);
+=09=09printf("\n");
+=09}
+=09printf("};\n\n");
+
+=09return 0;
 }

---

(Applied fine to 2.6.23 and 2.6.24-rc1-git4)

--=20
Thanks,
Oliver

------=_Part_6770_22392595.1193579065725
Content-Type: text/x-diff; name=coding-style-cleanups-for-mktables.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment;
 filename=coding-style-cleanups-for-mktables.patch

Y29tbWl0IDAwYzhhMmY5NjlmOWZkYzNmMDJkZDUyYjg2N2JiMmE2NGQ1ODcwZDkKQXV0aG9yOiBv
bGl2ZXIgPG9saXZlckBwYW5jcy4obm9uZSk+CkRhdGU6ICAgU3VuIE9jdCAyOCAxNDo0ODozNCAy
MDA3ICswMTAwCgogICAgZml4IGNvZGluZyBzdHlsZSBpbiBkcml2ZXJzL21kL21rdGFibGVzLmMK
ICAgIAogICAgU2lnbmVkLW9mZi1ieTogT2xpdulyIFBpbnTpciA8b2xpdmVyLnBudHJAZ21haWwu
Y29tPgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvbWt0YWJsZXMuYyBiL2RyaXZlcnMvbWQvbWt0
YWJsZXMuYwppbmRleCBhZGVmMjk5Li4zMzlhZmQwIDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL21r
dGFibGVzLmMKKysrIGIvZHJpdmVycy9tZC9ta3RhYmxlcy5jCkBAIC0yNiwxMDAgKzI2LDEwNCBA
QAogCiBzdGF0aWMgdWludDhfdCBnZm11bCh1aW50OF90IGEsIHVpbnQ4X3QgYikKIHsKLSAgdWlu
dDhfdCB2ID0gMDsKLQotICB3aGlsZSAoIGIgKSB7Ci0gICAgaWYgKCBiICYgMSApIHYgXj0gYTsK
LSAgICBhID0gKGEgPDwgMSkgXiAoYSAmIDB4ODAgPyAweDFkIDogMCk7Ci0gICAgYiA+Pj0gMTsK
LSAgfQotICByZXR1cm4gdjsKKwl1aW50OF90IHYgPSAwOworCisJd2hpbGUgKGIpIHsKKwkJaWYg
KGIgJiAxKQorCQkJdiBePSBhOworCQlhID0gKGEgPDwgMSkgXiAoYSAmIDB4ODAgPyAweDFkIDog
MCk7CisJCWIgPj49IDE7CisJfQorCisJcmV0dXJuIHY7CiB9CiAKIHN0YXRpYyB1aW50OF90IGdm
cG93KHVpbnQ4X3QgYSwgaW50IGIpCiB7Ci0gIHVpbnQ4X3QgdiA9IDE7Ci0KLSAgYiAlPSAyNTU7
Ci0gIGlmICggYiA8IDAgKQotICAgIGIgKz0gMjU1OwotCi0gIHdoaWxlICggYiApIHsKLSAgICBp
ZiAoIGIgJiAxICkgdiA9IGdmbXVsKHYsYSk7Ci0gICAgYSA9IGdmbXVsKGEsYSk7Ci0gICAgYiA+
Pj0gMTsKLSAgfQotICByZXR1cm4gdjsKKwl1aW50OF90IHYgPSAxOworCisJYiAlPSAyNTU7CisJ
aWYgKGIgPCAwKQorCQliICs9IDI1NTsKKworCXdoaWxlIChiKSB7CisJCWlmIChiICYgMSkKKwkJ
CXYgPSBnZm11bCh2LCBhKTsKKwkJYSA9IGdmbXVsKGEsIGEpOworCQliID4+PSAxOworCX0KKwor
CXJldHVybiB2OwogfQogCiBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqYXJndltdKQogewotICBp
bnQgaSwgaiwgazsKLSAgdWludDhfdCB2OwotICB1aW50OF90IGV4cHRibFsyNTZdLCBpbnZ0Ymxb
MjU2XTsKLQotICBwcmludGYoIiNpbmNsdWRlIFwicmFpZDYuaFwiXG4iKTsKLQotICAvKiBDb21w
dXRlIG11bHRpcGxpY2F0aW9uIHRhYmxlICovCi0gIHByaW50ZigiXG5jb25zdCB1OCAgX19hdHRy
aWJ1dGVfXygoYWxpZ25lZCgyNTYpKSlcbiIKLQkgInJhaWQ2X2dmbXVsWzI1Nl1bMjU2XSA9XG4i
Ci0JICJ7XG4iKTsKLSAgZm9yICggaSA9IDAgOyBpIDwgMjU2IDsgaSsrICkgewotICAgIHByaW50
ZigiXHR7XG4iKTsKLSAgICBmb3IgKCBqID0gMCA7IGogPCAyNTYgOyBqICs9IDggKSB7Ci0gICAg
ICBwcmludGYoIlx0XHQiKTsKLSAgICAgIGZvciAoIGsgPSAwIDsgayA8IDggOyBrKysgKSB7Ci0J
cHJpbnRmKCIweCUwMngsICIsIGdmbXVsKGksaitrKSk7Ci0gICAgICB9Ci0gICAgICBwcmludGYo
IlxuIik7Ci0gICAgfQotICAgIHByaW50ZigiXHR9LFxuIik7Ci0gIH0KLSAgcHJpbnRmKCJ9O1xu
Iik7Ci0KLSAgLyogQ29tcHV0ZSBwb3dlci1vZi0yIHRhYmxlIChleHBvbmVudCkgKi8KLSAgdiA9
IDE7Ci0gIHByaW50ZigiXG5jb25zdCB1OCBfX2F0dHJpYnV0ZV9fKChhbGlnbmVkKDI1NikpKVxu
IgotCSAicmFpZDZfZ2ZleHBbMjU2XSA9XG4iCi0JICJ7XG4iKTsKLSAgZm9yICggaSA9IDAgOyBp
IDwgMjU2IDsgaSArPSA4ICkgewotICAgIHByaW50ZigiXHQiKTsKLSAgICBmb3IgKCBqID0gMCA7
IGogPCA4IDsgaisrICkgewotICAgICAgZXhwdGJsW2kral0gPSB2OwotICAgICAgcHJpbnRmKCIw
eCUwMngsICIsIHYpOwotICAgICAgdiA9IGdmbXVsKHYsMik7Ci0gICAgICBpZiAoIHYgPT0gMSAp
IHYgPSAwOwkvKiBGb3IgZW50cnkgMjU1LCBub3QgYSByZWFsIGVudHJ5ICovCi0gICAgfQotICAg
IHByaW50ZigiXG4iKTsKLSAgfQotICBwcmludGYoIn07XG4iKTsKLQotICAvKiBDb21wdXRlIGlu
dmVyc2UgdGFibGUgeF4tMSA9PSB4XjI1NCAqLwotICBwcmludGYoIlxuY29uc3QgdTggX19hdHRy
aWJ1dGVfXygoYWxpZ25lZCgyNTYpKSlcbiIKLQkgInJhaWQ2X2dmaW52WzI1Nl0gPVxuIgotCSAi
e1xuIik7Ci0gIGZvciAoIGkgPSAwIDsgaSA8IDI1NiA7IGkgKz0gOCApIHsKLSAgICBwcmludGYo
Ilx0Iik7Ci0gICAgZm9yICggaiA9IDAgOyBqIDwgOCA7IGorKyApIHsKLSAgICAgIGludnRibFtp
K2pdID0gdiA9IGdmcG93KGkraiwyNTQpOwotICAgICAgcHJpbnRmKCIweCUwMngsICIsIHYpOwot
ICAgIH0KLSAgICBwcmludGYoIlxuIik7Ci0gIH0KLSAgcHJpbnRmKCJ9O1xuIik7Ci0KLSAgLyog
Q29tcHV0ZSBpbnYoMl54ICsgMSkgKGV4cG9uZW50LXhvci1pbnZlcnNlKSB0YWJsZSAqLwotICBw
cmludGYoIlxuY29uc3QgdTggX19hdHRyaWJ1dGVfXygoYWxpZ25lZCgyNTYpKSlcbiIKLQkgInJh
aWQ2X2dmZXhpWzI1Nl0gPVxuIgotCSAie1xuIik7Ci0gIGZvciAoIGkgPSAwIDsgaSA8IDI1NiA7
IGkgKz0gOCApIHsKLSAgICBwcmludGYoIlx0Iik7Ci0gICAgZm9yICggaiA9IDAgOyBqIDwgOCA7
IGorKyApIHsKLSAgICAgIHByaW50ZigiMHglMDJ4LCAiLCBpbnZ0YmxbZXhwdGJsW2kral1eMV0p
OwotICAgIH0KLSAgICBwcmludGYoIlxuIik7Ci0gIH0KLSAgcHJpbnRmKCJ9O1xuXG4iKTsKLQot
ICByZXR1cm4gMDsKKwlpbnQgaSwgaiwgazsKKwl1aW50OF90IHY7CisJdWludDhfdCBleHB0Ymxb
MjU2XSwgaW52dGJsWzI1Nl07CisKKwlwcmludGYoIiNpbmNsdWRlIFwicmFpZDYuaFwiXG4iKTsK
KworCS8qIENvbXB1dGUgbXVsdGlwbGljYXRpb24gdGFibGUgKi8KKwlwcmludGYoIlxuY29uc3Qg
dTggIF9fYXR0cmlidXRlX18oKGFsaWduZWQoMjU2KSkpXG4iCisJCSJyYWlkNl9nZm11bFsyNTZd
WzI1Nl0gPVxuIgorCQkie1xuIik7CisJZm9yIChpID0gMDsgaSA8IDI1NjsgaSsrKSB7CisJCXBy
aW50ZigiXHR7XG4iKTsKKwkJZm9yIChqID0gMDsgaiA8IDI1NjsgaiArPSA4KSB7CisJCQlwcmlu
dGYoIlx0XHQiKTsKKwkJCWZvciAoayA9IDA7IGsgPCA4OyBrKyspCisJCQkJcHJpbnRmKCIweCUw
MngsICIsIGdmbXVsKGksIGoraykpOworCQkJcHJpbnRmKCJcbiIpOworCQl9CisJCXByaW50Zigi
XHR9LFxuIik7CisJfQorCXByaW50ZigifTtcbiIpOworCisJLyogQ29tcHV0ZSBwb3dlci1vZi0y
IHRhYmxlIChleHBvbmVudCkgKi8KKwl2ID0gMTsKKwlwcmludGYoIlxuY29uc3QgdTggX19hdHRy
aWJ1dGVfXygoYWxpZ25lZCgyNTYpKSlcbiIKKwkJInJhaWQ2X2dmZXhwWzI1Nl0gPVxuIgorCQki
e1xuIik7CisJZm9yIChpID0gMDsgaSA8IDI1NjsgaSArPSA4KSB7CisJCXByaW50ZigiXHQiKTsK
KwkJZm9yIChqID0gMDsgaiA8IDg7IGorKykgeworCQkJZXhwdGJsW2kral0gPSB2OworCQkJcHJp
bnRmKCIweCUwMngsICIsIHYpOworCQkJdiA9IGdmbXVsKHYsIDIpOworCQkJaWYgKHYgPT0gMSkK
KwkJCQl2ID0gMDsJLyogRm9yIGVudHJ5IDI1NSwgbm90IGEgcmVhbCBlbnRyeSAqLworCQl9CisJ
CXByaW50ZigiXG4iKTsKKwl9CisJcHJpbnRmKCJ9O1xuIik7CisKKwkvKiBDb21wdXRlIGludmVy
c2UgdGFibGUgeF4tMSA9PSB4XjI1NCAqLworCXByaW50ZigiXG5jb25zdCB1OCBfX2F0dHJpYnV0
ZV9fKChhbGlnbmVkKDI1NikpKVxuIgorCQkicmFpZDZfZ2ZpbnZbMjU2XSA9XG4iCisJCSJ7XG4i
KTsKKwlmb3IgKGkgPSAwOyBpIDwgMjU2OyBpICs9IDgpIHsKKwkJcHJpbnRmKCJcdCIpOworCQlm
b3IgKGogPSAwOyBqIDwgODsgaisrKSB7CisJCQl2ID0gZ2Zwb3coaStqLCAyNTQpOworCQkJaW52
dGJsW2kral0gPSB2OworCQkJcHJpbnRmKCIweCUwMngsICIsIHYpOworCQl9CisJCXByaW50Zigi
XG4iKTsKKwl9CisJcHJpbnRmKCJ9O1xuIik7CisKKwkvKiBDb21wdXRlIGludigyXnggKyAxKSAo
ZXhwb25lbnQteG9yLWludmVyc2UpIHRhYmxlICovCisJcHJpbnRmKCJcbmNvbnN0IHU4IF9fYXR0
cmlidXRlX18oKGFsaWduZWQoMjU2KSkpXG4iCisJCSJyYWlkNl9nZmV4aVsyNTZdID1cbiIKKwkJ
IntcbiIpOworCWZvciAoaSA9IDA7IGkgPCAyNTY7IGkgKz0gOCkgeworCQlwcmludGYoIlx0Iik7
CisJCWZvciAoaiA9IDA7IGogPCA4OyBqKyspCisJCQlwcmludGYoIjB4JTAyeCwgIiwgaW52dGJs
W2V4cHRibFtpK2pdXjFdKTsKKwkJcHJpbnRmKCJcbiIpOworCX0KKwlwcmludGYoIn07XG5cbiIp
OworCisJcmV0dXJuIDA7CiB9Cg==
------=_Part_6770_22392595.1193579065725--
