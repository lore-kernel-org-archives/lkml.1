Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbYKZVOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbYKZVOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYKZVNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:13:00 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:18154 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYKZVM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:12:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RKwm+ZA+Z3xBBgwv4mMfonjK9ddlg6Bprc/5TGBxlh/ypuJwss3OzlDb7kpwvcK29W
         ifgACTXTEtm3DRdhpx9XYElhYsBMRtC65AkPTmrEDeQJPQjh7AI7PHcxgrc4+26qRwEd
         XFO6LTCRXUC2msbrSzu4OmYvt6tlF7Tqt5ByM=
Subject: [PATCH-mm 4/8] crypto: remove uses of __constant_{endian} helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 13:12:51 -0800
Message-Id: <1227733971.5511.126.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Base versions handle constant folding just fine.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Depends on the byteorder consolidation in -mm.

 crypto/fcrypt.c          |    8 ++--
 drivers/crypto/talitos.h |   82 +++++++++++++++++++++++-----------------------
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index 1302f4c..b82d61f 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -73,7 +73,7 @@ do {								\
  * /afs/transarc.com/public/afsps/afs.rel31b.export-src/rxkad/sboxes.h
  */
 #undef Z
-#define Z(x) __constant_cpu_to_be32(x << 3)
+#define Z(x) cpu_to_be32(x << 3)
 static const __be32 sbox0[256] = {
 	Z(0xea), Z(0x7f), Z(0xb2), Z(0x64), Z(0x9d), Z(0xb0), Z(0xd9), Z(0x11),
 	Z(0xcd), Z(0x86), Z(0x86), Z(0x91), Z(0x0a), Z(0xb2), Z(0x93), Z(0x06),
@@ -110,7 +110,7 @@ static const __be32 sbox0[256] = {
 };
 
 #undef Z
-#define Z(x) __constant_cpu_to_be32((x << 27) | (x >> 5))
+#define Z(x) cpu_to_be32((x << 27) | (x >> 5))
 static const __be32 sbox1[256] = {
 	Z(0x77), Z(0x14), Z(0xa6), Z(0xfe), Z(0xb2), Z(0x5e), Z(0x8c), Z(0x3e),
 	Z(0x67), Z(0x6c), Z(0xa1), Z(0x0d), Z(0xc2), Z(0xa2), Z(0xc1), Z(0x85),
@@ -147,7 +147,7 @@ static const __be32 sbox1[256] = {
 };
 
 #undef Z
-#define Z(x) __constant_cpu_to_be32(x << 11)
+#define Z(x) cpu_to_be32(x << 11)
 static const __be32 sbox2[256] = {
 	Z(0xf0), Z(0x37), Z(0x24), Z(0x53), Z(0x2a), Z(0x03), Z(0x83), Z(0x86),
 	Z(0xd1), Z(0xec), Z(0x50), Z(0xf0), Z(0x42), Z(0x78), Z(0x2f), Z(0x6d),
@@ -184,7 +184,7 @@ static const __be32 sbox2[256] = {
 };
 
 #undef Z
-#define Z(x) __constant_cpu_to_be32(x << 19)
+#define Z(x) cpu_to_be32(x << 19)
 static const __be32 sbox3[256] = {
 	Z(0xa9), Z(0x2a), Z(0x48), Z(0x51), Z(0x84), Z(0x7e), Z(0x49), Z(0xe2),
 	Z(0xb5), Z(0xb7), Z(0x42), Z(0x33), Z(0x7d), Z(0x5d), Z(0xa6), Z(0x12),
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 125560a..575981f 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -134,34 +134,34 @@
  */
 
 /* written back when done */
-#define DESC_HDR_DONE			__constant_cpu_to_be32(0xff000000)
-#define DESC_HDR_LO_ICCR1_MASK		__constant_cpu_to_be32(0x00180000)
-#define DESC_HDR_LO_ICCR1_PASS		__constant_cpu_to_be32(0x00080000)
-#define DESC_HDR_LO_ICCR1_FAIL		__constant_cpu_to_be32(0x00100000)
+#define DESC_HDR_DONE			cpu_to_be32(0xff000000)
+#define DESC_HDR_LO_ICCR1_MASK		cpu_to_be32(0x00180000)
+#define DESC_HDR_LO_ICCR1_PASS		cpu_to_be32(0x00080000)
+#define DESC_HDR_LO_ICCR1_FAIL		cpu_to_be32(0x00100000)
 
 /* primary execution unit select */
-#define	DESC_HDR_SEL0_MASK		__constant_cpu_to_be32(0xf0000000)
-#define	DESC_HDR_SEL0_AFEU		__constant_cpu_to_be32(0x10000000)
-#define	DESC_HDR_SEL0_DEU		__constant_cpu_to_be32(0x20000000)
-#define	DESC_HDR_SEL0_MDEUA		__constant_cpu_to_be32(0x30000000)
-#define	DESC_HDR_SEL0_MDEUB		__constant_cpu_to_be32(0xb0000000)
-#define	DESC_HDR_SEL0_RNG		__constant_cpu_to_be32(0x40000000)
-#define	DESC_HDR_SEL0_PKEU		__constant_cpu_to_be32(0x50000000)
-#define	DESC_HDR_SEL0_AESU		__constant_cpu_to_be32(0x60000000)
-#define	DESC_HDR_SEL0_KEU		__constant_cpu_to_be32(0x70000000)
-#define	DESC_HDR_SEL0_CRCU		__constant_cpu_to_be32(0x80000000)
+#define	DESC_HDR_SEL0_MASK		cpu_to_be32(0xf0000000)
+#define	DESC_HDR_SEL0_AFEU		cpu_to_be32(0x10000000)
+#define	DESC_HDR_SEL0_DEU		cpu_to_be32(0x20000000)
+#define	DESC_HDR_SEL0_MDEUA		cpu_to_be32(0x30000000)
+#define	DESC_HDR_SEL0_MDEUB		cpu_to_be32(0xb0000000)
+#define	DESC_HDR_SEL0_RNG		cpu_to_be32(0x40000000)
+#define	DESC_HDR_SEL0_PKEU		cpu_to_be32(0x50000000)
+#define	DESC_HDR_SEL0_AESU		cpu_to_be32(0x60000000)
+#define	DESC_HDR_SEL0_KEU		cpu_to_be32(0x70000000)
+#define	DESC_HDR_SEL0_CRCU		cpu_to_be32(0x80000000)
 
 /* primary execution unit mode (MODE0) and derivatives */
-#define	DESC_HDR_MODE0_ENCRYPT		__constant_cpu_to_be32(0x00100000)
-#define	DESC_HDR_MODE0_AESU_CBC		__constant_cpu_to_be32(0x00200000)
-#define	DESC_HDR_MODE0_DEU_CBC		__constant_cpu_to_be32(0x00400000)
-#define	DESC_HDR_MODE0_DEU_3DES		__constant_cpu_to_be32(0x00200000)
-#define	DESC_HDR_MODE0_MDEU_INIT	__constant_cpu_to_be32(0x01000000)
-#define	DESC_HDR_MODE0_MDEU_HMAC	__constant_cpu_to_be32(0x00800000)
-#define	DESC_HDR_MODE0_MDEU_PAD		__constant_cpu_to_be32(0x00400000)
-#define	DESC_HDR_MODE0_MDEU_MD5		__constant_cpu_to_be32(0x00200000)
-#define	DESC_HDR_MODE0_MDEU_SHA256	__constant_cpu_to_be32(0x00100000)
-#define	DESC_HDR_MODE0_MDEU_SHA1	__constant_cpu_to_be32(0x00000000)
+#define	DESC_HDR_MODE0_ENCRYPT		cpu_to_be32(0x00100000)
+#define	DESC_HDR_MODE0_AESU_CBC		cpu_to_be32(0x00200000)
+#define	DESC_HDR_MODE0_DEU_CBC		cpu_to_be32(0x00400000)
+#define	DESC_HDR_MODE0_DEU_3DES		cpu_to_be32(0x00200000)
+#define	DESC_HDR_MODE0_MDEU_INIT	cpu_to_be32(0x01000000)
+#define	DESC_HDR_MODE0_MDEU_HMAC	cpu_to_be32(0x00800000)
+#define	DESC_HDR_MODE0_MDEU_PAD		cpu_to_be32(0x00400000)
+#define	DESC_HDR_MODE0_MDEU_MD5		cpu_to_be32(0x00200000)
+#define	DESC_HDR_MODE0_MDEU_SHA256	cpu_to_be32(0x00100000)
+#define	DESC_HDR_MODE0_MDEU_SHA1	cpu_to_be32(0x00000000)
 #define	DESC_HDR_MODE0_MDEU_MD5_HMAC	(DESC_HDR_MODE0_MDEU_MD5 | \
 					 DESC_HDR_MODE0_MDEU_HMAC)
 #define	DESC_HDR_MODE0_MDEU_SHA256_HMAC	(DESC_HDR_MODE0_MDEU_SHA256 | \
@@ -170,19 +170,19 @@
 					 DESC_HDR_MODE0_MDEU_HMAC)
 
 /* secondary execution unit select (SEL1) */
-#define	DESC_HDR_SEL1_MASK		__constant_cpu_to_be32(0x000f0000)
-#define	DESC_HDR_SEL1_MDEUA		__constant_cpu_to_be32(0x00030000)
-#define	DESC_HDR_SEL1_MDEUB		__constant_cpu_to_be32(0x000b0000)
-#define	DESC_HDR_SEL1_CRCU		__constant_cpu_to_be32(0x00080000)
+#define	DESC_HDR_SEL1_MASK		cpu_to_be32(0x000f0000)
+#define	DESC_HDR_SEL1_MDEUA		cpu_to_be32(0x00030000)
+#define	DESC_HDR_SEL1_MDEUB		cpu_to_be32(0x000b0000)
+#define	DESC_HDR_SEL1_CRCU		cpu_to_be32(0x00080000)
 
 /* secondary execution unit mode (MODE1) and derivatives */
-#define	DESC_HDR_MODE1_MDEU_CICV	__constant_cpu_to_be32(0x00004000)
-#define	DESC_HDR_MODE1_MDEU_INIT	__constant_cpu_to_be32(0x00001000)
-#define	DESC_HDR_MODE1_MDEU_HMAC	__constant_cpu_to_be32(0x00000800)
-#define	DESC_HDR_MODE1_MDEU_PAD		__constant_cpu_to_be32(0x00000400)
-#define	DESC_HDR_MODE1_MDEU_MD5		__constant_cpu_to_be32(0x00000200)
-#define	DESC_HDR_MODE1_MDEU_SHA256	__constant_cpu_to_be32(0x00000100)
-#define	DESC_HDR_MODE1_MDEU_SHA1	__constant_cpu_to_be32(0x00000000)
+#define	DESC_HDR_MODE1_MDEU_CICV	cpu_to_be32(0x00004000)
+#define	DESC_HDR_MODE1_MDEU_INIT	cpu_to_be32(0x00001000)
+#define	DESC_HDR_MODE1_MDEU_HMAC	cpu_to_be32(0x00000800)
+#define	DESC_HDR_MODE1_MDEU_PAD		cpu_to_be32(0x00000400)
+#define	DESC_HDR_MODE1_MDEU_MD5		cpu_to_be32(0x00000200)
+#define	DESC_HDR_MODE1_MDEU_SHA256	cpu_to_be32(0x00000100)
+#define	DESC_HDR_MODE1_MDEU_SHA1	cpu_to_be32(0x00000000)
 #define	DESC_HDR_MODE1_MDEU_MD5_HMAC	(DESC_HDR_MODE1_MDEU_MD5 | \
 					 DESC_HDR_MODE1_MDEU_HMAC)
 #define	DESC_HDR_MODE1_MDEU_SHA256_HMAC	(DESC_HDR_MODE1_MDEU_SHA256 | \
@@ -191,16 +191,16 @@
 					 DESC_HDR_MODE1_MDEU_HMAC)
 
 /* direction of overall data flow (DIR) */
-#define	DESC_HDR_DIR_INBOUND		__constant_cpu_to_be32(0x00000002)
+#define	DESC_HDR_DIR_INBOUND		cpu_to_be32(0x00000002)
 
 /* request done notification (DN) */
-#define	DESC_HDR_DONE_NOTIFY		__constant_cpu_to_be32(0x00000001)
+#define	DESC_HDR_DONE_NOTIFY		cpu_to_be32(0x00000001)
 
 /* descriptor types */
-#define DESC_HDR_TYPE_AESU_CTR_NONSNOOP		__constant_cpu_to_be32(0 << 3)
-#define DESC_HDR_TYPE_IPSEC_ESP			__constant_cpu_to_be32(1 << 3)
-#define DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU	__constant_cpu_to_be32(2 << 3)
-#define DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU	__constant_cpu_to_be32(4 << 3)
+#define DESC_HDR_TYPE_AESU_CTR_NONSNOOP		cpu_to_be32(0 << 3)
+#define DESC_HDR_TYPE_IPSEC_ESP			cpu_to_be32(1 << 3)
+#define DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU	cpu_to_be32(2 << 3)
+#define DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU	cpu_to_be32(4 << 3)
 
 /* link table extent field bits */
 #define DESC_PTR_LNKTBL_JUMP			0x80
-- 
1.6.0.4.1044.g77718


