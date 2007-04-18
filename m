Return-Path: <linux-kernel-owner+w=401wt.eu-S1161425AbXDRBlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161425AbXDRBlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 21:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161427AbXDRBlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 21:41:20 -0400
Received: from ozlabs.org ([203.10.76.45]:41761 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161425AbXDRBlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 21:41:19 -0400
To: Andrew Morton <akpm@osdl.org>
From: Michael Ellerman <michael@ellerman.id.au>
Date: Wed, 18 Apr 2007 11:40:55 +1000
Subject: [PATCH] Document SPIN_LOCK_UNLOCKED/RW_LOCK_UNLOCKED deprecation
CC: <linux-kernel@vger.kernel.org>, <gud@eth.net>, <mingo@elte.hu>,
       <arjan@linux.intel.com>, <milindchoudhary@gmail.com>
Message-Id: <20070418014118.3F073DDE9F@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently it's not cool anymore to use SPIN/RW_LOCK_UNLOCKED.
There's some mention of this in Documentation/spinlocks.txt, but that
only talks about dynamic initialisation.

A comment in the code mentioning the preferred usage would be good IMHO.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---

 include/linux/spinlock_types.h |    5 +++++
 1 file changed, 5 insertions(+)

Index: powerpc/include/linux/spinlock_types.h
===================================================================
--- powerpc.orig/include/linux/spinlock_types.h
+++ powerpc/include/linux/spinlock_types.h
@@ -85,6 +85,11 @@ typedef struct {
 				RW_DEP_MAP_INIT(lockname) }
 #endif
 
+/*
+ * SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED are deprecated.
+ * Please use DEFINE_SPINLOCK()/DEFINE_RWLOCK() or
+ * __SPIN_LOCK_UNLOCKED()/__RW_LOCK_UNLOCKED() as appropriate.
+ */
 #define SPIN_LOCK_UNLOCKED	__SPIN_LOCK_UNLOCKED(old_style_spin_init)
 #define RW_LOCK_UNLOCKED	__RW_LOCK_UNLOCKED(old_style_rw_init)
 
