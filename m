Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbYGHQ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbYGHQ5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYGHQ5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:57:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:55089 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbYGHQ5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:57:10 -0400
Date: Tue, 8 Jul 2008 09:45:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 5/17] Use WARN() in kernel/panic.c
Message-ID: <20080708094507.4ae10e5d@infradead.org>
In-Reply-To: <20080708093800.274504ba@infradead.org>
References: <20080708093800.274504ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Use WARN instead of printk+WARN_ON in kernel/panic.c

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.
This allowed the if() to be folded entirely into the WARN()

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/panic.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux.trees.git/kernel/panic.c
===================================================================
--- linux.trees.git.orig/kernel/panic.c
+++ linux.trees.git/kernel/panic.c
@@ -392,10 +392,8 @@ static int __stack_chk_test(void)
 	printk(KERN_INFO "Testing -fstack-protector-all feature\n");
 	__stack_check_testing = (unsigned long)&__stack_chk_test_func;
 	__stack_chk_test_func();
-	if (__stack_check_testing) {
-		printk(KERN_ERR "-fstack-protector-all test failed\n");
-		WARN_ON(1);
-	}
+	WARN(__stack_check_testing,
+			KERN_ERR "-fstack-protector-all test failed\n");
 	return 0;
 }
 /*
