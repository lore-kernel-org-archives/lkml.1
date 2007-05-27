Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbXE0LAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbXE0LAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 07:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbXE0LAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 07:00:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53011 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbXE0LAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 07:00:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/3] Freezer: Use __set_current_state in refrigerator
Date: Sun, 27 May 2007 13:01:41 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
References: <200705271300.18443.rjw@sisk.pl>
In-Reply-To: <200705271300.18443.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705271301.42044.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use __set_current_state() as appropriate in refrigerator() instead of accessing
current->state directly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc2/kernel/power/process.c
===================================================================
--- linux-2.6.22-rc2.orig/kernel/power/process.c
+++ linux-2.6.22-rc2/kernel/power/process.c
@@ -72,7 +72,7 @@ void refrigerator(void)
 		schedule();
 	}
 	pr_debug("%s left refrigerator\n", current->comm);
-	current->state = save;
+	__set_current_state(save);
 }
 
 static void freeze_task(struct task_struct *p)

