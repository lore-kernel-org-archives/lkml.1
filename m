Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbYJETK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbYJETK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbYJETKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:10:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:32995 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbYJETKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:10:20 -0400
Date: Sun, 5 Oct 2008 12:07:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86: corruption-check: fix some style issues
Message-ID: <20081005120705.02492d44@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 5 Oct 2008 11:08:10 -0700
Subject: [PATCH] x86: corruption-check: fix some style issues

Before moving the code to it's own file, fix some style issues
in the corruption check code.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/setup.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 6133530..5a21905 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -656,7 +656,7 @@ static void __init setup_bios_corruption_check(void)
 
 	corruption_check_size = round_up(corruption_check_size, PAGE_SIZE);
 
-	while(addr < corruption_check_size && num_scan_areas < MAX_SCAN_AREAS) {
+	while (addr < corruption_check_size && num_scan_areas < MAX_SCAN_AREAS) {
 		u64 size;
 		addr = find_e820_area_size(addr, &size, PAGE_SIZE);
 
@@ -695,11 +695,11 @@ void check_for_bios_corruption(void)
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
@@ -715,7 +715,8 @@ void check_for_bios_corruption(void)
 static void periodic_check_for_corruption(unsigned long data)
 {
 	check_for_bios_corruption();
-	mod_timer(&periodic_check_timer, round_jiffies(jiffies + corruption_check_period*HZ));
+	mod_timer(&periodic_check_timer,
+		round_jiffies(jiffies + corruption_check_period*HZ));
 }
 
 void start_periodic_check_for_corruption(void)
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
