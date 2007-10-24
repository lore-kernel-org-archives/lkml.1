Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbXJXFiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbXJXFiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbXJXFiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:38:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57233
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753993AbXJXFiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:38:12 -0400
Date: Tue, 23 Oct 2007 22:37:56 -0700 (PDT)
Message-Id: <20071023.223756.34760847.davem@davemloft.net>
To: jens.axboe@oracle.com
CC: linux-kernel@vger.kernel.org
Subject: [SPARC64]: More SG build fixes
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


diff --git a/arch/sparc64/kernel/ldc.c b/arch/sparc64/kernel/ldc.c
index c8313cb..217478a 100644
--- a/arch/sparc64/kernel/ldc.c
+++ b/arch/sparc64/kernel/ldc.c
@@ -2121,7 +2121,7 @@ int ldc_map_sg(struct ldc_channel *lp,
 	state.nc = 0;
 
 	for (i = 0; i < num_sg; i++)
-		fill_cookies(&state, page_to_pfn(sg[i].page) << PAGE_SHIFT,
+		fill_cookies(&state, page_to_pfn(sg_page(&sg[i])) << PAGE_SHIFT,
 			     sg[i].offset, sg[i].length);
 
 	return state.nc;
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 7276f7d..fac4c6c 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/scatterlist.h>
 
 #include <asm/vio.h>
 #include <asm/ldc.h>
