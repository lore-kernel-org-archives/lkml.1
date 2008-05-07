Return-Path: <linux-kernel-owner+w=401wt.eu-S1762843AbYEGGW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762843AbYEGGW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbYEGGWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:22:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41791 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbYEGGWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:22:09 -0400
Date: Tue, 6 May 2008 23:21:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch 3/3] Example use of WARN()
Message-ID: <20080506232156.159ed493@infradead.org>
In-Reply-To: <20080506232113.7f066c26@infradead.org>
References: <20080506232017.247001e0@infradead.org>
	<20080506232113.7f066c26@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Example use of WARN()

now that WARN() exists, we can fold some of the printk's into it

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 lib/kobject.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 718e510..960f4ed 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -164,9 +164,8 @@ static int kobject_add_internal(struct kobject *kobj)
 		return -ENOENT;
 
 	if (!kobj->name || !kobj->name[0]) {
-		pr_debug("kobject: (%p): attempted to be registered with empty "
+		WARN(1, "kobject: (%p): attempted to be registered with empty "
 			 "name!\n", kobj);
-		WARN_ON(1);
 		return -EINVAL;
 	}
 
@@ -576,12 +575,10 @@ static void kobject_release(struct kref *kref)
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
-- 
1.5.4.5


