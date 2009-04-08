Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbZDHFYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbZDHFYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761358AbZDHFWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:22:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34544 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760174AbZDHFWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:22:16 -0400
Date: Wed, 8 Apr 2009 14:20:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH] memcg remove warning at DEBUG_VM=off
Message-Id: <20090408142042.3fb62eea.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
This is against 2.6.30-rc1. (maybe no problem against mmotm.)

==
Fix warning as

  CC      mm/memcontrol.o
mm/memcontrol.c:318: warning: ‘mem_cgroup_is_obsolete’ defined but not used

This is called only from VM_BUG_ON().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: linux-2.6.30-rc1/mm/memcontrol.c
===================================================================
--- linux-2.6.30-rc1.orig/mm/memcontrol.c
+++ linux-2.6.30-rc1/mm/memcontrol.c
@@ -314,13 +314,14 @@ static struct mem_cgroup *try_get_mem_cg
 	return mem;
 }
 
+#ifdef CONFIG_DEBUG_VM
 static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
 {
 	if (!mem)
 		return true;
 	return css_is_removed(&mem->css);
 }
-
+#endif
 
 /*
  * Call callback function against all cgroup under hierarchy tree.

