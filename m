Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYA0CXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYA0CXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbYA0CS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:18:26 -0500
Received: from ns.suse.de ([195.135.220.2]:54345 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbYA0CRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:12 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: sct@redhat.com, adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [5/18] BKL-removal: Remove incorrect comment refering to lock_kernel() from jbd/jbd2
Message-Id: <20080127021711.72CFA14D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


None of the callers of this function does actually take the BKL
as far as I can see. So remove the comment refering to the BKL.

Cc: sct@redhat.com
Cc: adilger@clusterfs.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/jbd/recovery.c  |    2 +-
 fs/jbd2/recovery.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/fs/jbd/recovery.c
===================================================================
--- linux.orig/fs/jbd/recovery.c
+++ linux/fs/jbd/recovery.c
@@ -354,7 +354,7 @@ static int do_one_pass(journal_t *journa
 		struct buffer_head *	obh;
 		struct buffer_head *	nbh;
 
-		cond_resched();		/* We're under lock_kernel() */
+		cond_resched();
 
 		/* If we already know where to stop the log traversal,
 		 * check right now that we haven't gone past the end of
Index: linux/fs/jbd2/recovery.c
===================================================================
--- linux.orig/fs/jbd2/recovery.c
+++ linux/fs/jbd2/recovery.c
@@ -364,7 +364,7 @@ static int do_one_pass(journal_t *journa
 		struct buffer_head *	obh;
 		struct buffer_head *	nbh;
 
-		cond_resched();		/* We're under lock_kernel() */
+		cond_resched();
 
 		/* If we already know where to stop the log traversal,
 		 * check right now that we haven't gone past the end of
