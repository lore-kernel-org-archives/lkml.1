Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbXJZR5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbXJZR5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbXJZR5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:57:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:38404 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbXJZR5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:57:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Gi+JGu/U1pYadBcnmuvNuTb1nj0u0p4MvLMymZGH1wVPMnFQTvr/R1V5YywXmX/PFo+ww7CQW3+wUzaMLd00USUSEgldFh053g5fQDjCEr81Wjz88o6T1ko0Qq+OOUrfr1mBcAUsHa3LVpkJ5dUV6E0X21z8TRbgBXatGG20hqE=
Message-ID: <6101e8c40710261057t1f5b30fcm1e603bc23401f3d9@mail.gmail.com>
Date: Fri, 26 Oct 2007 19:57:34 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] coding style fix of drivers/md/mktables.c (based on 2.6.23)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 400796b6b5ef9d6b1a882e5b8b0a4015140b7ac7
Author: oliver <oliver@pancs.(none)>
Commit: oliver <oliver@pancs.(none)>

    coding style clean up of drivers/md/mktables.c

    Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/md/mktables.c b/drivers/md/mktables.c
index adef299..339afd0 100644
--- a/drivers/md/mktables.c
+++ b/drivers/md/mktables.c
@@ -26,100 +26,104 @@

 static uint8_t gfmul(uint8_t a, uint8_t b)
 {
-  uint8_t v = 0;
-
-  while ( b ) {
-    if ( b & 1 ) v ^= a;
-    a = (a << 1) ^ (a & 0x80 ? 0x1d : 0);
-    b >>= 1;
-  }
-  return v;
+	uint8_t v = 0;
+
+	while (b) {
+		if (b & 1)
+			v ^= a;
+		a = (a << 1) ^ (a & 0x80 ? 0x1d : 0);
+		b >>= 1;
+	}
+
+	return v;
 }

 static uint8_t gfpow(uint8_t a, int b)
 {
-  uint8_t v = 1;
-
-  b %= 255;
-  if ( b < 0 )
-    b += 255;
-
-  while ( b ) {
-    if ( b & 1 ) v = gfmul(v,a);
-    a = gfmul(a,a);
-    b >>= 1;
-  }
-  return v;
+	uint8_t v = 1;
+
+	b %= 255;
+	if (b < 0)
+		b += 255;
+
+	while (b) {
+		if (b & 1)
+			v = gfmul(v, a);
+		a = gfmul(a, a);
+		b >>= 1;
+	}
+
+	return v;
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
-	 "raid6_gfmul[256][256] =\n"
-	 "{\n");
-  for ( i = 0 ; i < 256 ; i++ ) {
-    printf("\t{\n");
-    for ( j = 0 ; j < 256 ; j += 8 ) {
-      printf("\t\t");
-      for ( k = 0 ; k < 8 ; k++ ) {
-	printf("0x%02x, ", gfmul(i,j+k));
-      }
-      printf("\n");
-    }
-    printf("\t},\n");
-  }
-  printf("};\n");
-
-  /* Compute power-of-2 table (exponent) */
-  v = 1;
-  printf("\nconst u8 __attribute__((aligned(256)))\n"
-	 "raid6_gfexp[256] =\n"
-	 "{\n");
-  for ( i = 0 ; i < 256 ; i += 8 ) {
-    printf("\t");
-    for ( j = 0 ; j < 8 ; j++ ) {
-      exptbl[i+j] = v;
-      printf("0x%02x, ", v);
-      v = gfmul(v,2);
-      if ( v == 1 ) v = 0;	/* For entry 255, not a real entry */
-    }
-    printf("\n");
-  }
-  printf("};\n");
-
-  /* Compute inverse table x^-1 == x^254 */
-  printf("\nconst u8 __attribute__((aligned(256)))\n"
-	 "raid6_gfinv[256] =\n"
-	 "{\n");
-  for ( i = 0 ; i < 256 ; i += 8 ) {
-    printf("\t");
-    for ( j = 0 ; j < 8 ; j++ ) {
-      invtbl[i+j] = v = gfpow(i+j,254);
-      printf("0x%02x, ", v);
-    }
-    printf("\n");
-  }
-  printf("};\n");
-
-  /* Compute inv(2^x + 1) (exponent-xor-inverse) table */
-  printf("\nconst u8 __attribute__((aligned(256)))\n"
-	 "raid6_gfexi[256] =\n"
-	 "{\n");
-  for ( i = 0 ; i < 256 ; i += 8 ) {
-    printf("\t");
-    for ( j = 0 ; j < 8 ; j++ ) {
-      printf("0x%02x, ", invtbl[exptbl[i+j]^1]);
-    }
-    printf("\n");
-  }
-  printf("};\n\n");
-
-  return 0;
+	int i, j, k;
+	uint8_t v;
+	uint8_t exptbl[256], invtbl[256];
+
+	printf("#include \"raid6.h\"\n");
+
+	/* Compute multiplication table */
+	printf("\nconst u8  __attribute__((aligned(256)))\n"
+		"raid6_gfmul[256][256] =\n"
+		"{\n");
+	for (i = 0; i < 256; i++) {
+		printf("\t{\n");
+		for (j = 0; j < 256; j += 8) {
+			printf("\t\t");
+			for (k = 0; k < 8; k++)
+				printf("0x%02x, ", gfmul(i, j+k));
+			printf("\n");
+		}
+		printf("\t},\n");
+	}
+	printf("};\n");
+
+	/* Compute power-of-2 table (exponent) */
+	v = 1;
+	printf("\nconst u8 __attribute__((aligned(256)))\n"
+		"raid6_gfexp[256] =\n"
+		"{\n");
+	for (i = 0; i < 256; i += 8) {
+		printf("\t");
+		for (j = 0; j < 8; j++) {
+			exptbl[i+j] = v;
+			printf("0x%02x, ", v);
+			v = gfmul(v, 2);
+			if (v == 1)
+				v = 0;	/* For entry 255, not a real entry */
+		}
+		printf("\n");
+	}
+	printf("};\n");
+
+	/* Compute inverse table x^-1 == x^254 */
+	printf("\nconst u8 __attribute__((aligned(256)))\n"
+		"raid6_gfinv[256] =\n"
+		"{\n");
+	for (i = 0; i < 256; i += 8) {
+		printf("\t");
+		for (j = 0; j < 8; j++) {
+			v = gfpow(i+j, 254);
+			invtbl[i+j] = v;
+			printf("0x%02x, ", v);
+		}
+		printf("\n");
+	}
+	printf("};\n");
+
+	/* Compute inv(2^x + 1) (exponent-xor-inverse) table */
+	printf("\nconst u8 __attribute__((aligned(256)))\n"
+		"raid6_gfexi[256] =\n"
+		"{\n");
+	for (i = 0; i < 256; i += 8) {
+		printf("\t");
+		for (j = 0; j < 8; j++)
+			printf("0x%02x, ", invtbl[exptbl[i+j]^1]);
+		printf("\n");
+	}
+	printf("};\n\n");
+
+	return 0;
 }


-- 
Thanks,
Oliver
