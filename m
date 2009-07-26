Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbZGZITm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbZGZITm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZGZITk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:19:40 -0400
Received: from www.tglx.de ([62.245.132.106]:57919 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbZGZITe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:19:34 -0400
Message-Id: <20090726081554.946759738@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:18:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [Patch RFC 13/37] s390: cio/crw: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=driver-s390-cio-crw-sema-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completion in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 drivers/s390/cio/crw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/s390/cio/crw.c
===================================================================
--- linux-2.6-tip.orig/drivers/s390/cio/crw.c
+++ linux-2.6-tip/drivers/s390/cio/crw.c
@@ -137,7 +137,7 @@ void crw_handle_channel_report(void)
  */
 static int __init crw_init_semaphore(void)
 {
-	init_MUTEX_LOCKED(&crw_semaphore);
+	semaphore_init_locked(&crw_semaphore);
 	return 0;
 }
 pure_initcall(crw_init_semaphore);


