Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbZKWVaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbZKWVaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbZKWVaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:30:10 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:45850 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbZKWVaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:30:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cZn7Zn/ZfxSCoJms5RxMc9diVlKX8n6DfEPmlZcTNunjeNVGrYfqGKLW/zZN6BOI13
         jntUw7pRcyrbrFlWHMgNqKCBr1zxjNUyNLb0JghJyBZmV2DRe3jdLD6bh2hlht+9vLcK
         Ws5zbiIsDVrD//2Pz8ZB8f+xFGOBt6nrk0bhs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Kisskb-bot by Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] hw-breakpoints: Fix misordered ifdef
Date: Mon, 23 Nov 2009 22:30:12 +0100
Message-Id: <1259011812-8093-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a misplaced ifdef. We need the perf event headers also in off-case
to avoid the following build error:

include/linux/hw_breakpoint.h:94: error: expected declaration specifiers or '...' before 'perf_callback_t'
include/linux/hw_breakpoint.h:102: error: expected declaration specifiers or '...' before 'perf_callback_t'
include/linux/hw_breakpoint.h:109: error: expected declaration specifiers or '...' before 'perf_callback_t'
include/linux/hw_breakpoint.h:116: error: expected declaration specifiers or '...' before 'perf_callback_t'

Reported-by: Kisskb-bot by Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 include/linux/hw_breakpoint.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 76a48ab..c9f7f7c 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -15,10 +15,11 @@ enum {
 };
 
 #ifdef __KERNEL__
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
 
 #include <linux/perf_event.h>
 
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+
 static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
 {
 	return bp->attr.bp_addr;
-- 
1.6.2.3

