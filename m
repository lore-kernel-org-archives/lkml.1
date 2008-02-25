Return-Path: <linux-kernel-owner+w=401wt.eu-S1760370AbYBYAKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370AbYBYAKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbYBYAI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:08:29 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33643 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757333AbYBYAI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:08:28 -0500
Date: Mon, 25 Feb 2008 02:07:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/swapfile.c: make code static
Message-ID: <20080225000733.GF2088@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global code static:
- swap_lock
- nr_swapfiles
- struct swap_list

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/swap.h |    3 ---
 mm/swapfile.c        |    6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

bb7f3cffcbe9023d345ff94dd983292613a8de6b diff --git a/include/linux/swap.h b/include/linux/swap.h
index 878459a..9c9f4e5 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -237,7 +237,6 @@ extern struct page *swapin_readahead(swp_entry_t, gfp_t,
 
 /* linux/mm/swapfile.c */
 extern long total_swap_pages;
-extern unsigned int nr_swapfiles;
 extern void si_swapinfo(struct sysinfo *);
 extern swp_entry_t get_swap_page(void);
 extern swp_entry_t get_swap_page_of_type(int);
@@ -254,8 +253,6 @@ extern int can_share_swap_page(struct page *);
 extern int remove_exclusive_swap_page(struct page *);
 struct backing_dev_info;
 
-extern spinlock_t swap_lock;
-
 /* linux/mm/thrash.c */
 extern struct mm_struct * swap_token_mm;
 extern void grab_swap_token(void);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2da149c..0b20c79 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -33,8 +33,8 @@
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
 
-DEFINE_SPINLOCK(swap_lock);
-unsigned int nr_swapfiles;
+static DEFINE_SPINLOCK(swap_lock);
+static unsigned int nr_swapfiles;
 long total_swap_pages;
 static int swap_overflow;
 
@@ -43,7 +43,7 @@ static const char Unused_file[] = "Unused swap file entry ";
 static const char Bad_offset[] = "Bad swap offset entry ";
 static const char Unused_offset[] = "Unused swap offset entry ";
 
-struct swap_list_t swap_list = {-1, -1};
+static struct swap_list_t swap_list = {-1, -1};
 
 static struct swap_info_struct swap_info[MAX_SWAPFILES];
 

