Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbYIXEzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbYIXEzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 00:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYIXEyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 00:54:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:53734 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYIXEyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 00:54:43 -0400
Date: Tue, 23 Sep 2008 21:54:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH 3/3] corruption check: fix various checkpatch warnings
Message-ID: <20080923215446.21cd678f@infradead.org>
In-Reply-To: <20080923215335.05678239@infradead.org>
References: <20080923215335.05678239@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9e49c38637f335d5c91a0f1c4deea7ce2c20aa34 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 23 Sep 2008 11:09:10 -0700
Subject: [PATCH] corruption check: fix various checkpatch warnings

Cleanups as suggested by Randy / checkpatch.pl

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/check.c |    8 ++++----
 include/linux/kernel.h  |    5 -----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index b22733f..c59bfe6 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -80,7 +80,7 @@ void __init setup_bios_corruption_check(void)
 
 	corruption_check_size = round_up(corruption_check_size, PAGE_SIZE);
 
-	while(addr < corruption_check_size && num_scan_areas < MAX_SCAN_AREAS) {
+	while (addr < corruption_check_size && num_scan_areas < MAX_SCAN_AREAS) {
 		u64 size;
 		addr = find_e820_area_size(addr, &size, PAGE_SIZE);
 
@@ -119,11 +119,11 @@ void check_for_bios_corruption(void)
 	if (!memory_corruption_check)
 		return;
 
-	for(i = 0; i < num_scan_areas; i++) {
+	for (i = 0; i < num_scan_areas; i++) {
 		unsigned long *addr = __va(scan_areas[i].addr);
 		unsigned long size = scan_areas[i].size;
 
-		for(; size; addr++, size -= sizeof(unsigned long)) {
+		for (; size; addr++, size -= sizeof(unsigned long)) {
 			if (!*addr)
 				continue;
 			printk(KERN_ERR "Corrupted low memory at %p (%lx phys) = %08lx\n",
@@ -150,7 +150,7 @@ static void periodic_check_for_corruption(unsigned long data)
 
 
 
-int start_periodic_check_for_corruption(void)
+static int start_periodic_check_for_corruption(void)
 {
 	if (!memory_corruption_check || corruption_check_period == 0)
 		return 0;
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 01085d2..b39c7ef 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -260,15 +260,10 @@ extern int root_mountflags;
  * able to scatter it around anywhere in the kernel.
  */
 void check_for_bios_corruption(void);
-int start_periodic_check_for_corruption(void);
 #else
 static inline void check_for_bios_corruption(void)
 {
 }
-
-static inline void start_periodic_check_for_corruption(void)
-{
-}
 #endif
 
 /* Values used for system_state */
-- 
1.5.5.1




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
