Return-Path: <linux-kernel-owner+w=401wt.eu-S1762617AbXJMTLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762617AbXJMTLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 15:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762680AbXJMTLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 15:11:11 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53662 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762617AbXJMTLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 15:11:10 -0400
Date: Sat, 13 Oct 2007 15:11:10 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, shaggy@linux.vnet.ibm.com
Subject: [PATCH] JFS: Bio cleanup: Replace missing return statements
Message-ID: <20071013191110.GA20203@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

commit 6712ecf8f648118c3363c142196418f89a510b90 removed some "return 0;"
statements, rather than changing them to null returns.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
Dave sent this under a different cover, but just in case it was missed
in the middle of the thread, I wanted to make sure it was not missed.

 fs/jfs/jfs_logmgr.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index ccfd029..15a3974 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2234,6 +2234,8 @@ static void lbmIODone(struct bio *bio, int error)
 
 		/* wakeup I/O initiator */
 		LCACHE_WAKEUP(&bp->l_ioevent);
+
+		return;
 	}
 
 	/*
@@ -2258,6 +2260,7 @@ static void lbmIODone(struct bio *bio, int error)
 	if (bp->l_flag & lbmDIRECT) {
 		LCACHE_WAKEUP(&bp->l_ioevent);
 		LCACHE_UNLOCK(flags);
+		return;
 	}
 
 	tail = log->wqueue;

