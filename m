Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbYJQL0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbYJQL0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYJQL01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:26:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63978 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbYJQL00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:26:26 -0400
Message-ID: <48F8760F.4070909@cn.fujitsu.com>
Date: Fri, 17 Oct 2008 19:25:03 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: lethal@linux-sh.org
CC: linux-sh@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix debugfs_create_dir's error checking method for arch/sh/kernel/
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

debugfs_create_dir() returns NULL if an error occurs, returns -ENODEV
when debugfs is not enabled in the kernel.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 arch/sh/kernel/setup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index de83205..c41c4dc 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -530,6 +530,8 @@ struct dentry *sh_debugfs_root;
 static int __init sh_debugfs_init(void)
 {
 	sh_debugfs_root = debugfs_create_dir("sh", NULL);
+	if (!sh_debugfs_root)
+		return -ENOMEM;
 	if (IS_ERR(sh_debugfs_root))
 		return PTR_ERR(sh_debugfs_root);
 
-- 
1.5.5.3


