Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbZDSRdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbZDSRdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 13:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZDSRdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 13:33:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41069 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZDSRdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 13:33:45 -0400
Date: Sun, 19 Apr 2009 19:33:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Don't print lockdep taint message for !LOCKDEP
Message-ID: <20090419173342.GA18041@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't print lockdep taint message for !LOCKDEP

I was surprised to see a 

Disabling lockdep due to kernel taint

message in my lockdep disabled kernel. This patch ifdefs this message
to not be printed when lockdep is not enabled.

BTW in my case it was due to a thermal event. I'm not sure it's really
needed to disable lockdep on thermal events, but I left this alone for
now.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/panic.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.30-rc2-ak/kernel/panic.c
===================================================================
--- linux-2.6.30-rc2-ak.orig/kernel/panic.c	2009-04-15 11:14:36.000000000 +0200
+++ linux-2.6.30-rc2-ak/kernel/panic.c	2009-04-19 19:29:07.000000000 +0200
@@ -213,6 +213,7 @@
 
 void add_taint(unsigned flag)
 {
+#ifdef CONFIG_LOCKDEP
 	/*
 	 * Can't trust the integrity of the kernel anymore.
 	 * We don't call directly debug_locks_off() because the issue
@@ -222,6 +223,7 @@
 	 */
 	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
 		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
+#endif
 
 	set_bit(flag, &tainted_mask);
 }
