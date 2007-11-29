Return-Path: <linux-kernel-owner+w=401wt.eu-S1760263AbXK2Hic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263AbXK2Hic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 02:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbXK2Hhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 02:37:46 -0500
Received: from [222.73.24.84] ([222.73.24.84]:54043 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbXK2Hhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:37:45 -0500
Message-ID: <474E6BB4.7010501@cn.fujitsu.com>
Date: Thu, 29 Nov 2007 15:35:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: [PATCH 2/6] clockevent: simplify list operations
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


list_for_each_safe() suffices here.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 kernel/time/clockevents.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 822beeb..68fbe73 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -200,6 +200,8 @@ void clockevents_exchange_device(struct clock_event_device *old,
  */
 void clockevents_notify(unsigned long reason, void *arg)
 {
+	struct list_head *node, *tmp;
+
 	spin_lock(&clockevents_lock);
 	clockevents_do_notify(reason, arg);
 
@@ -209,13 +211,8 @@ void clockevents_notify(unsigned long reason, void *arg)
 		 * Unregister the clock event devices which were
 		 * released from the users in the notify chain.
 		 */
-		while (!list_empty(&clockevents_released)) {
-			struct clock_event_device *dev;
-
-			dev = list_entry(clockevents_released.next,
-					 struct clock_event_device, list);
-			list_del(&dev->list);
-		}
+		list_for_each_safe(node, tmp, &clockevents_released)
+			list_del(node);
 		break;
 	default:
 		break;
-- 
1.5.3.rc7

