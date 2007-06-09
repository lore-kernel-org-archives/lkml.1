Return-Path: <linux-kernel-owner+w=401wt.eu-S1762906AbXFIITZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906AbXFIITZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbXFIITO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:19:14 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:57922
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbXFIITM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:19:12 -0400
Message-ID: <466A625C.4030700@hawkeye.stone.uk.eu.org>
Date: Sat, 09 Jun 2007 09:18:36 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, Ian Kent <raven@themaw.net>
Subject: [PATCH 6/7] Add pr_debug_pid to kernel.h
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org> <466A5E28.2000707@hawkeye.stone.uk.eu.org>
In-Reply-To: <466A5E28.2000707@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new function to kernel.h. This function prints out the
pid of the current process and the name of the function where it was
called from followed by the debug message and a newline.

This function mimics the output of autofs4.

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
---
Index: linux/include/linux/kernel.h
===================================================================
--- linux.orig/include/linux/kernel.h
+++ linux/include/linux/kernel.h
@@ -228,6 +228,8 @@ extern void print_hex_dump(const char *l
 /* If you are writing a driver, please use dev_dbg instead */
 #define pr_debug(fmt,arg...) \
 	printk(KERN_DEBUG fmt,##arg)
+#define pr_debug_pid(fmt,arg...) \
+	printk(KERN_DEBUG "pid %d: %s: " fmt "\n" , current->pid ,
__FUNCTION__, ##args)
 #define pr_err(fmt,arg...) \
 	printk(KERN_ERR fmt,##arg)
 #else
@@ -236,6 +238,11 @@ static inline int __attribute__ ((format
 	return 0;
 }

+static inline int __attribute__ ((format (printf, 1, 2)))
pr_debug_pid(const char * fmt, ...)
+{
+	return 0;
+}
+
 static inline int __attribute__ ((format (printf, 1, 2))) pr_err(const
char * fmt, ...)
 {
 	return 0;


