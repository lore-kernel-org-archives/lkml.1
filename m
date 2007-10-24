Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbXJXJFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbXJXJFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXJXJEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:04:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:50696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbXJXJEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:04:54 -0400
Message-Id: <20071024081405.202232000@nick.local0.net>
References: <20071024081305.906617000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 24 Oct 2007 18:13:07 +1000
From: npiggin@nick.local0.net
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 2/5] tasklet: use lock bitops for tasklet lock
Content-Disposition: inline; filename=tasklet_lock-use-lock-bitops.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
 include/linux/interrupt.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -321,13 +321,12 @@ enum
 #ifdef CONFIG_SMP
 static inline int tasklet_trylock(struct tasklet_struct *t)
 {
-	return !test_and_set_bit(TASKLET_STATE_RUN, &(t)->state);
+	return !test_and_set_bit_lock(TASKLET_STATE_RUN, &(t)->state);
 }
 
 static inline void tasklet_unlock(struct tasklet_struct *t)
 {
-	smp_mb__before_clear_bit(); 
-	clear_bit(TASKLET_STATE_RUN, &(t)->state);
+	clear_bit_unlock(TASKLET_STATE_RUN, &(t)->state);
 }
 
 static inline void tasklet_unlock_wait(struct tasklet_struct *t)

-- 

