Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYJGVJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYJGVJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbYJGVJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:09:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:10728 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbYJGVJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:09:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="56400116"
Message-Id: <20081007210549.314011000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Oct 2008 14:04:27 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/2] xsave: fix error condition in save_i387_xstate()
Content-Disposition: inline; filename=fix_save_i387_xstate_err.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/kernel/xsave.c
===================================================================
--- tip.orig/arch/x86/kernel/xsave.c	2008-10-02 10:30:55.000000000 -0700
+++ tip/arch/x86/kernel/xsave.c	2008-10-02 10:31:26.000000000 -0700
@@ -121,6 +121,8 @@
 		err |= __put_user(FP_XSTATE_MAGIC2,
 				  (__u32 __user *) (buf + sig_xstate_size
 						    - FP_XSTATE_MAGIC2_SIZE));
+		if (err)
+			return err;
 	}
 
 	return 1;

-- 

