Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbYGHRCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbYGHRCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbYGHQ6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:58:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:37996 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666AbYGHQ6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:58:16 -0400
Date: Tue, 8 Jul 2008 09:41:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 3/17] Introduce WARN() usage in the kobject code
Message-ID: <20080708094109.03084e6a@infradead.org>
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

Now that WARN() exists, we can fold some of the printk's into it.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux.trees.git/lib/kobject.c
===================================================================
--- linux.trees.git.orig/lib/kobject.c
+++ linux.trees.git/lib/kobject.c
@@ -215,9 +215,8 @@ static int kobject_add_internal(struct k
 		return -ENOENT;
 
 	if (!kobj->name || !kobj->name[0]) {
-		pr_debug("kobject: (%p): attempted to be registered with empty "
+		WARN(1, "kobject: (%p): attempted to be registered with empty "
 			 "name!\n", kobj);
-		WARN_ON(1);
 		return -EINVAL;
 	}
 
@@ -627,12 +626,10 @@ static void kobject_release(struct kref 
 void kobject_put(struct kobject *kobj)
 {
 	if (kobj) {
-		if (!kobj->state_initialized) {
-			printk(KERN_WARNING "kobject: '%s' (%p): is not "
+		if (!kobj->state_initialized)
+			WARN(1, KERN_WARNING "kobject: '%s' (%p): is not "
 			       "initialized, yet kobject_put() is being "
 			       "called.\n", kobject_name(kobj), kobj);
-			WARN_ON(1);
-		}
 		kref_put(&kobj->kref, kobject_release);
 	}
 }
