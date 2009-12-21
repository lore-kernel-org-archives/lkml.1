Return-Path: <linux-kernel-owner+w=401wt.eu-S1756421AbZLUDDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbZLUDDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 22:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZLUDDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 22:03:12 -0500
Received: from mga10.intel.com ([192.55.52.92]:20386 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752563AbZLUDDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 22:03:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,427,1257148800"; 
   d="scan'208";a="524943841"
Date: Mon, 21 Dec 2009 05:38:29 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       chaohong.guo@intel.com, youquan.song@intel.com
Subject: [Resend PATCH]crypto: Fix complain about lack test for internal used algorithm
Message-ID: <20091221103829.GA22144@youquan-linux.bj.intel.com>
References: <20091211034711.GA2773@suse.de> <200912102013.59329.david-b@pacbell.net> <20091211043849.GA18007@suse.de> <1260509771.12346.138.camel@localhost> <20091211132321.GA17228@youquan-linux.bj.intel.com> <20091211060448.GA28704@gondor.apana.org.au> <20091219094043.GA23639@youquan-linux.bj.intel.com> <20091219022917.GA19431@gondor.apana.org.au> <20091219150736.GA5368@youquan-linux.bj.intel.com> <20091219094240.GA21546@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091219094240.GA21546@gondor.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When load aesni-intel and ghash_clmulni-intel driver,kernel will complain no
 test for some internal used algorithm.
The strange information as following:

alg: No test for __aes-aesni (__driver-aes-aesni)
alg: No test for __ecb-aes-aesni (__driver-ecb-aes-aesni)
alg: No test for __cbc-aes-aesni (__driver-cbc-aes-aesni)
alg: No test for __ecb-aes-aesni (cryptd(__driver-ecb-aes-aesni)
alg: No test for __ghash (__ghash-pclmulqdqni)
alg: No test for __ghash (cryptd(__ghash-pclmulqdqni))

This patch add NULL test entries for these algorithm and driver.  

Signed-off-by: Youquan, Song <youquan.song@intel.com>
Signed-off-by: Ying, Huang <ying.huang@intel.com>
---


diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f70ce52..e934eca 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1477,9 +1477,54 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
+static int alg_test_null(const struct alg_test_desc *desc,
+			     const char *driver, u32 type, u32 mask)
+{
+	return 0;
+}
+
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
 	{
+		.alg = "__driver-cbc-aes-aesni",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
+		.alg = "__driver-ecb-aes-aesni",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
+		.alg = "__ghash-pclmulqdqni",
+		.test = alg_test_null,
+		.suite = {
+			.hash = {
+				.vecs = NULL,
+				.count = 0
+			}
+		}
+	}, {
 		.alg = "ansi_cprng",
 		.test = alg_test_cprng,
 		.fips_allowed = 1,
@@ -1623,6 +1668,30 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "cryptd(__driver-ecb-aes-aesni)",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
+		.alg = "cryptd(__ghash-pclmulqdqni)",
+		.test = alg_test_null,
+		.suite = {
+			.hash = {
+				.vecs = NULL,
+				.count = 0
+			}
+		}
+	}, {
 		.alg = "ctr(aes)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
@@ -1669,6 +1738,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "ecb(__aes-aesni)",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
 		.alg = "ecb(aes)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
