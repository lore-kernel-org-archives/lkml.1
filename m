Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbXGFLfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbXGFLfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 07:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbXGFLfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 07:35:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35493 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347AbXGFLfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 07:35:38 -0400
Subject: [PATCH] mm: fixup /proc/vmstat output
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>, riel <riel@redhat.com>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 13:35:34 +0200
Message-Id: <1183721734.7054.102.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Line up the vmstat_text with zone_stat_item

enum zone_stat_item {
	/* First 128 byte cacheline (assuming 64 bit words) */
	NR_FREE_PAGES,
	NR_INACTIVE,
	NR_ACTIVE,

We current have nr_active and nr_inactive reversed.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c
+++ linux-2.6/mm/vmstat.c
@@ -700,8 +700,8 @@ const struct seq_operations pagetypeinfo
 static const char * const vmstat_text[] = {
 	/* Zoned VM counters */
 	"nr_free_pages",
-	"nr_active",
 	"nr_inactive",
+	"nr_active",
 	"nr_anon_pages",
 	"nr_mapped",
 	"nr_file_pages",


