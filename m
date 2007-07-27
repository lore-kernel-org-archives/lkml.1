Return-Path: <linux-kernel-owner+w=401wt.eu-S935836AbXG0Jqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935836AbXG0Jqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765594AbXG0Jpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:45:42 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:35742 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935838AbXG0Jpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:45:40 -0400
Date: Fri, 27 Jul 2007 11:44:18 +0200 (MEST)
Message-Id: <200707270944.LAA17116@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 04/68] 0 -> NULL, for arch/blackfin
Cc: aubrey.li@analog.com, bryan.wu@analog.com, akpm@linux-foundation.org,
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
Cc: aubrey.li@analog.com
Cc: bryan.wu@analog.com
Cc: akpm@linux-foundation.org
---

 traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 3909f5b..691c66d 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -546,7 +546,7 @@ void dump_bfin_regs(struct pt_regs *fp, 
 	}
 
 	printk(KERN_EMERG "return address: [0x%p]; contents of:", retaddr);
-	if (retaddr != 0 && retaddr <= (void *)physical_mem_end
+	if (retaddr != NULL && retaddr <= (void *)physical_mem_end
 #if L1_CODE_LENGTH != 0
 	    /* FIXME: Copy the code out of L1 Instruction SRAM through dma
 	       memcpy.  */

