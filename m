Return-Path: <linux-kernel-owner+w=401wt.eu-S1762771AbYD3LbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762771AbYD3LbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757855AbYD3LbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:31:08 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47681 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757844AbYD3LbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:31:07 -0400
Date: Wed, 30 Apr 2008 12:31:04 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: apw@shadowen.org, clameter@sgi.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix for memory initialisation debugging framework
Message-ID: <20080430113103.GA14888@csn.ul.ie>
References: <200804292126.m3TLQ6Dc010601@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200804292126.m3TLQ6Dc010601@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (29/04/08 14:26), akpm@linux-foundation.org didst pronounce:
> 
> The patch titled
>      mm: add a basic debugging framework for memory initialisation
> has been added to the -mm tree.  Its filename is
>      mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
> 

This patch is a fix to
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch pointed out
by an off-list reviewer. The intention of the code was to change the printk
loglevel depending on the message level passed to mminit_dprintk(). What
actually happens is that for MMINIT_WARNING and levels, only the loglevel
is sent to printk() and not the message. This patch fixes the code to behave
as intended.

It can be folded safely into
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch without
causing collisions later in the set.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/internal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.25-mm1-0010_mminit_debug_framework/mm/internal.h linux-2.6.25-mm1-0015_fix_mminit_dprink/mm/internal.h
--- linux-2.6.25-mm1-0010_mminit_debug_framework/mm/internal.h	2008-04-30 09:47:55.000000000 +0100
+++ linux-2.6.25-mm1-0015_fix_mminit_dprink/mm/internal.h	2008-04-30 11:33:41.000000000 +0100
@@ -73,8 +73,8 @@ extern int mminit_loglevel;
 #define mminit_dprintk(level, prefix, fmt, arg...) \
 do { \
 	if (level < mminit_loglevel) { \
-		printk(level <= MMINIT_WARNING ? KERN_WARNING : KERN_DEBUG \
-			"mminit:: " prefix " " fmt, ##arg); \
+		printk(level <= MMINIT_WARNING ? KERN_WARNING : KERN_DEBUG); \
+		printk(KERN_CONT "mminit::" prefix " " fmt, ##arg); \
 	} \
 } while (0)
 

