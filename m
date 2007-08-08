Return-Path: <linux-kernel-owner+w=401wt.eu-S937397AbXHHRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937397AbXHHRTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934718AbXHHRTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:19:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:37154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763778AbXHHRTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:19:00 -0400
Message-Id: <20070808171643.542685765@suse.de>
References: <20070808171622.632749741@suse.de>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 19:16:23 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [RFC 01/10] Split up struct nameidata
Content-Disposition: inline; filename=nameidata-split.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Split up struct nameidata into struct vfs_lookup with the lookup result
and intent and the remaining fields for performing an actual lookup.

Signed-off-by: Andreas Gruenbacher <ag@bestbits.at>

---
 include/linux/namei.h |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -14,14 +14,14 @@ struct open_intent {
 
 enum { MAX_NESTED_LINKS = 8 };
 
-struct nameidata {
-	struct dentry	*dentry;
+struct path {
 	struct vfsmount *mnt;
-	struct qstr	last;
+	struct dentry *dentry;
+};
+
+struct vfs_lookup {
+	struct path	 path;
 	unsigned int	flags;
-	int		last_type;
-	unsigned	depth;
-	char *saved_names[MAX_NESTED_LINKS + 1];
 
 	/* Intent data */
 	union {
@@ -29,9 +29,12 @@ struct nameidata {
 	} intent;
 };
 
-struct path {
-	struct vfsmount *mnt;
-	struct dentry *dentry;
+struct nameidata {
+	struct vfs_lookup lookup;
+	struct qstr	last;
+	int		last_type;
+	unsigned	depth;
+	char *saved_names[MAX_NESTED_LINKS + 1];
 };
 
 /*

