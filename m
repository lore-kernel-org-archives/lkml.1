Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZLNMYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZLNMYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbZLNMYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:24:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44691 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbZLNMYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:24:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: [PATCH 2/8] Mark sleep_on as deprecated
Cc: kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
In-Reply-To: <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
Message-Id: <20091214212351.BBB4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 14 Dec 2009 21:24:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



sleep_on() function is SMP and/or kernel preemption unsafe. we shouldn't
use it on new code.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/wait.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index a48e16b..bf76627 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -427,11 +427,11 @@ static inline void remove_wait_queue_locked(wait_queue_head_t *q,
  * They are racy.  DO NOT use them, use the wait_event* interfaces above.
  * We plan to remove these interfaces.
  */
-extern void sleep_on(wait_queue_head_t *q);
-extern long sleep_on_timeout(wait_queue_head_t *q,
+extern void __deprecated sleep_on(wait_queue_head_t *q);
+extern long __deprecated sleep_on_timeout(wait_queue_head_t *q,
 				      signed long timeout);
-extern void interruptible_sleep_on(wait_queue_head_t *q);
-extern long interruptible_sleep_on_timeout(wait_queue_head_t *q,
+extern void __deprecated interruptible_sleep_on(wait_queue_head_t *q);
+extern long __deprecated interruptible_sleep_on_timeout(wait_queue_head_t *q,
 					   signed long timeout);
 
 /*
-- 
1.6.5.2



