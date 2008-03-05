Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYCEQEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYCEQEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758345AbYCEQEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:04:37 -0500
Received: from www.tglx.de ([62.245.132.106]:49791 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758291AbYCEQEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:04:36 -0500
Message-Id: <20080305155117.447021903@linutronix.de>
References: <20080305154829.185609547@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 05 Mar 2008 16:03:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 1/5] vmalloc: do not check for freed locks on user maps
Content-Disposition: inline; filename=no-check-freed-on-user-maps.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User maps do not contain kernel internal objects. No need to check
them.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c
+++ linux-2.6/mm/vmalloc.c
@@ -382,7 +382,8 @@ static void __vunmap(const void *addr, i
 		return;
 	}
 
-	debug_check_no_locks_freed(addr, area->size);
+	if (!(area->flags & VM_USERMAP))
+		debug_check_no_locks_freed(addr, area->size);
 
 	if (deallocate_pages) {
 		int i;

-- 

