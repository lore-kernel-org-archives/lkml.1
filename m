Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYCJQmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYCJQmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYCJQmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:42:00 -0400
Received: from saeurebad.de ([85.214.36.134]:44356 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYCJQmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:42:00 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Remove redundant display of free swap space in show_mem()
Date: Mon, 10 Mar 2008 17:40:14 +0100
Message-ID: <87abl68rdd.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@saeurebad.de>

show_free_areas() already displays free swap space, no need to do it a
second time in show_mem() which calls the former anyway.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 arch/x86/mm/init_64.c    |    3 ---
 arch/x86/mm/pgtable_32.c |    1 -
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 8230d1e..94baf63 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -89,9 +89,6 @@ void show_mem(void)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas();
-	printk(KERN_INFO "Free swap:       %6ldkB\n",
-		nr_swap_pages << (PAGE_SHIFT-10));
-
 	for_each_online_pgdat(pgdat) {
 		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
 			/*
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 6530201..bacae27 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -32,7 +32,6 @@ void show_mem(void)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas();
-	printk(KERN_INFO "Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
 	for_each_online_pgdat(pgdat) {
 		pgdat_resize_lock(pgdat, &flags);
 		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
-- 
1.5.2.2

