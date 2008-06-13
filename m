Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbYFMUV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbYFMUV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 16:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYFMUVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 16:21:19 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:4578 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYFMUVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 16:21:18 -0400
Subject: [PATCH] collect lru meminfo statistics from correct offset
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20080613134827.5dbac5ac@cuia.bos.redhat.com>
References: <20080611184214.605110868@redhat.com>
	 <20080611184339.159161465@redhat.com> <4851C1CC.7070607@ct.jp.nec.com>
	 <20080613134827.5dbac5ac@cuia.bos.redhat.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 13 Jun 2008 16:21:47 -0400
Message-Id: <1213388507.9670.35.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PATCH collect lru meminfo statistics from correct offset

Against:  2.6.26-rc5-mm3

Incremental fix to: vmscan-split-lru-lists-into-anon-file-sets.patch 

Offset 'lru' by 'NR_LRU_BASE' to obtain global page state for
lru list 'lru'.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 fs/proc/proc_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.26-rc5-mm3/fs/proc/proc_misc.c
===================================================================
--- linux-2.6.26-rc5-mm3.orig/fs/proc/proc_misc.c	2008-06-13 15:16:17.000000000 -0400
+++ linux-2.6.26-rc5-mm3/fs/proc/proc_misc.c	2008-06-13 15:44:24.000000000 -0400
@@ -158,7 +158,7 @@ static int meminfo_read_proc(char *page,
 	get_vmalloc_info(&vmi);
 
 	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
-		pages[lru] = global_page_state(lru);
+		pages[lru] = global_page_state(NR_LRU_BASE + lru);
 
 	/*
 	 * Tagged format, for easy grepping and expansion.


