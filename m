Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbXJVG5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbXJVG5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 02:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXJVG5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 02:57:30 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41710 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbXJVG53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 02:57:29 -0400
Date: Mon, 22 Oct 2007 12:27:21 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Blunck <jblunck@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: [PATCH 04/13] Move struct path into its own header
Message-ID: <20071022065721.GE6489@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071022065352.GA6489@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022065352.GA6489@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Move the definition of struct path into its own header file for further
patches.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/namei.h |    6 +-----
 include/linux/path.h  |   12 ++++++++++++
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -4,6 +4,7 @@
 #include <linux/dcache.h>
 #include <linux/linkage.h>
 #include <linux/mount.h>
+#include <linux/path.h>
 
 struct vfsmount;
 
@@ -30,11 +31,6 @@ struct nameidata {
 	} intent;
 };
 
-struct path {
-	struct vfsmount *mnt;
-	struct dentry *dentry;
-};
-
 /*
  * Type of the last component on LOOKUP_PARENT
  */
--- /dev/null
+++ b/include/linux/path.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_PATH_H
+#define _LINUX_PATH_H
+
+struct dentry;
+struct vfsmount;
+
+struct path {
+	struct vfsmount *mnt;
+	struct dentry *dentry;
+};
+
+#endif  /* _LINUX_PATH_H */
