Return-Path: <linux-kernel-owner+w=401wt.eu-S1758484AbXEJRXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbXEJRXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 13:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbXEJRXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 13:23:43 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:39844 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755745AbXEJRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 13:23:43 -0400
Message-Id: <20070510172223.898755987@mvista.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 10:22:23 -0700
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] use defines in sys_getpriority/sys_setpriority
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to the defines for these two checks, instead of hard
coding the values.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 kernel/sys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.21/kernel/sys.c
===================================================================
--- linux-2.6.21.orig/kernel/sys.c
+++ linux-2.6.21/kernel/sys.c
@@ -598,7 +598,7 @@ asmlinkage long sys_setpriority(int whic
 	int error = -EINVAL;
 	struct pid *pgrp;
 
-	if (which > 2 || which < 0)
+	if (which > PRIO_USER || which < PRIO_PROCESS)
 		goto out;
 
 	/* normalize: avoid signed division (rounding problems) */
@@ -662,7 +662,7 @@ asmlinkage long sys_getpriority(int whic
 	long niceval, retval = -ESRCH;
 	struct pid *pgrp;
 
-	if (which > 2 || which < 0)
+	if (which > PRIO_USER || which < PRIO_PROCESS)
 		return -EINVAL;
 
 	read_lock(&tasklist_lock);
-- 

-- 
