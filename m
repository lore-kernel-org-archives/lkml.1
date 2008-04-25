Return-Path: <linux-kernel-owner+w=401wt.eu-S932774AbYDYUwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbYDYUwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759181AbYDYUwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:52:45 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:39641 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbYDYUwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:52:45 -0400
Date: Fri, 25 Apr 2008 16:52:40 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove a redundant conditional definition of list_add().
Message-ID: <alpine.LFD.1.10.0804251631460.31174@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the conditional surrounding the definition of list_add() from
list.h since, if you define CONFIG_DEBUG_LIST, the definition you will
subsequently pick up from lib/list_debug.c will be absolutely
identical, at which point you can remove that redundant definition
from list_debug.c as well.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---
  compile-tested on x86 with "make defconfig", both with and without
the list debug option.

 include/linux/list.h |    4 ----
 lib/list_debug.c     |   14 --------------
 2 files changed, 18 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index dac16f9..2febfe1 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -63,14 +63,10 @@ extern void __list_add(struct list_head *new,
  * Insert a new entry after the specified head.
  * This is good for implementing stacks.
  */
-#ifndef CONFIG_DEBUG_LIST
 static inline void list_add(struct list_head *new, struct list_head *head)
 {
 	__list_add(new, head, head->next);
 }
-#else
-extern void list_add(struct list_head *new, struct list_head *head);
-#endif


 /**
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 4350ba9..45c03fd 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -40,20 +40,6 @@ void __list_add(struct list_head *new,
 EXPORT_SYMBOL(__list_add);

 /**
- * list_add - add a new entry
- * @new: new entry to be added
- * @head: list head to add it after
- *
- * Insert a new entry after the specified head.
- * This is good for implementing stacks.
- */
-void list_add(struct list_head *new, struct list_head *head)
-{
-	__list_add(new, head, head->next);
-}
-EXPORT_SYMBOL(list_add);
-
-/**
  * list_del - deletes entry from list.
  * @entry: the element to delete from the list.
  * Note: list_empty on entry does not return true after this, the entry is

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
