Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbYG0NFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbYG0NFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 09:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYG0NFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 09:05:16 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33094 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbYG0NFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:05:14 -0400
Date: Sun, 27 Jul 2008 16:04:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org, lethal@linux-sh.org,
       linux-sh@vger.kernel.org
Subject: [2.6 patch] mm/hugetlb.c must #include <asm/io.h>
Message-ID: <20080727130438.GJ9301@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error on sh caused by
commit aa888a74977a8f2120ae9332376e179c39a6b07d
(hugetlb: support larger than MAX_ORDER):

<--  snip  -->

...
  CC      mm/hugetlb.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/hugetlb.c: In function 'alloc_bootmem_huge_page':
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/hugetlb.c:958: error: implicit declaration of function 'virt_to_phys'
make[2]: *** [mm/hugetlb.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
98c5be88abb276588ea1f377f08726308765aa3c 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a8bf4ab..6101012 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -19,6 +19,7 @@
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/io.h>
 
 #include <linux/hugetlb.h>
 #include "internal.h"

