Return-Path: <linux-kernel-owner+w=401wt.eu-S937074AbXG0JwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937074AbXG0JwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936276AbXG0JrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:47:15 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:36295 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936054AbXG0JrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:47:11 -0400
Date: Fri, 27 Jul 2007 11:45:43 +0200 (MEST)
Message-Id: <200707270945.LAA17352@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 16/68] 0 -> NULL, for arch/sparc
Cc: wli@holomorphy.com, sparclinux@vger.kernel.org, akpm@linux-foundation.org,
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
Cc: wli@holomorphy.com
Cc: sparclinux@vger.kernel.org
Cc: akpm@linux-foundation.org
---

 kernel/ioport.c |    6 +++---
 kernel/pcic.c   |    2 +-
 kernel/prom.c   |    2 +-
 prom/bootstr.c  |    2 +-
 prom/tree.c     |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 62182d2..3f1a8e2 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -181,7 +181,7 @@ static void __iomem *_sparc_alloc_io(uns
 
 	if (name == NULL) name = "???";
 
-	if ((xres = xres_alloc()) != 0) {
+	if ((xres = xres_alloc()) != NULL) {
 		tack = xres->xname;
 		res = &xres->xres;
 	} else {
@@ -835,7 +835,7 @@ _sparc_io_get_info(char *buf, char **sta
 	for (r = ((struct resource *)data)->child; r != NULL; r = r->sibling) {
 		if (p + 32 >= e)	/* Better than nothing */
 			break;
-		if ((nm = r->name) == 0) nm = "???";
+		if ((nm = r->name) == NULL) nm = "???";
 		p += sprintf(p, "%016llx-%016llx: %s\n",
 				(unsigned long long)r->start,
 				(unsigned long long)r->end, nm);
@@ -858,7 +858,7 @@ _sparc_find_resource(struct resource *ro
 {
         struct resource *tmp;
 
-	for (tmp = root->child; tmp != 0; tmp = tmp->sibling) {
+	for (tmp = root->child; tmp != NULL; tmp = tmp->sibling) {
 		if (tmp->start <= hit && tmp->end >= hit)
 			return tmp;
 	}
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index f2eae45..eace6e5 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -540,7 +540,7 @@ pcic_fill_irq(struct linux_pcic *pcic, s
 		prom_getstring(node, "name", namebuf, sizeof(namebuf));
 	}
 
-	if ((p = pcic->pcic_imap) == 0) {
+	if ((p = pcic->pcic_imap) == NULL) {
 		dev->irq = 0;
 		return;
 	}
diff --git a/arch/sparc/kernel/prom.c b/arch/sparc/kernel/prom.c
index e3a5376..b5ab1a6 100644
--- a/arch/sparc/kernel/prom.c
+++ b/arch/sparc/kernel/prom.c
@@ -33,7 +33,7 @@ struct device_node *of_find_node_by_phan
 {
 	struct device_node *np;
 
-	for (np = allnodes; np != 0; np = np->allnext)
+	for (np = allnodes; np != NULL; np = np->allnext)
 		if (np->node == handle)
 			break;
 
diff --git a/arch/sparc/prom/bootstr.c b/arch/sparc/prom/bootstr.c
index cfdeac2..1f850b9 100644
--- a/arch/sparc/prom/bootstr.c
+++ b/arch/sparc/prom/bootstr.c
@@ -33,7 +33,7 @@ prom_getbootargs(void)
 		/* Start from 1 and go over fd(0,0,0)kernel */
 		for(iter = 1; iter < 8; iter++) {
 			arg = (*(romvec->pv_v0bootargs))->argv[iter];
-			if(arg == 0) break;
+			if(arg == NULL) break;
 			while(*arg != 0) {
 				/* Leave place for space and null. */
 				if(cp >= barg_buf + BARG_LEN-2){
diff --git a/arch/sparc/prom/tree.c b/arch/sparc/prom/tree.c
index 5ec2465..782be75 100644
--- a/arch/sparc/prom/tree.c
+++ b/arch/sparc/prom/tree.c
@@ -309,7 +309,7 @@ int prom_setprop(int node, char *pname, 
 	int ret;
 
 	if(size == 0) return 0;
-	if((pname == 0) || (value == 0)) return 0;
+	if((pname == NULL) || (value == NULL)) return 0;
 	spin_lock_irqsave(&prom_lock, flags);
 	ret = prom_nodeops->no_setprop(node, pname, value, size);
 	restore_current();

