Return-Path: <linux-kernel-owner+w=401wt.eu-S965605AbXGSRRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965605AbXGSRRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939075AbXGSRRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:17:34 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:33025 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938307AbXGSRRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:17:33 -0400
Subject: [PATCH] ia64: fix build failure on fs/quota.c
From: Doug Chapman <doug.chapman@hp.com>
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       vtaras@openvz.org
Content-Type: text/plain
Date: Thu, 19 Jul 2007 13:15:29 -0400
Message-Id: <1184865329.3825.25.camel@dchapman.boston.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-35.el4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix ia64 build failure on fs/qutoa.c.  A recent patch used the
type compat_u64 which on ia64 is only available if CONFIG_COMPAT
is defined.


From: Tony Luck <tony.luck@intel.com>
Signed-off-by: Doug Chapman <doug.chapman@hp.com>

--

--- a/fs/quota.c
+++ b/fs/quota.c
@@ -387,7 +387,7 @@ asmlinkage long sys_quotactl(unsigned int cmd, const char __user *special, qid_t
        return ret;
 }
 
-#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
+#if defined(CONFIG_X86_64) || (defined(CONFIG_IA64) && defined(CONFIG_COMPAT))
 /*
  * This code works only for 32 bit quota tools over 64 bit OS (x86_64, ia64)
  * and is necessary due to alignment problems.



