Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbXFYUSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbXFYUSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbXFYUSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:18:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28540 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbXFYUSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:18:48 -0400
Date: Mon, 25 Jun 2007 13:20:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: davidel@xmailserver.org, akpm <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] eventfd: clean compile when CONFIG_EVENTFD=n
Message-Id: <20070625132046.95654351.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix gcc warning and add parameter checking when CONFIG_EVENTFD=n:

fs/aio.c: In function 'aio_complete':
fs/aio.c:955: warning: statement with no effect

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/eventfd.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.22-rc6.orig/include/linux/eventfd.h
+++ linux-2.6.22-rc6/include/linux/eventfd.h
@@ -19,7 +19,8 @@ int eventfd_signal(struct file *file, in
 #else /* CONFIG_EVENTFD */
 
 #define eventfd_fget(fd) ERR_PTR(-ENOSYS)
-#define eventfd_signal(f, n) 0
+static inline int eventfd_signal(struct file *file, int n)
+{ return 0; }
 
 #endif /* CONFIG_EVENTFD */
 
