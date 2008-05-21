Return-Path: <linux-kernel-owner+w=401wt.eu-S936171AbYEURpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936171AbYEURpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932826AbYEURoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:44:19 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53693 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241AbYEURoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:44:18 -0400
Date: Wed, 21 May 2008 20:42:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] frv: export empty_zero_page
Message-ID: <20080521174203.GG15355@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  MODPOST 1845 modules
ERROR: "empty_zero_page" [fs/ext4/ext4dev.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/frv/mm/init.c |    2 ++
 1 file changed, 2 insertions(+)

55cf8b72a4e2a78f61de2ef01e70bdd533c6bcf5 diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
index b841ecf..94ea3d8 100644
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <linux/bootmem.h>
 #include <linux/highmem.h>
+#include <linux/module.h>
 
 #include <asm/setup.h>
 #include <asm/segment.h>
@@ -57,6 +58,7 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 static unsigned long empty_bad_page_table;
 static unsigned long empty_bad_page;
 unsigned long empty_zero_page;
+EXPORT_SYMBOL_GPL(empty_zero_page);
 
 /*****************************************************************************/
 /*

