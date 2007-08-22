Return-Path: <linux-kernel-owner+w=401wt.eu-S934394AbXHVWWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934394AbXHVWWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934036AbXHVWVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:21:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:54031 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933400AbXHVWVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:21:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/5] Fix Off-by-one in /sys/module/*/refcnt
Date: Wed, 22 Aug 2007 15:10:17 -0700
Message-Id: <11878206273940-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.rc5
In-Reply-To: <1187820620110-git-send-email-gregkh@suse.de>
References: <20070822220747.GA30603@kroah.com>
 <1187820620110-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

sysfs internals were changed to not pin module in question.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/module.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 33c04ad..db0ead0 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -784,8 +784,7 @@ EXPORT_SYMBOL_GPL(symbol_put_addr);
 static ssize_t show_refcnt(struct module_attribute *mattr,
 			   struct module *mod, char *buffer)
 {
-	/* sysfs holds a reference */
-	return sprintf(buffer, "%u\n", module_refcount(mod)-1);
+	return sprintf(buffer, "%u\n", module_refcount(mod));
 }
 
 static struct module_attribute refcnt = {
-- 
1.5.3.rc5

