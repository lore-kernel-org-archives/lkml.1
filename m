Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbYCCSKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbYCCSKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbYCCSJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:09:21 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51610 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758075AbYCCSJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:09:19 -0500
Date: Mon, 3 Mar 2008 20:07:42 +0200
From: Adrian Bunk <adrian.bunk@movial.fi>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sh/mm/pg-sh7705.c must #include <linux/fs.h>
Message-ID: <20080303180742.GJ26072@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error:

<--  snip  -->

...
  CC      arch/sh/mm/pg-sh7705.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/mm/pg-sh7705.c: In function 'ptep_get_and_clear':
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/mm/pg-sh7705.c:130: error: implicit declaration of function 'mapping_writably_mapped'
make[2]: *** [arch/sh/mm/pg-sh7705.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---
abeeede2889319116acd5969913c5fe3c78ead05 foobar
diff --git a/arch/sh/mm/pg-sh7705.c b/arch/sh/mm/pg-sh7705.c
index a4b015f..7f885b7 100644
--- a/arch/sh/mm/pg-sh7705.c
+++ b/arch/sh/mm/pg-sh7705.c
@@ -14,6 +14,7 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/threads.h>
+#include <linux/fs.h>
 #include <asm/addrspace.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>

