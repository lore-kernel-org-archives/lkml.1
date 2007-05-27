Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbXE0LBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbXE0LBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 07:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbXE0LAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 07:00:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53017 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbXE0LAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 07:00:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 3/3] Freezer: Remove redundant check in try_to_freeze_tasks
Date: Sun, 27 May 2007 13:04:47 +0200
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
Message-Id: <200705271304.48177.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

We don't need to check if todo is positive before calling time_after() in
try_to_freeze_tasks(), because if todo is zero at this point, the loop will
be broken anyway due to the while () condition being false.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc2/kernel/power/process.c
===================================================================
--- linux-2.6.22-rc2.orig/kernel/power/process.c
+++ linux-2.6.22-rc2/kernel/power/process.c
@@ -149,7 +149,7 @@ static int try_to_freeze_tasks(int freez
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 		yield();			/* Yield is okay here */
-		if (todo && time_after(jiffies, end_time))
+		if (time_after(jiffies, end_time))
 			break;
 	} while (todo);
 
