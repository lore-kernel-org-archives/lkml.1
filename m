Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbZKRRG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbZKRRG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757851AbZKRRG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:06:27 -0500
Received: from mga06.intel.com ([134.134.136.21]:56053 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757810AbZKRRG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:06:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,766,1249282800"; 
   d="scan'208";a="570800701"
Date: Wed, 18 Nov 2009 19:42:46 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: [PATCH]crypto: Add ghash algorithm test before provide to users
Message-ID: <20091119004246.GB28448@youquan-linux.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ghash algorithm test before provide it to users

Signed-off-by: Youquan, Song <youquan.song@intel.com>
---

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1f2357b..7620bfc 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1943,6 +1943,15 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "ghash",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = ghash_tv_template,
+				.count = GHASH_TEST_VECTORS
+			}
+		}
+	}, {
 		.alg = "hmac(md5)",
 		.test = alg_test_hash,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 9963b18..fea00cd 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -1003,6 +1003,23 @@ static struct hash_testvec tgr128_tv_template[] = {
 	},
 };
 
+#define GHASH_TEST_VECTORS 1
+
+static struct hash_testvec ghash_tv_template[] =
+{
+	{
+
+		.key	= "\xdf\xa6\xbf\x4d\xed\x81\xdb\x03\xff\xca\xff\x95\xf8\x30\xf0\x61",
+		.ksize	= 16,
+		.plaintext = "\x95\x2b\x2a\x56\xa5\x60\x04a\xc0\xb3\x2b\x66\x56\xa0\x5b\x40\xb6",
+		.psize	= 16,
+		.digest	= "\xda\x53\xeb\x0a\xd2\xc5\x5b\xb6"
+			  "\x4f\xc4\x80\x2c\xc3\xfe\xda\x60",
+	},
+};
+
+/*
+ * HMAC-MD5 test vectors from RFC2202
 /*
  * HMAC-MD5 test vectors from RFC2202
  * (These need to be fixed to not use strlen).
