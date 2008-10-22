Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYJVJH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYJVJH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYJVJHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:07:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62961 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYJVJHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:07:48 -0400
Message-ID: <48FEED04.2010402@cn.fujitsu.com>
Date: Wed, 22 Oct 2008 17:06:12 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: [PATCH] Fix debugfs_create_bool's error checking method for wireless/iwlwifi/
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

debugfs_create_bool() returns NULL if an error occurs, returns -ENODEV
when debugfs is not enabled in the kernel.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 20db0eb..5346ed5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -58,7 +58,8 @@
 #define DEBUGFS_ADD_BOOL(name, parent, ptr) do {                        \
 	dbgfs->dbgfs_##parent##_files.file_##name =                     \
 	debugfs_create_bool(#name, 0644, dbgfs->dir_##parent, ptr);     \
-	if (IS_ERR(dbgfs->dbgfs_##parent##_files.file_##name))          \
+	if (IS_ERR(dbgfs->dbgfs_##parent##_files.file_##name)		\
+			|| !dbgfs->dbgfs_##parent##_files.file_##name)	\
 		goto err;                                               \
 } while (0)
 
-- 1.5.5.3 


