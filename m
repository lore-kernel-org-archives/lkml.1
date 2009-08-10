Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbZHJIQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbZHJIQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZHJIQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:16:13 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:42432 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZHJIQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:16:12 -0400
Date: Mon, 10 Aug 2009 10:15:08 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Horst Hartmann <horsth@linux.vnet.ibm.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [Patch/RFC 2/4] spinlock: move include statements
Message-ID: <20090810081508.GB31234@osiris.boeblingen.de.ibm.com>
References: <20090810081324.GA30276@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810081324.GA30276@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Move include statements in order to avoid forward
declarations if the spinlock code gets inlined.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/spinlock.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/spinlock.h
===================================================================
--- linux-2.6.orig/include/linux/spinlock.h
+++ linux-2.6/include/linux/spinlock.h
@@ -143,15 +143,6 @@ static inline void smp_mb__after_lock(vo
  */
 #define spin_unlock_wait(lock)	__raw_spin_unlock_wait(&(lock)->raw_lock)
 
-/*
- * Pull the _spin_*()/_read_*()/_write_*() functions/declarations:
- */
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-# include <linux/spinlock_api_smp.h>
-#else
-# include <linux/spinlock_api_up.h>
-#endif
-
 #ifdef CONFIG_DEBUG_SPINLOCK
  extern void _raw_spin_lock(spinlock_t *lock);
 #define _raw_spin_lock_flags(lock, flags) _raw_spin_lock(lock)
@@ -380,4 +371,13 @@ extern int _atomic_dec_and_lock(atomic_t
  */
 #define spin_can_lock(lock)	(!spin_is_locked(lock))
 
+/*
+ * Pull the _spin_*()/_read_*()/_write_*() functions/declarations:
+ */
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+# include <linux/spinlock_api_smp.h>
+#else
+# include <linux/spinlock_api_up.h>
+#endif
+
 #endif /* __LINUX_SPINLOCK_H */
