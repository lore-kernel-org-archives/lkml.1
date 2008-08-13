Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbYHMSmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbYHMSmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYHMSmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:42:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:62295 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYHMSmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:42:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,202,1217833200"; 
   d="scan'208";a="606510936"
Message-Id: <20080813183856.964126000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 13 Aug 2008 11:38:13 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/3] x86, xsave: remove the redundant access_ok() in setup_rt_frame()
Content-Disposition: inline; filename=remove_redundant_access_ok.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

save_i387_xstate() is already doing the required access_ok(). Remove
the redundant access_ok() before it.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/kernel/signal_64.c
===================================================================
--- tip.orig/arch/x86/kernel/signal_64.c	2008-08-11 15:26:47.000000000 -0700
+++ tip/arch/x86/kernel/signal_64.c	2008-08-11 15:28:52.000000000 -0700
@@ -208,9 +208,6 @@
 		frame = (void __user *)round_down(
 			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
 
-		if (!access_ok(VERIFY_WRITE, fp, sizeof(struct _fpstate)))
-			goto give_sigsegv;
-
 		if (save_i387_xstate(fp) < 0)
 			err |= -1;
 	} else

-- 

