Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZLVXoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZLVXoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 18:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbZLVXmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 18:42:09 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58153 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbZLVXmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 18:42:05 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 22 Dec 2009 15:40:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/25] bootmem: move out map assigning out of loop
In-reply-to: <1261525263-13763-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1261525263-13763-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.0.2
References: <1261525263-13763-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/bootmem.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 7d14868..8caf744 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -171,6 +171,7 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
 	int aligned;
 	struct page *page;
+	unsigned long *map;
 	unsigned long start, end, pages, count = 0;
 
 	if (!bdata->node_bootmem_map)
@@ -188,10 +189,10 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 	bdebug("nid=%td start=%lx end=%lx aligned=%d\n",
 		bdata - bootmem_node_data, start, end, aligned);
 
+	map = bdata->node_bootmem_map;
 	while (start < end) {
-		unsigned long *map, idx, vec;
+		unsigned long idx, vec;
 
-		map = bdata->node_bootmem_map;
 		idx = start - bdata->node_min_pfn;
 		vec = ~map[idx / BITS_PER_LONG];
 
-- 
1.6.0.2

