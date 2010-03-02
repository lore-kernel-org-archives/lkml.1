Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0CBXdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:33:04 -0500
Received: from kroah.org ([198.145.64.141]:38690 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab0CBX3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:45 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 50/62] sysfs: Pack sysfs_dirent more tightly.
Date: Tue,  2 Mar 2010 15:28:49 -0800
Message-Id: <1267572541-410-50-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

Placing the 16bit s_mode between a pointer and a long doesn't pack well
especailly on 64bit where we wast 48 bits.  So move s_mode and
declare it as a unsigned short.  This is the sysfs backing store
after all we don't need fields extra large just in case someday
we want userspace to be able to use a larger value.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/sysfs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 37e0e08..5a3192a 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -66,8 +66,8 @@ struct sysfs_dirent {
 	};
 
 	unsigned int		s_flags;
+	unsigned short		s_mode;
 	ino_t			s_ino;
-	umode_t			s_mode;
 	struct sysfs_inode_attrs *s_iattr;
 };
 
-- 
1.7.0.1

