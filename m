Return-Path: <linux-kernel-owner+w=401wt.eu-S1161262AbXBUPGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161262AbXBUPGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161250AbXBUPFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:05:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34536 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbXBUPFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:05:35 -0500
Message-Id: <20070221144843.989983000@taijtu.programming.kicks-ass.net>
References: <20070221144304.512721000@taijtu.programming.kicks-ass.net>
User-Agent: quilt/0.46-1
Date: Wed, 21 Feb 2007 15:43:29 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Subject: [PATCH 25/29] nfs: only use stable storage for swap
Content-Disposition: inline; filename=nfs-wb_priority.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

unstable writes don't make sense for swap pages.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
---
 fs/nfs/write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-git/fs/nfs/write.c
===================================================================
--- linux-2.6-git.orig/fs/nfs/write.c	2007-02-21 12:15:10.000000000 +0100
+++ linux-2.6-git/fs/nfs/write.c	2007-02-21 12:15:13.000000000 +0100
@@ -197,7 +197,7 @@ static int nfs_writepage_setup(struct nf
 static int wb_priority(struct writeback_control *wbc)
 {
 	if (wbc->for_reclaim)
-		return FLUSH_HIGHPRI;
+		return FLUSH_HIGHPRI|FLUSH_STABLE;
 	if (wbc->for_kupdate)
 		return FLUSH_LOWPRI;
 	return 0;

-- 

