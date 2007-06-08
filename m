Return-Path: <linux-kernel-owner+w=401wt.eu-S970976AbXFHUZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970976AbXFHUZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbXFHUZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:25:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:38207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbXFHUZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:25:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 4/5] kobject: use the proper printk level for kobject error
Date: Fri,  8 Jun 2007 13:04:42 -0700
Message-Id: <1181333098614-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <118133309258-git-send-email-gregkh@suse.de>
References: <20070608200407.GA22825@kroah.com>
 <11813330832783-git-send-email-gregkh@suse.de>
 <11813330873231-git-send-email-gregkh@suse.de>
 <118133309258-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Jean Delvare <khali@linux-fr.org> for pointing it out to me.

Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index fc5f3f6..ac15206 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -202,14 +202,14 @@ int kobject_shadow_add(struct kobject * kobj, struct dentry *shadow_parent)
 
 		/* be noisy on error issues */
 		if (error == -EEXIST)
-			printk("kobject_add failed for %s with -EEXIST, "
-			       "don't try to register things with the "
-			       "same name in the same directory.\n",
+			printk(KERN_ERR "kobject_add failed for %s with "
+			       "-EEXIST, don't try to register things with "
+			       "the same name in the same directory.\n",
 			       kobject_name(kobj));
 		else
-			printk("kobject_add failed for %s (%d)\n",
+			printk(KERN_ERR "kobject_add failed for %s (%d)\n",
 			       kobject_name(kobj), error);
-		 dump_stack();
+		dump_stack();
 	}
 
 	return error;
-- 
1.5.2.1

