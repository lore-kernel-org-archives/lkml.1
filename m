Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZIJKaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZIJKaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbZIJK37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:29:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbZIJK34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:29:56 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/15] GFS2: Add explanation of extended attr on-disk format
Date: Thu, 10 Sep 2009 12:28:02 +0100
Message-Id: <1252582087-10007-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1252582087-10007-10-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-3-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-4-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-5-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-6-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-7-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-8-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-9-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-10-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some useful info regarding the on-disk representation of
GFS2 extended attributes.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 include/linux/gfs2_ondisk.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index c56b4bc..b80c88d 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -333,6 +333,28 @@ struct gfs2_leaf {
 
 /*
  * Extended attribute header format
+ *
+ * This works in a similar way to dirents. There is a fixed size header
+ * followed by a variable length section made up of the name and the
+ * associated data. In the case of a "stuffed" entry, the value is
+ * inline directly after the name, the ea_num_ptrs entry will be
+ * zero in that case. For non-"stuffed" entries, there will be
+ * a set of pointers (aligned to 8 byte boundary) to the block(s)
+ * containing the value.
+ *
+ * The blocks containing the values and the blocks containing the
+ * extended attribute headers themselves all start with the common
+ * metadata header. Each inode, if it has extended attributes, will
+ * have either a single block containing the extended attribute headers
+ * or a single indirect block pointing to blocks containing the
+ * extended attribure headers.
+ *
+ * The maximim size of the data part of an extended attribute is 64k
+ * so the number of blocks required depends upon block size. Since the
+ * block size also determines the number of pointers in an indirect
+ * block, its a fairly complicated calculation to work out the maximum
+ * number of blocks that an inode may have relating to extended attributes.
+ *
  */
 
 #define GFS2_EA_MAX_NAME_LEN	255
-- 
1.6.2.5

