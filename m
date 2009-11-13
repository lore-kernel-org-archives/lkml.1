Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbZKMGAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbZKMGAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 01:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZKMGAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 01:00:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54590 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbZKMGAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 01:00:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AFCF5D6.70902@jp.fujitsu.com>
Date: Fri, 13 Nov 2009 14:59:50 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH] mm/memory_hotplug : fix section mismatch
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_MEMORY_HOTPLUG I got following warning:

WARNING: vmlinux.o(.text+0x1276b0): Section mismatch in reference from
the function hotadd_new_pgdat() to the function
.meminit.text:free_area_init_node()
The function hotadd_new_pgdat() references
the function __meminit free_area_init_node().
This is often because hotadd_new_pgdat lacks a __meminit
annotation or the annotation of free_area_init_node is wrong.

Use __ref to fix this.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 mm/memory_hotplug.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 821dee5..380aef4 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -447,7 +447,8 @@ int online_pages(unsigned long pfn, unsigned long nr_pages)
 }
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
-static pg_data_t *hotadd_new_pgdat(int nid, u64 start)
+/* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
+static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
 {
 	struct pglist_data *pgdat;
 	unsigned long zones_size[MAX_NR_ZONES] = {0};
-- 
1.6.5.2


