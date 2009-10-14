Return-Path: <linux-kernel-owner+w=401wt.eu-S1761518AbZJNC5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518AbZJNC5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 22:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760223AbZJNC5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 22:57:00 -0400
Received: from mail.perches.com ([173.55.12.10]:2123 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759333AbZJNC5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 22:57:00 -0400
Subject: [PATCH] kernel.h: Add a never optimized away pr_dbg for
 printk(KERN_DEBUG pr_fmt(fmt)...)
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Oct 2009 19:56:22 -0700
Message-Id: <1255488982.1909.26.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many developers use a logging message that
is printed at KERN_DEBUG level that is always
printed regardless of #define DEBUG levels.

pr_debug can be optimized away to a null statement.

Add a pr_dbg message that prints at KERN_DEBUG
level that uses pr_fmt() that can not be optimized
to nothing.

Signed-off-by: Joe Perches <joe@perches.com>

 include/linux/kernel.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f4e3184..2ad0396 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -380,6 +380,8 @@ static inline char *pack_hex_byte(char *buf, u8
byte)
         printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_dbg(fmt, ...) \
+        printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 


