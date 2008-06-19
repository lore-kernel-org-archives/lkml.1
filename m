Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYFSJQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYFSJQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYFSJPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:15:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44123 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbYFSJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:15:50 -0400
Date: Thu, 19 Jun 2008 18:15:40 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [-mm][PATCH 3/5] collect lru meminfo statistics from correct offset
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080619172241.E7FC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080619172241.E7FC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080619181406.E808.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Schermerhorn <lee.schermerhorn@hp.com>

PATCH collect lru meminfo statistics from correct offset

Against:  2.6.26-rc5-mm3

Offset 'lru' by 'NR_LRU_BASE' to obtain global page state for
lru list 'lru'.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

 fs/proc/proc_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/fs/proc/proc_misc.c
===================================================================
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -158,7 +158,7 @@ static int meminfo_read_proc(char *page,
 	get_vmalloc_info(&vmi);
 
 	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
-		pages[lru] = global_page_state(lru);
+		pages[lru] = global_page_state(NR_LRU_BASE + lru);
 
 	/*
 	 * Tagged format, for easy grepping and expansion.


