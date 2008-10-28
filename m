Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbYJ1Tlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbYJ1Tlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYJ1Tlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:41:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64311 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYJ1Tlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:41:39 -0400
Date: Tue, 28 Oct 2008 12:40:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Uwe.Kleine-Koenig@digi.com
Subject: [PATCH] kernel.h: fix might_sleep kernel-doc
Message-Id: <20081028124031.7480cd32.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Put the kernel-doc for might_sleep() _immediately_ before the macro
(no intervening lines).  Otherwise kernel-doc complains like so:

Warning(linux-2.6.27-rc3-git2//include/linux/kernel.h:129): No description found for parameter 'file'
Warning(linux-2.6.27-rc3-git2//include/linux/kernel.h:129): No description found for parameter 'line'

because kernel-doc is looking at the wrong function prototype
(i.e., __might_sleep).  [Yes, I have a todo note to myself to
check/warn for that inconsistency in scripts/kernel-doc.]

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Uwe Kleine-K_nig <Uwe.Kleine-Koenig@digi.com>
---
 include/linux/kernel.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.28-rc2-git2.orig/include/linux/kernel.h
+++ linux-2.6.28-rc2-git2/include/linux/kernel.h
@@ -116,6 +116,8 @@ extern int _cond_resched(void);
 # define might_resched() do { } while (0)
 #endif
 
+#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
+  void __might_sleep(char *file, int line);
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -126,8 +128,6 @@ extern int _cond_resched(void);
  * be bitten later when the calling function happens to sleep when it is not
  * supposed to.
  */
-#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-  void __might_sleep(char *file, int line);
 # define might_sleep() \
 	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
 #else
