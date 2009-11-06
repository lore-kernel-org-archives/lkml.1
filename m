Return-Path: <linux-kernel-owner+w=401wt.eu-S933299AbZKFWnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbZKFWnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932387AbZKFWmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:42:24 -0500
Received: from www.tglx.de ([62.245.132.106]:54099 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241AbZKFWmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:42:22 -0500
Message-Id: <20091106223806.852003848@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 06 Nov 2009 22:41:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org
Subject: [patch 11/16] alpha: Replace old style lock initializer
References: <20091106223547.784916750@linutronix.de>
Content-Disposition: inline; filename=alpha-replace-old-style-lock-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED is deprecated. Use __SPIN_LOCK_UNLOCKED instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/include/asm/rwsem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/alpha/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/rwsem.h
+++ linux-2.6/arch/alpha/include/asm/rwsem.h
@@ -39,7 +39,7 @@ struct rw_semaphore {
 };
 
 #define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
+	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock),	\
 	LIST_HEAD_INIT((name).wait_list) }
 
 #define DECLARE_RWSEM(name) \


