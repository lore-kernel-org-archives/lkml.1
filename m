Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbYFLWM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbYFLWM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYFLWMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:12:34 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44201 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552AbYFLWMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:12:33 -0400
Date: Fri, 13 Jun 2008 01:11:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: takata@linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] m32r/mm/: cleanups
Message-ID: <20080612221125.GN17231@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the following needlessly global code static:
  - discontig.c: m32r_node_data[]
  - init.c: reservedpages_count()
- remove the following unused code:
  - mmu.S: m32r_itlb_entrys
  - mmu.S: m32r_otlb_entrys

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m32r/mm/discontig.c |    2 +-
 arch/m32r/mm/init.c      |    2 +-
 arch/m32r/mm/mmu.S       |    3 ---
 3 files changed, 2 insertions(+), 5 deletions(-)

ca2709395882cca4328ddb10620f1a6ef4ddb070 diff --git a/arch/m32r/mm/discontig.c b/arch/m32r/mm/discontig.c
index 07c1af7..39d2e4e 100644
--- a/arch/m32r/mm/discontig.c
+++ b/arch/m32r/mm/discontig.c
@@ -22,7 +22,7 @@ struct pglist_data *node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
 static bootmem_data_t node_bdata[MAX_NUMNODES] __initdata;
 
-pg_data_t m32r_node_data[MAX_NUMNODES];
+static pg_data_t m32r_node_data[MAX_NUMNODES];
 
 /* Memory profile */
 typedef struct {
diff --git a/arch/m32r/mm/init.c b/arch/m32r/mm/init.c
index bbd97c8..2fdbc45 100644
--- a/arch/m32r/mm/init.c
+++ b/arch/m32r/mm/init.c
@@ -149,7 +149,7 @@ void __init paging_init(void)
 	hole_pages = zone_sizes_init();
 }
 
-int __init reservedpages_count(void)
+static int __init reservedpages_count(void)
 {
 	int reservedpages, nid, i;
 
diff --git a/arch/m32r/mm/mmu.S b/arch/m32r/mm/mmu.S
index 49a6d16..484b7ed 100644
--- a/arch/m32r/mm/mmu.S
+++ b/arch/m32r/mm/mmu.S
@@ -342,9 +342,6 @@ clear_tlb:
 ;;
 	jmp	r14
 
-ENTRY(m32r_itlb_entrys)
-ENTRY(m32r_otlb_entrys)
-
 #endif  /* CONFIG_MMU */
 
 	.end

