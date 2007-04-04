Return-Path: <linux-kernel-owner+w=401wt.eu-S966245AbXDDBfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966245AbXDDBfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966247AbXDDBfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:35:12 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51375 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966245AbXDDBfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:35:08 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 03 Apr 2007 18:35:06 -0700
Subject: [patch 2/3] epoll cleanups - epoll no module ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.19972.1175650506.2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Epoll is either compiled it, or not (if EMBEDDED). Remove the module code
and use fs_initcall().



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-rc5.mm4/fs/eventpoll.c
===================================================================
--- linux-2.6.21-rc5.mm4.orig/fs/eventpoll.c	2007-04-03 18:33:30.000000000 -0700
+++ linux-2.6.21-rc5.mm4/fs/eventpoll.c	2007-04-03 18:33:40.000000000 -0700
@@ -11,7 +11,6 @@
  *
  */
 
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -1462,16 +1461,5 @@
 
 	return 0;
 }
+fs_initcall(eventpoll_init);
 
-
-static void __exit eventpoll_exit(void)
-{
-	/* Undo all operations done inside eventpoll_init() */
-	kmem_cache_destroy(pwq_cache);
-	kmem_cache_destroy(epi_cache);
-}
-
-module_init(eventpoll_init);
-module_exit(eventpoll_exit);
-
-MODULE_LICENSE("GPL");

