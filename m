Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXCQBfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXCQBfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 21:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933059AbXCQBfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 21:35:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27521 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbXCQBfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 21:35:17 -0400
Date: Fri, 16 Mar 2007 18:34:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] kprobes: fix sparse NULL warning
Message-Id: <20070316183436.eb25034e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse NULL warnings:
kernel/kprobes.c:915:49: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/kprobes.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2621-rc4.orig/kernel/kprobes.c
+++ linux-2621-rc4/kernel/kprobes.c
@@ -35,6 +35,7 @@
 #include <linux/hash.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/stddef.h>
 #include <linux/module.h>
 #include <linux/moduleloader.h>
 #include <linux/kallsyms.h>
@@ -912,7 +913,7 @@ static int __kprobes debugfs_kprobe_init
 	if (!dir)
 		return -ENOMEM;
 
-	file = debugfs_create_file("list", 0444, dir , 0 ,
+	file = debugfs_create_file("list", 0444, dir, NULL,
 				&debugfs_kprobes_operations);
 	if (!file) {
 		debugfs_remove(dir);
