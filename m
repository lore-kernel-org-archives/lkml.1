Return-Path: <linux-kernel-owner+w=401wt.eu-S1762526AbZE1ItU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762526AbZE1ItU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759780AbZE1ItK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:49:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbZE1ItJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:49:09 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [RESEND] [PATCH] memcg: Fix build warning and avoid checking for mem != null again and again
Cc: balbir@linux.vnet.ibm.com, Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Content-Disposition: inline
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
Date: Thu, 28 May 2009 14:20:43 +0530
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200905281420.44338.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Resending the patch to Andrew for inclusion in -mm tree.

Thanks
Nikanth

Fix build warning, "mem_cgroup_is_obsolete defined but not used" when
CONFIG_DEBUG_VM is not set. Also avoid checking for !mem again and again.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 01c2d8f..d253846 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -314,14 +314,6 @@ static struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 	return mem;
 }
 
-static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
-{
-	if (!mem)
-		return true;
-	return css_is_removed(&mem->css);
-}
-
-
 /*
  * Call callback function against all cgroup under hierarchy tree.
  */
@@ -932,7 +924,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 	if (unlikely(!mem))
 		return 0;
 
-	VM_BUG_ON(!mem || mem_cgroup_is_obsolete(mem));
+	VM_BUG_ON(css_is_removed(&mem->css));
 
 	while (1) {
 		int ret;


