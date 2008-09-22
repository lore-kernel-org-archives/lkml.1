Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbYIVEev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbYIVEev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 00:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbYIVEen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 00:34:43 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56672 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYIVEem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 00:34:42 -0400
From: Krishna Kumar <krkumar2@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Krishna Kumar <krkumar2@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 Sep 2008 10:04:38 +0530
Message-Id: <20080922043438.21118.93359.sendpatchset@localhost.localdomain>
In-Reply-To: <20080922043425.21118.24172.sendpatchset@localhost.localdomain>
References: <20080922043425.21118.24172.sendpatchset@localhost.localdomain>
Subject: [RFC] [PATCH 1/1]: timers: Change add_timer to use add_timer_on
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Kumar <krkumar2@in.ibm.com>

timer: Change add_timer to not check for existing timer.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---

 include/linux/timer.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -ruNp 2.6.27-rc7-org/include/linux/timer.h 2.6.27-rc7-new/include/linux/timer.h
--- 2.6.27-rc7-org/include/linux/timer.h	2008-09-17 17:40:36.000000000 +0530
+++ 2.6.27-rc7-new/include/linux/timer.h	2008-09-17 17:41:50.000000000 +0530
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <linux/ktime.h>
 #include <linux/stddef.h>
+#include <linux/smp.h>
 #include <linux/debugobjects.h>
 
 struct tvec_base;
@@ -162,8 +163,7 @@ static inline void timer_stats_timer_cle
  */
 static inline void add_timer(struct timer_list *timer)
 {
-	BUG_ON(timer_pending(timer));
-	__mod_timer(timer, timer->expires);
+	add_timer_on(timer, raw_smp_processor_id());
 }
 
 #ifdef CONFIG_SMP
