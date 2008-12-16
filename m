Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYLPII5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYLPII5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 03:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYLPIIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 03:08:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59745 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbYLPIIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 03:08:47 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-next <linux-next@vger.kernel.org>
Subject: [mmotm and linux-next][PATCH] irq: enclose irq_desc_lock_class in CONFIG_LOCKDEP
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081216170635.DBB8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 16 Dec 2008 17:08:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Applied after: linux-next.patch

==
Subject: [mmotm][PATCH] irq: enclose irq_desc_lock_class in CONFIG_LOCKDEP

commit 08678b0841267c1d00d771fe01548d86043d065e introduced
irq_desc_lock_class variable.
But it is used only if CONFIG_LOCKDEP=Y.
otherwise, following warnings happend.

	  CC      kernel/irq/handle.o
	kernel/irq/handle.c:26: warning: 'irq_desc_lock_class' defined but not used


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/handle.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/kernel/irq/handle.c
===================================================================
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -20,10 +20,12 @@
 
 #include "internals.h"
 
+#ifdef CONFIG_LOCKDEP
 /*
  * lockdep: we want to handle all irq_desc locks as a single lock-class:
  */
 static struct lock_class_key irq_desc_lock_class;
+#endif
 
 /**
  * handle_bad_irq - handle spurious and unhandled irqs


