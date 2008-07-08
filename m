Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbYGHRBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbYGHRBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbYGHQ6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:58:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:55161 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbYGHQ6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:58:05 -0400
Date: Tue, 8 Jul 2008 09:52:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 12/17]  Use WARN() in block/
Message-ID: <20080708095228.1fe60b44@infradead.org>
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
Subject: Use WARN instead of printk+WARN_ON in block 

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>---
 block/as-iosched.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux.trees.git/block/as-iosched.c
===================================================================
--- linux.trees.git.orig/block/as-iosched.c
+++ linux.trees.git/block/as-iosched.c
@@ -837,8 +837,7 @@ static void as_completed_request(struct 
 	WARN_ON(!list_empty(&rq->queuelist));
 
 	if (RQ_STATE(rq) != AS_RQ_REMOVED) {
-		printk("rq->state %d\n", RQ_STATE(rq));
-		WARN_ON(1);
+		WARN(1, "rq->state %d\n", RQ_STATE(rq));
 		goto out;
 	}
 
