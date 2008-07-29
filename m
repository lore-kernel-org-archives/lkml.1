Return-Path: <linux-kernel-owner+w=401wt.eu-S1757739AbYG2GDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbYG2GDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbYG2GB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:01:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:5661 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbYG2GBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:01:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=umb68E98zIZd1slMHpfMoK8G5qPggA2HtlAbr6mB3QzlmQPRH6UOX1PzgKz3AVR7no
         UhGfX5Tx5UVCDjgjYjtqqpv6iSy7TFETJr9XqG7ciDBdJvlxSgZNNhSoTNoXYkKO9BwG
         EWtu+Gyq+cfbcXtC/f5KdfTZt5L1/Yte/1YqI=
Subject: [PATCH 7/8] powerpc: replace __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 23:01:36 -0700
Message-Id: <1217311296.23389.30.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/powerpc/kernel/lparcfg.c        |    8 ++++----
 arch/powerpc/platforms/pseries/cmm.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index 9f856a0..4281bd0 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -505,10 +505,10 @@ static ssize_t update_ppp(u64 *entitlement, u8 *weight)
 		return -EINVAL;
 
 	pr_debug("%s: current_entitled = %lu, current_weight = %u\n",
-	         __FUNCTION__, ppp_data.entitlement, ppp_data.weight);
+	         __func__, ppp_data.entitlement, ppp_data.weight);
 
 	pr_debug("%s: new_entitled = %lu, new_weight = %u\n",
-		 __FUNCTION__, new_entitled, new_weight);
+		 __func__, new_entitled, new_weight);
 
 	retval = plpar_hcall_norets(H_SET_PPP, new_entitled, new_weight);
 	return retval;
@@ -551,10 +551,10 @@ static ssize_t update_mpp(u64 *entitlement, u8 *weight)
 		return -EINVAL;
 
 	pr_debug("%s: current_entitled = %lu, current_weight = %u\n",
-	         __FUNCTION__, mpp_data.entitled_mem, mpp_data.mem_weight);
+	         __func__, mpp_data.entitled_mem, mpp_data.mem_weight);
 
 	pr_debug("%s: new_entitled = %lu, new_weight = %u\n",
-	         __FUNCTION__, new_entitled, new_weight);
+	         __func__, new_entitled, new_weight);
 
 	rc = plpar_hcall_norets(H_SET_MPP, new_entitled, new_weight);
 	return rc;
diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 38fe32a..5cd4d27 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -121,7 +121,7 @@ static long cmm_alloc_pages(long nr)
 			npa = (struct cmm_page_array *)__get_free_page(GFP_NOIO | __GFP_NOWARN |
 								       __GFP_NORETRY | __GFP_NOMEMALLOC);
 			if (!npa) {
-				pr_info("%s: Can not allocate new page list\n", __FUNCTION__);
+				pr_info("%s: Can not allocate new page list\n", __func__);
 				free_page(addr);
 				break;
 			}
@@ -138,7 +138,7 @@ static long cmm_alloc_pages(long nr)
 		}
 
 		if ((rc = plpar_page_set_loaned(__pa(addr)))) {
-			pr_err("%s: Can not set page to loaned. rc=%ld\n", __FUNCTION__, rc);
+			pr_err("%s: Can not set page to loaned. rc=%ld\n", __func__, rc);
 			spin_unlock(&cmm_lock);
 			free_page(addr);
 			break;
-- 
1.6.0.rc1.154.ge3fc


