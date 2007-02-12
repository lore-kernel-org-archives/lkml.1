Return-Path: <linux-kernel-owner+w=401wt.eu-S964909AbXBLNoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964909AbXBLNoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 08:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964914AbXBLNoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 08:44:46 -0500
Received: from poczta.o2.pl ([193.17.41.142]:41113 "EHLO poczta.o2.pl"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S964909AbXBLNoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 08:44:46 -0500
Date: Mon, 12 Feb 2007 14:47:53 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] lockdep: debug_locks check after check_chain_key
Message-ID: <20070212134753.GA7737@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In __lock_acquire check_chain_key can turn off
debug_locks, so check is needed to assure proper
return code.

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp linux-2.6.20-git7-/kernel/lockdep.c linux-2.6.20-git7/kernel/lockdep.c
--- linux-2.6.20-git7-/kernel/lockdep.c	2007-02-12 13:13:15.000000000 +0100
+++ linux-2.6.20-git7/kernel/lockdep.c	2007-02-12 14:18:31.000000000 +0100
@@ -2228,6 +2228,10 @@ out_calc_hash:
 
 	curr->lockdep_depth++;
 	check_chain_key(curr);
+#ifdef CONFIG_DEBUG_LOCKDEP
+	if (unlikely(!debug_locks))
+		return 0;
+#endif
 	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH)) {
 		debug_locks_off();
 		printk("BUG: MAX_LOCK_DEPTH too low!\n");
