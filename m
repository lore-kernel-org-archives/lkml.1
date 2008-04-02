Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbYDAMX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbYDAMX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYDAMXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:23:49 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:37854 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbYDAMXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:23:48 -0400
X-IronPort-AV: E=Sophos;i="4.25,587,1199682000"; 
   d="scan'208";a="65502261"
From: Bryan Wu <cooloney@kernel.org>
To: Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH 1/1] [NFS/NOMMU]: fix bug - executing FDPIC ELF on NFS mount triggers BUG() at mm/nommu.c:862:/do_mmap_private()
Date: Tue,  1 Apr 2008 20:23:39 -0700
Message-Id: <1207106619-7673-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NFS needs a NOMMU version mmap function to support uClinux on NOMMU machine
http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_id=141&tracker_item_id=3992

Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
---
 fs/nfs/file.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index ef57a5a..5d2e9d9 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -64,7 +64,11 @@ const struct file_operations nfs_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= nfs_file_read,
 	.aio_write	= nfs_file_write,
+#ifdef CONFIG_MMU
 	.mmap		= nfs_file_mmap,
+#else
+	.mmap		= generic_file_mmap,
+#endif
 	.open		= nfs_file_open,
 	.flush		= nfs_file_flush,
 	.release	= nfs_file_release,
-- 
1.5.4.3
