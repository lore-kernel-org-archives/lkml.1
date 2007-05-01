Return-Path: <linux-kernel-owner+w=401wt.eu-S1423011AbXEAAvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423011AbXEAAvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423409AbXEAAvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:51:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36798 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423011AbXEAAvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:51:18 -0400
Date: Mon, 30 Apr 2007 17:55:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, gregkh <greg@kroah.com>
Subject: [PATCH] sysfs: printk format warning
Message-Id: <20070430175503.51251d45.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sysfs printk format warning:
fs/sysfs/bin.c:62: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/sysfs/bin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21-git3.orig/fs/sysfs/bin.c
+++ linux-2.6.21-git3/fs/sysfs/bin.c
@@ -59,7 +59,7 @@ read(struct file * file, char __user * u
 	if (copy_to_user(userbuf, buffer, count))
 		return -EFAULT;
 
-	pr_debug("offs = %lld, *off = %lld, count = %d\n", offs, *off, count);
+	pr_debug("offs = %lld, *off = %lld, count = %zd\n", offs, *off, count);
 
 	*off = offs + count;
 
