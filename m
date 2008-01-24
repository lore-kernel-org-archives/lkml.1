Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYAXJOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYAXJOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 04:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYAXJOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 04:14:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58424 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbYAXJOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 04:14:18 -0500
Message-ID: <479856CC.7070404@cn.fujitsu.com>
Date: Thu, 24 Jan 2008 17:13:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] workqueue: make delayed_work_timer_fn() static
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


delayed_work_timer_fn() is a timer function, make it static.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 include/linux/timer.h |    2 --
 kernel/workqueue.c    |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 78cf899..090fa5e 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -124,8 +124,6 @@ static inline void timer_stats_timer_clear_start_info(struct timer_list *timer)
 }
 #endif
 
-extern void delayed_work_timer_fn(unsigned long __data);
-
 /**
  * add_timer - start a timer
  * @timer: the timer to be added
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 52d5e7c..4d4715b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -176,7 +176,7 @@ int fastcall queue_work(struct workqueue_struct *wq, struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(queue_work);
 
-void delayed_work_timer_fn(unsigned long __data)
+static void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
-- 1.5.4.rc3 

