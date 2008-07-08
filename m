Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbYGHRDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbYGHRDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbYGHQ62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:58:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:38014 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775AbYGHQ61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:58:27 -0400
Date: Tue, 8 Jul 2008 09:54:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 15/17] Use WARN() in fs/
Message-ID: <20080708095449.2670a23d@infradead.org>
In-Reply-To: <20080708093800.274504ba@infradead.org>
References: <20080708093800.274504ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Use WARN instead of printk+WARN_ON in fs/

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/buffer.c    |    3 +--
 fs/namespace.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

Index: linux.trees.git/fs/buffer.c
===================================================================
--- linux.trees.git.orig/fs/buffer.c
+++ linux.trees.git/fs/buffer.c
@@ -1214,8 +1214,7 @@ void __brelse(struct buffer_head * buf)
 		put_bh(buf);
 		return;
 	}
-	printk(KERN_ERR "VFS: brelse: Trying to free free buffer\n");
-	WARN_ON(1);
+	WARN(1, KERN_ERR "VFS: brelse: Trying to free free buffer\n");
 }
 
 /*
Index: linux.trees.git/fs/namespace.c
===================================================================
--- linux.trees.git.orig/fs/namespace.c
+++ linux.trees.git/fs/namespace.c
@@ -309,10 +309,9 @@ static void handle_write_count_underflow
 	 */
 	if ((atomic_read(&mnt->__mnt_writers) < 0) &&
 	    !(mnt->mnt_flags & MNT_IMBALANCED_WRITE_COUNT)) {
-		printk(KERN_DEBUG "leak detected on mount(%p) writers "
+		WARN(1, KERN_DEBUG "leak detected on mount(%p) writers "
 				"count: %d\n",
 			mnt, atomic_read(&mnt->__mnt_writers));
-		WARN_ON(1);
 		/* use the flag to keep the dmesg spam down */
 		mnt->mnt_flags |= MNT_IMBALANCED_WRITE_COUNT;
 	}
