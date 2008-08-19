Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYHSNru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYHSNru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbYHSNrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:47:17 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60771 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849AbYHSNrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:47:16 -0400
Date: Tue, 19 Aug 2008 16:47:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Srinivasa DS <srinivasa@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       mhiramat@redhat.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make kprobes.c:kretprobe_table_lock() static
Message-ID: <20080819134706.GF8852@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global kretprobe_table_lock() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
7282c07a74451fca15cad3b8b1626e0b9ec0ba17 
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 75bc2cd..8b57a25 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -404,7 +404,7 @@ void kretprobe_hash_lock(struct task_struct *tsk,
 	spin_lock_irqsave(hlist_lock, *flags);
 }
 
-void kretprobe_table_lock(unsigned long hash, unsigned long *flags)
+static void kretprobe_table_lock(unsigned long hash, unsigned long *flags)
 {
 	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	spin_lock_irqsave(hlist_lock, *flags);

