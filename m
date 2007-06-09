Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbXFIIHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbXFIIHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbXFIIHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:07:08 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:37061
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbXFIIHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:07:04 -0400
Message-ID: <466A5F8A.4080700@hawkeye.stone.uk.eu.org>
Date: Sat, 09 Jun 2007 09:06:34 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, Ian Kent <raven@themaw.net>
Subject: [PATCH 1/7] Add a new debug function to kernel.h
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org> <466A5E28.2000707@hawkeye.stone.uk.eu.org>
In-Reply-To: <466A5E28.2000707@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new macro to print to KERN_ERR initially for ncp but
others may want to use it

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
---
Index: linux/include/linux/kernel.h
===================================================================
--- linux.orig/include/linux/kernel.h
+++ linux/include/linux/kernel.h
@@ -228,11 +228,18 @@ extern void print_hex_dump(const char *l
 /* If you are writing a driver, please use dev_dbg instead */
 #define pr_debug(fmt,arg...) \
 	printk(KERN_DEBUG fmt,##arg)
+#define pr_err(fmt,arg...) \
+	printk(KERN_ERR fmt,##arg)
 #else
 static inline int __attribute__ ((format (printf, 1, 2)))
pr_debug(const char * fmt, ...)
 {
 	return 0;
 }
+
+static inline int __attribute__ ((format (printf, 1, 2))) pr_err(const
char * fmt, ...)
+{
+	return 0;
+}
 #endif

 #define pr_info(fmt,arg...) \


