Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbYHMSmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbYHMSmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYHMSmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:42:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:62295 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbYHMSmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:42:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,202,1217833200"; 
   d="scan'208";a="606510938"
Message-Id: <20080813183857.246823000@linux-os.sc.intel.com>
References: <20080813183856.964126000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 13 Aug 2008 11:38:15 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/3] x86, xsave: use BUG_ON() instead of BUILD_BUG_ON()
Content-Disposition: inline; filename=modify_build_bug_on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All these structure sizes are runtime determined. So use a runtime
bug check.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/kernel/xsave.c
===================================================================
--- tip.orig/arch/x86/kernel/xsave.c	2008-08-11 15:44:33.000000000 -0700
+++ tip/arch/x86/kernel/xsave.c	2008-08-11 15:45:09.000000000 -0700
@@ -82,8 +82,7 @@
 	if (!access_ok(VERIFY_WRITE, buf, sig_xstate_size))
 		return -EACCES;
 
-	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
-			sizeof(tsk->thread.xstate->fxsave));
+	BUG_ON(sig_xstate_size < xstate_size);
 
 	if ((unsigned long)buf % 64)
 		printk("save_i387_xstate: bad fpstate %p\n", buf);

-- 

