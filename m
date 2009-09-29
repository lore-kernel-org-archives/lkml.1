Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbZI2VIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbZI2VIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZI2VIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:08:54 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33604 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZI2VIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:08:53 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Eric Paris <eparis@redhat.com>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, stable@kernel.org,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] ima: ecryptfs fix imbalance message
Date: Tue, 29 Sep 2009 17:08:55 -0400
Message-Id: <1254258535-18894-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The underlying files are measured. Update the counters to get rid of
the ecryptfs imbalance message. (http://bugzilla.redhat.com/519737)

Reported-by: Sachin Garg <ascii79@gmail.com>
Cc: stable@kernel.org
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 fs/ecryptfs/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 9f0aa98..177e61e 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -35,6 +35,7 @@
 #include <linux/key.h>
 #include <linux/parser.h>
 #include <linux/fs_stack.h>
+#include <linux/ima.h>
 #include "ecryptfs_kernel.h"
 
 /**
@@ -135,7 +136,8 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 			       "rc = [%d]\n", lower_dentry, lower_mnt, rc);
 			rc = PTR_ERR(inode_info->lower_file);
 			inode_info->lower_file = NULL;
-		}
+		} else
+			ima_counts_get(inode_info->lower_file);
 	}
 	mutex_unlock(&inode_info->lower_file_mutex);
 	return rc;
-- 
1.6.0.6

