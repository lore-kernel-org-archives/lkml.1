Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbYHQWun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbYHQWun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 18:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYHQWug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 18:50:36 -0400
Received: from xenotime.net ([66.160.160.81]:60723 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752062AbYHQWug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 18:50:36 -0400
Date: Sun, 17 Aug 2008 15:50:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Subject: [PATCH] kernel.h: fix kernel-doc for might_sleep
Message-Id: <20080817155058.022baa96.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

--- linux-2.6.27-rc3-git4.orig/include/linux/kernel.h
+++ linux-2.6.27-rc3-git4/include/linux/kernel.h
@@ -115,6 +115,8 @@ extern int _cond_resched(void);
 # define might_resched() do { } while (0)
 #endif
 
+#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
+  void __might_sleep(char *file, int line);
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -125,8 +127,6 @@ extern int _cond_resched(void);
  * be bitten later when the calling function happens to sleep when it is not
  * supposed to.
  */
-#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-  void __might_sleep(char *file, int line);
 # define might_sleep() \
 	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
 #else


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
