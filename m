Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbYELWkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbYELWkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbYELWjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:39:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59391
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754492AbYELWjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:39:54 -0400
Date: Mon, 12 May 2008 15:39:48 -0700 (PDT)
Message-Id: <20080512.153948.193688062.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080512.153628.193699676.davem@davemloft.net>
References: <18472.38209.615770.265421@alkaid.it.uu.se>
	<20080512.153143.48741227.davem@davemloft.net>
	<20080512.153628.193699676.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 12 May 2008 15:36:28 -0700 (PDT)

> Nevermind I see why the messages don't show up.  Hold on for a second
> and I'll send an updated debugging patch.

Try this patch instead, thanks!

diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
index a9828d7..a628a99 100644
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -1353,6 +1353,8 @@ static void __init bootmem_init_one_node(int nid)
 
 	numadbg("bootmem_init_one_node(%d)\n", nid);
 
+	lmb_dump_all();
+
 	p = NODE_DATA(nid);
 
 	if (p->node_spanned_pages) {
diff --git a/lib/lmb.c b/lib/lmb.c
index 83287d3..f294bbc 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -10,6 +10,8 @@
  *      2 of the License, or (at your option) any later version.
  */
 
+#define DEBUG
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
@@ -29,7 +31,7 @@ void lmb_dump_all(void)
 	pr_debug("    memory.size		  = 0x%llx\n",
 	    (unsigned long long)lmb.memory.size);
 	for (i=0; i < lmb.memory.cnt ;i++) {
-		pr_debug("    memory.region[0x%x].base       = 0x%llx\n",
+		pr_debug("    memory.region[0x%lx].base       = 0x%llx\n",
 		    i, (unsigned long long)lmb.memory.region[i].base);
 		pr_debug("		      .size     = 0x%llx\n",
 		    (unsigned long long)lmb.memory.region[i].size);
@@ -38,7 +40,7 @@ void lmb_dump_all(void)
 	pr_debug("    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
 	pr_debug("    reserved.size	  = 0x%lx\n", lmb.reserved.size);
 	for (i=0; i < lmb.reserved.cnt ;i++) {
-		pr_debug("    reserved.region[0x%x].base       = 0x%llx\n",
+		pr_debug("    reserved.region[0x%lx].base       = 0x%llx\n",
 		    i, (unsigned long long)lmb.reserved.region[i].base);
 		pr_debug("		      .size     = 0x%llx\n",
 		    (unsigned long long)lmb.reserved.region[i].size);
