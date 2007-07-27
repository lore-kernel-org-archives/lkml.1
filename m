Return-Path: <linux-kernel-owner+w=401wt.eu-S937135AbXG0Jwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937135AbXG0Jwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936054AbXG0JrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:47:21 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:36317 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936555AbXG0JrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:47:17 -0400
Date: Fri, 27 Jul 2007 11:45:50 +0200 (MEST)
Message-Id: <200707270945.LAA17362@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 17/68] 0 -> NULL, for arch/sparc64
Cc: davem@davemloft.net, sparclinux@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When comparing a pointer, it's clearer to compare it to NULL than to 0.

Here is an excerpt of the semantic patch: 

@@
expression *E;
@@

  E ==
- 0
+ NULL

@@
expression *E;
@@

  E !=
- 0
+ NULL

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: davem@davemloft.net
Cc: sparclinux@vger.kernel.org
Cc: akpm@linux-foundation.org
---

 kernel/prom.c |    2 +-
 prom/tree.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc64/kernel/prom.c b/arch/sparc64/kernel/prom.c
index f4e0a9a..35d4eb5 100644
--- a/arch/sparc64/kernel/prom.c
+++ b/arch/sparc64/kernel/prom.c
@@ -38,7 +38,7 @@ struct device_node *of_find_node_by_phan
 {
 	struct device_node *np;
 
-	for (np = allnodes; np != 0; np = np->allnext)
+	for (np = allnodes; np != NULL; np = np->allnext)
 		if (np->node == handle)
 			break;
 
diff --git a/arch/sparc64/prom/tree.c b/arch/sparc64/prom/tree.c
index b2c5b12..33eacd0 100644
--- a/arch/sparc64/prom/tree.c
+++ b/arch/sparc64/prom/tree.c
@@ -264,7 +264,7 @@ prom_setprop(int node, const char *pname
 {
 	if (size == 0)
 		return 0;
-	if ((pname == 0) || (value == 0))
+	if ((pname == NULL) || (value == NULL))
 		return 0;
 	
 #ifdef CONFIG_SUN_LDOMS

