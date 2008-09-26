Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYIZRhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYIZRhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 13:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYIZRg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 13:36:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:36079 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbYIZRg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 13:36:28 -0400
Message-Id: <20080926173313.526291890@twins.programming.kicks-ass.net>
User-Agent: quilt/0.47-1
Date: Fri, 26 Sep 2008 19:32:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 3/4] futex: use fast_gup()
References: <20080926173219.885155151@twins.programming.kicks-ass.net>
Content-Disposition: inline; filename=futex-fast_gup.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the get_user_pages() call with fast_gup() which doesn't require holding
the mmap_sem thereby removing the mmap_sem from all fast paths.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/futex.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -232,9 +232,7 @@ static int get_futex_key(u32 __user *uad
 	}
 
 again:
-	down_read(&mm->mmap_sem);
-	err = get_user_pages(current, mm, address, 1, 0, 0, &page, NULL);
-	up_read(&mm->mmap_sem);
+	err = get_user_pages_fast(address, 1, 0, &page);
 	if (err < 0)
 		return err;
 


