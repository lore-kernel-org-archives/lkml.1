Return-Path: <linux-kernel-owner+w=401wt.eu-S1767326AbXECCO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767326AbXECCO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767333AbXECCOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:14:54 -0400
Received: from mx1.suse.de ([195.135.220.2]:56306 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767326AbXECCOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:14:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/5] sysfs: printk format warning
Date: Wed,  2 May 2007 19:11:32 -0700
Message-Id: <11781583171670-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11781583073805-git-send-email-gregkh@suse.de>
References: <20070503020924.GB21316@kroah.com>
 <11781582932668-git-send-email-gregkh@suse.de>
 <11781583003703-git-send-email-gregkh@suse.de>
 <11781583073805-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sysfs printk format warning:
fs/sysfs/bin.c:62: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 8ea2a51..d3b9f5f 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -59,7 +59,7 @@ read(struct file * file, char __user * userbuf, size_t count, loff_t * off)
 	if (copy_to_user(userbuf, buffer, count))
 		return -EFAULT;
 
-	pr_debug("offs = %lld, *off = %lld, count = %d\n", offs, *off, count);
+	pr_debug("offs = %lld, *off = %lld, count = %zd\n", offs, *off, count);
 
 	*off = offs + count;
 
-- 
1.5.1.2

