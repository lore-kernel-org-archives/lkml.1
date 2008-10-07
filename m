Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYJGLbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYJGLbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYJGLaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:30:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48654 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbYJGLaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:30:52 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [RFC PATCH] i_version: remount support
Date: Tue,  7 Oct 2008 07:30:48 -0400
Message-Id: <10dbd13724581b0dca8d77ae944aaf3c70b93137.1223341927.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for remounting a filesystem with the i_version option.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
diff --git a/fs/super.c b/fs/super.c
index e931ae9..3758cbe 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -641,6 +641,8 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 			return retval;
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
+	if (flags & MS_I_VERSION)
+		sb->s_flags |= MS_I_VERSION;
 	if (remount_rw)
 		DQUOT_ON_REMOUNT(sb);
 	return 0;
-- 
1.5.5.1

