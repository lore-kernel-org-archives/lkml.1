Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZBKMdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZBKMdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZBKMdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:33:37 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37144 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbZBKMdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:33:37 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH 1/2] mm: don't mark_page_accessed() in do_swap_page()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090211213201.C3CA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 11 Feb 2009 21:33:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit bf3f3bc5e734706730c12a323f9b2068052aa1f0 (mm: don't mark_page_accessed
in fault path) only remove the mark_page_accessed() in filemap_fault().

Therefore, swap-backed page and file-backed page have inconsistency behavior now.
mark_page_accessed() should be removed from do_swap_page().


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
---
 mm/memory.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/mm/memory.c
===================================================================
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2440,8 +2440,6 @@ static int do_swap_page(struct mm_struct
 		count_vm_event(PGMAJFAULT);
 	}
 
-	mark_page_accessed(page);
-
 	lock_page(page);
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 


