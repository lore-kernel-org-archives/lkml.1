Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbYGHQ7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbYGHQ7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbYGHQ5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:57:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:55131 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbYGHQ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:57:43 -0400
Date: Tue, 8 Jul 2008 09:50:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 9/17] Use WARN() in arch/x86/mm/ioremap.c
Message-ID: <20080708095022.69866840@infradead.org>
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
Subject: Use WARN instead of printk+WARN_ON in arch/x86/mm/ioremap.c

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux.trees.git/arch/x86/mm/ioremap.c
===================================================================
--- linux.trees.git.orig/arch/x86/mm/ioremap.c
+++ linux.trees.git/arch/x86/mm/ioremap.c
@@ -522,13 +522,11 @@ static int __init check_early_ioremap_le
 {
 	if (!early_ioremap_nested)
 		return 0;
-
-	printk(KERN_WARNING
+	WARN(1, KERN_WARNING
 	       "Debug warning: early ioremap leak of %d areas detected.\n",
-	       early_ioremap_nested);
+		early_ioremap_nested);
 	printk(KERN_WARNING
-	       "please boot with early_ioremap_debug and report the dmesg.\n");
-	WARN_ON(1);
+		"please boot with early_ioremap_debug and report the dmesg.\n");
 
 	return 1;
 }
