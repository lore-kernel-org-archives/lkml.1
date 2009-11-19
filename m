Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbZKRQzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbZKRQzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757731AbZKRQzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:55:43 -0500
Received: from mga05.intel.com ([192.55.52.89]:53113 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757547AbZKRQzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:55:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,766,1249282800"; 
   d="scan'208";a="748213859"
Date: Wed, 18 Nov 2009 19:32:02 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: [PATCH]crypto: Fix algorithm and driver duplicate registered
Message-ID: <20091119003202.GA28448@youquan-linux.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kernel, All the algorithms with same algorithm name and driver name
are registered. 
But the proper behaviour should be only one algorithm be registered when 
algorithm and driver name duplicate.

Signed-off-by: Youquan, Song <youquan.song@intel.com>
---

diff --git a/crypto/algapi.c b/crypto/algapi.c
index f149b1c..a823fb2 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -207,8 +207,8 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 			continue;
 		}
 
-		if (!strcmp(q->cra_driver_name, alg->cra_name) ||
-		    !strcmp(q->cra_name, alg->cra_driver_name))
+		if (!strcmp(q->cra_driver_name, alg->cra_driver_name) &&
+		    !strcmp(q->cra_name, alg->cra_name))
 			goto err;
 	}
 
