Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbYFENH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbYFENH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 09:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYFENHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 09:07:19 -0400
Received: from ns.km23152-01.keymachine.de ([87.118.114.125]:45124 "EHLO
	km23152-01.keymachine.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753808AbYFENHR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 09:07:17 -0400
Subject: [PATCH 2.6.26rc5] xfrm: SHA-256/384/512 HMAC support for IPsec
From: Martin Willi <martin@strongswan.org>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
X-Sieve: CMU Sieve 2.2
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun  5 14:48:08 2008
X-DSPAM-Confidence: 0.9977
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4847e088304362021815202
Content-Type: text/plain; charset=UTF-8
Date: Thu, 05 Jun 2008 15:06:51 +0200
Message-Id: <1212671211.6339.58.camel@martin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8BIT
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun  5 15:07:54 2008
X-DSPAM-Confidence: 0.9981
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4847e52a304361278018588
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFC4868 defines the use of SHA256, SHA384 and SHA512 in HMAC using 128,
192 and 256 bits truncation. This patch replaces the outdated SHA256
algorithm with 96 bits truncation by the 128 bit variant and adds the
SHA384/512 algorithms.

﻿Signed-off-by: Martin Willi <martin@strongswan.org>

---
Replacing the 96 bit truncation SHA256 algorithm might be problematic,
but it is obsolete in IPsec and I don't see a way to register two
different truncation lengths in XFRM.

--- a/net/xfrm/xfrm_algo.c 2008-06-05 14:01:01.000000000 +0200
+++ b/net/xfrm/xfrm_algo.c 2008-06-05 14:39:31.000000000 +0200
@@ -187,7 +187,7 @@
 
 	.uinfo = {
 		.auth = {
-			.icv_truncbits = 96,
+			.icv_truncbits = 128,
 			.icv_fullbits = 256,
 		}
 	},
@@ -200,6 +200,42 @@
 	}
 },
 {
+	.name = "hmac(sha384)",
+	.compat = "sha384",
+
+	.uinfo = {
+		.auth = {
+			.icv_truncbits = 192,
+			.icv_fullbits = 384,
+		}
+	},
+
+	.desc = {
+		.sadb_alg_id = SADB_X_AALG_SHA2_384HMAC,
+		.sadb_alg_ivlen = 0,
+		.sadb_alg_minbits = 384,
+		.sadb_alg_maxbits = 384
+	}
+},
+{
+	.name = "hmac(sha512)",
+	.compat = "sha512",
+
+	.uinfo = {
+		.auth = {
+			.icv_truncbits = 256,
+			.icv_fullbits = 512,
+		}
+	},
+
+	.desc = {
+		.sadb_alg_id = SADB_X_AALG_SHA2_512HMAC,
+		.sadb_alg_ivlen = 0,
+		.sadb_alg_minbits = 512,
+		.sadb_alg_maxbits = 512
+	}
+},
+{
 	.name = "hmac(rmd160)",
 	.compat = "rmd160",



