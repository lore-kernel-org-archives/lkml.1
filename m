Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbYGHQ71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbYGHQ71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbYGHQ5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:57:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:55124 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401AbYGHQ5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:57:40 -0400
Date: Tue, 8 Jul 2008 09:57:00 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 17/17] Use WARN() in fs/proc/
Message-ID: <20080708095700.3d46bdfa@infradead.org>
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
Subject: Use WARN() instead of printk+WARN_ON() in fs/procfs

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.
This way, the entire if() {} section can collapse into the WARN() as well.

Signed-off-by: Arjan van de VenIndex: linux.trees.git/fs/proc/generic.c
===================================================================
---
 fs/proc/generic.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux.trees.git/fs/proc/generic.c
===================================================================
--- linux.trees.git.orig/fs/proc/generic.c
+++ linux.trees.git/fs/proc/generic.c
@@ -792,12 +792,9 @@ continue_removing:
 	if (S_ISDIR(de->mode))
 		parent->nlink--;
 	de->nlink = 0;
-	if (de->subdir) {
-		printk(KERN_WARNING "%s: removing non-empty directory "
+	WARN(de->subdir, KERN_WARNING "%s: removing non-empty directory "
 			"'%s/%s', leaking at least '%s'\n", __func__,
 			de->parent->name, de->name, de->subdir->name);
-		WARN_ON(1);
-	}
 	if (atomic_dec_and_test(&de->count))
 		free_proc_entry(de);
 }
