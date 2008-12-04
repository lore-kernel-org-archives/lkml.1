Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYLDMwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYLDMwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYLDMwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:52:22 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:36668 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYLDMwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:52:21 -0500
Date: Thu, 4 Dec 2008 13:51:13 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Jason Baron <jbaron@redhat.com>, Greg K-H <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Make DEBUG take precedence over DYNAMIC_PRINTK_DEBUG.
Message-ID: <20081204135113.6d91efb3@gondolin>
In-Reply-To: <20081204134845.6c1df66b@gondolin>
References: <20081202145251.6555d4cc@gondolin>
	<20081203201203.GA3128@redhat.com>
	<20081204134845.6c1df66b@gondolin>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Statically defined DEBUG should take precedence over
dynamically enabled debugging; otherwise adding DEBUG
(like, for example, via CONFIG_DEBUG_KOBJECT) does not
have the expected result of printing pr_debug() messages
unconditionally.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 include/linux/kernel.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.orig/include/linux/kernel.h
+++ linux-2.6/include/linux/kernel.h
@@ -338,13 +338,13 @@ static inline char *pack_hex_byte(char *
         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+#if defined(DEBUG)
+#define pr_debug(fmt, ...) \
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#elif defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
 #define pr_debug(fmt, ...) do { \
 	dynamic_pr_debug(pr_fmt(fmt), ##__VA_ARGS__); \
 	} while (0)
-#elif defined(DEBUG)
-#define pr_debug(fmt, ...) \
-	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_debug(fmt, ...) \
 	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
