Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYACPpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYACPpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbYACPm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:42:26 -0500
Received: from mail.suse.de ([195.135.220.2]:48624 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbYACPmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:42:23 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103442.621670000@suse.de>
In-Reply-To: <20080103442.621670000@suse.de>
To: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86] [8/16] Make lockdep_init __init
Message-Id: <20080103154222.2C75314DDB@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:42:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: peterz@infradead.org
Signed-off-by: Andi Kleen <ak@suse.de>

---
 kernel/lockdep.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/kernel/lockdep.c
===================================================================
--- linux.orig/kernel/lockdep.c
+++ linux/kernel/lockdep.c
@@ -3023,7 +3023,7 @@ out_restore:
 #define LARGEVAR(x,y) x = arch_early_alloc(sizeof(*x) * y)
 #endif
 
-void lockdep_init_mem(void)
+void __init lockdep_init_mem(void)
 {
 	LARGEVAR(stack_trace, MAX_STACK_TRACE_ENTRIES);
 	LARGEVAR(list_entries, MAX_LOCKDEP_ENTRIES);
@@ -3031,7 +3031,8 @@ void lockdep_init_mem(void)
 	LARGEVAR(lock_classes, MAX_LOCKDEP_KEYS);
 	LARGEVAR(chainhash_table, CHAINHASH_SIZE);
 }
-void lockdep_init(void)
+
+void __init lockdep_init(void)
 {
 	int i;
 
