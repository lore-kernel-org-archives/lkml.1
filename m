Return-Path: <linux-kernel-owner+w=401wt.eu-S934867AbZKYRS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934867AbZKYRS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759406AbZKYRR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:17:58 -0500
Received: from mga05.intel.com ([192.55.52.89]:55693 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758890AbZKYRK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:10:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,287,1257148800"; 
   d="scan'208";a="517314769"
Date: Wed, 25 Nov 2009 19:46:33 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: [PATCH]crypto: Fix ghash pclmulqdqni algorithm without test
Message-ID: <20091126004633.GB32230@youquan-linux.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when load ghash-clmulni-intel driver,kernel will report no test for some algorithm
with PCLMULQDQ NI. The strange information as following:

alg: No test for __ghash (__ghash-pclmulqdqni)
alg: No test for __ghash (cryptd(__ghash-pclmulqdqni))

crypto_alg's cra_name is use to descript algorithm itself, do not care the 
concrete implement. So this patch unify them and also can fix the algorithm
implementation without test. 

Signed-off-by: Youquan, Song <youquan.song@intel.com>
---

diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index cbcc8d8..3fab6cb 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -141,7 +141,7 @@ static struct shash_alg ghash_alg = {
 	.setkey		= ghash_setkey,
 	.descsize	= sizeof(struct ghash_desc_ctx),
 	.base		= {
-		.cra_name		= "__ghash",
+		.cra_name		= "ghash",
 		.cra_driver_name	= "__ghash-pclmulqdqni",
 		.cra_priority		= 0,
 		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
