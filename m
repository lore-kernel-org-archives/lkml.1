Return-Path: <linux-kernel-owner+w=401wt.eu-S1752129AbZL1KJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbZL1KJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZL1KJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:09:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:36364 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbZL1KJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:09:43 -0500
Date: Mon, 28 Dec 2009 10:08:35 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       vegard.nossum@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1261990935.4641.7.camel@penberg-laptop>
References: <1261990935.4641.7.camel@penberg-laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, kmemcheck: Use KERN_WARNING for error reporting
Message-ID: <tip-c0ca9da442df82b67095f230f24762042f9f3b7d@git.kernel.org>
Git-Commit-ID: c0ca9da442df82b67095f230f24762042f9f3b7d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0ca9da442df82b67095f230f24762042f9f3b7d
Gitweb:     http://git.kernel.org/tip/c0ca9da442df82b67095f230f24762042f9f3b7d
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Mon, 28 Dec 2009 11:02:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 10:28:35 +0100

x86, kmemcheck: Use KERN_WARNING for error reporting

As suggested by Vegard Nossum, use KERN_WARNING for error
reporting to make sure kmemcheck reports end up in syslog.

Suggested-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1261990935.4641.7.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/kmemcheck/error.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/kmemcheck/error.c b/arch/x86/mm/kmemcheck/error.c
index 4901d0d..af3b6c8 100644
--- a/arch/x86/mm/kmemcheck/error.c
+++ b/arch/x86/mm/kmemcheck/error.c
@@ -106,26 +106,25 @@ void kmemcheck_error_recall(void)
 
 	switch (e->type) {
 	case KMEMCHECK_ERROR_INVALID_ACCESS:
-		printk(KERN_ERR  "WARNING: kmemcheck: Caught %d-bit read "
-			"from %s memory (%p)\n",
+		printk(KERN_WARNING "WARNING: kmemcheck: Caught %d-bit read from %s memory (%p)\n",
 			8 * e->size, e->state < ARRAY_SIZE(desc) ?
 				desc[e->state] : "(invalid shadow state)",
 			(void *) e->address);
 
-		printk(KERN_INFO);
+		printk(KERN_WARNING);
 		for (i = 0; i < SHADOW_COPY_SIZE; ++i)
-			printk("%02x", e->memory_copy[i]);
-		printk("\n");
+			printk(KERN_CONT "%02x", e->memory_copy[i]);
+		printk(KERN_CONT "\n");
 
-		printk(KERN_INFO);
+		printk(KERN_WARNING);
 		for (i = 0; i < SHADOW_COPY_SIZE; ++i) {
 			if (e->shadow_copy[i] < ARRAY_SIZE(short_desc))
-				printk(" %c", short_desc[e->shadow_copy[i]]);
+				printk(KERN_CONT " %c", short_desc[e->shadow_copy[i]]);
 			else
-				printk(" ?");
+				printk(KERN_CONT " ?");
 		}
-		printk("\n");
-		printk(KERN_INFO "%*c\n", 2 + 2
+		printk(KERN_CONT "\n");
+		printk(KERN_WARNING "%*c\n", 2 + 2
 			* (int) (e->address & (SHADOW_COPY_SIZE - 1)), '^');
 		break;
 	case KMEMCHECK_ERROR_BUG:
