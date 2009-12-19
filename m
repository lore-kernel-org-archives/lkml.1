Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZLSHcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZLSHcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 02:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZLSHcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 02:32:17 -0500
Received: from mga07.intel.com ([143.182.124.22]:56302 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751917AbZLSHcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 02:32:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="224682466"
Date: Sat, 19 Dec 2009 10:07:36 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Youquan,Song" <youquan.song@linux.intel.com>,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix complain about lack test for internal used algorithm
Message-ID: <20091219150736.GA5368@youquan-linux.bj.intel.com>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <200912101939.30446.david-b@pacbell.net> <20091211034711.GA2773@suse.de> <200912102013.59329.david-b@pacbell.net> <20091211043849.GA18007@suse.de> <1260509771.12346.138.camel@localhost> <20091211132321.GA17228@youquan-linux.bj.intel.com> <20091211060448.GA28704@gondor.apana.org.au> <20091219094043.GA23639@youquan-linux.bj.intel.com> <20091219022917.GA19431@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091219022917.GA19431@gondor.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No what I meant is that each algorithm should have its own nul
> entry.  IOW we don't need this crypto_is_internal stuff at all.

Hi Herbert,

Well, Are you satisfied with the following modification?

Thanks.

-Youquan


diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f70ce52..60c9857 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1477,9 +1477,69 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
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
@@ -1623,6 +1683,30 @@ static const struct alg_test_desc alg_test_descs[] = {
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

