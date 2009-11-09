Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbZKIP6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbZKIP6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbZKIP6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:58:31 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:31409 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756393AbZKIP63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:58:29 -0500
X-Trace: 287122278/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.15.142/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.15.142
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkYFAHLK90pPRQ+O/2dsb2JhbACBTo5rAc1mhD4EgWg
X-IronPort-AV: E=Sophos;i="4.44,708,1249254000"; 
   d="scan'208";a="287122278"
Date: Mon, 9 Nov 2009 15:58:23 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ksm: cond_resched in unstable tree
Message-ID: <Pine.LNX.4.64.0911091554500.25509@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KSM needs a cond_resched() for CONFIG_PREEMPT_NONE, in its unbounded
search of the unstable tree.  The stable tree cases already have one,
and originally there was one down inside get_user_pages();
but I missed it when I converted to follow_page() instead.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/ksm.c |    1 +
 1 file changed, 1 insertion(+)

--- 2.6.32-rc6/mm/ksm.c	2009-10-12 00:26:43.000000000 +0100
+++ linux/mm/ksm.c	2009-11-07 14:44:58.000000000 +0000
@@ -1012,6 +1012,7 @@ static struct rmap_item *unstable_tree_s
 		struct rmap_item *tree_rmap_item;
 		int ret;
 
+		cond_resched();
 		tree_rmap_item = rb_entry(*new, struct rmap_item, node);
 		page2[0] = get_mergeable_page(tree_rmap_item);
 		if (!page2[0])
