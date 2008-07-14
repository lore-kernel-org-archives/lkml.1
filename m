Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYGNL0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYGNL0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 07:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYGNL03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 07:26:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51904 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYGNL02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 07:26:28 -0400
Date: Mon, 14 Jul 2008 20:25:13 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Tom Zanussi <tzanussi@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [mmotm] init_call_single_data makes int
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080714202311.F6E2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch title: full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix-fix.patch
Against: mmotm Jul 14
Applies after: full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch


Now, init_call_single_data is early init function.
then, its return type should be int.

   kernel/smp.c:47: warning: initialization from incompatible pointer type


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>

---
 kernel/smp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/kernel/smp.c
===================================================================
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -33,7 +33,7 @@ struct call_single_queue {
 	spinlock_t lock;
 };
 
-static void __cpuinit init_call_single_data(void)
+static int __cpuinit init_call_single_data(void)
 {
 	int i;
 
@@ -43,6 +43,7 @@ static void __cpuinit init_call_single_d
 		spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->list);
 	}
+	return 0;
 }
 early_initcall(init_call_single_data);
 


