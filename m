Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbZBAPE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbZBAPE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 10:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZBAPEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 10:04:50 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58504 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZBAPEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 10:04:49 -0500
Date: Sun, 1 Feb 2009 16:04:46 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: [patch] fs: make struct dentry->d_op const
Message-ID: <alpine.LSU.2.00.0902011602170.609@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


maybe this little patchlet can still make it into the running -rc? (no 
new compile warnings are thrown on x86_64 allyesconfig) - So that 
subsequent const-tagging patches can (successfully) find their way 
through the subsystems within the next cycle since they would depend on 
this one.


---8<---
parent e6e6bbddc48545d1d1aeccce867639462ce31329
commit ad93838080ede785700c4935e7795f25761e2c12
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Feb 1 16:01:18 2009 +0100

fs: make struct dentry->d_op const

This change will allow for tagging many dentry_operations const
in the source tree.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/dcache.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index c66d224..1515636 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -112,7 +112,7 @@ struct dentry {
 	struct list_head d_subdirs;	/* our children */
 	struct list_head d_alias;	/* inode alias list */
 	unsigned long d_time;		/* used by d_revalidate */
-	struct dentry_operations *d_op;
+	const struct dentry_operations *d_op;
 	struct super_block *d_sb;	/* The root of the dentry tree */
 	void *d_fsdata;			/* fs-specific data */
 

