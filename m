Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbZJATMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbZJATMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbZJATMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:12:00 -0400
Received: from mail.perches.com ([173.55.12.10]:1588 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085AbZJATL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:11:59 -0400
Subject: [RFC PATCH] kernel.h: Add pr_debug_noopt
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Oct 2009 12:12:03 -0700
Message-Id: <1254424323.1799.84.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many times a developer always wants to emit a KERN_DEBUG level
logging message even if DEBUG is not defined.

These messages today do not have a "pr_<level>" equivalent
and must be coded with printk(KERN_DEBUG.

This means that pr_fmt is not used with these logging messages.

I propose a new shortcut #define pr_<level> be added to kernel.h
to handle these KERN_DEBUG cases not prefixed with pr_fmt.

I'm not happy with the name.  Some good alternatives are
already in use in a couple of places.

pr_dbg is #defined in drivers/char/isicom.c
pr_vdebug is #defined in drivers/usb/gadget/u_serial.c

I think it's appropriate to remove and substitute one
or both of these #defines from the files in drivers
and use one or both in kernel.h

Suggestions?

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d3cd23f..f1f53b9 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -380,6 +380,8 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
         printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug_noopt(fmt, ...) \
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 


