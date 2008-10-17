Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbYJQLOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbYJQLOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYJQLNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:13:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59339 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbYJQLNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:13:49 -0400
Message-ID: <48F87323.6020303@cn.fujitsu.com>
Date: Fri, 17 Oct 2008 19:12:35 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: ralf@linux-mips.org
CC: linux-mips@linux-mips.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix debugfs_create_*'s error checking method for mips/kernel/
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

debugfs_create_*() returns NULL if an error occurs, returns -ENODEV
when debugfs is not enabled in the kernel.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 arch/mips/kernel/setup.c     |    4 ++--
 arch/mips/kernel/unaligned.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 16f8edf..4430a1f 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -601,8 +601,8 @@ static int __init debugfs_mips(void)
 	struct dentry *d;
 
 	d = debugfs_create_dir("mips", NULL);
-	if (IS_ERR(d))
-		return PTR_ERR(d);
+	if (!d)
+		return -ENOMEM;
 	mips_debugfs_dir = d;
 	return 0;
 }
diff --git a/arch/mips/kernel/unaligned.c b/arch/mips/kernel/unaligned.c
index c327b21..2070966 100644
--- a/arch/mips/kernel/unaligned.c
+++ b/arch/mips/kernel/unaligned.c
@@ -560,12 +560,12 @@ static int __init debugfs_unaligned(void)
 		return -ENODEV;
 	d = debugfs_create_u32("unaligned_instructions", S_IRUGO,
 			       mips_debugfs_dir, &unaligned_instructions);
-	if (IS_ERR(d))
-		return PTR_ERR(d);
+	if (!d)
+		return -ENOMEM;
 	d = debugfs_create_u32("unaligned_action", S_IRUGO | S_IWUSR,
 			       mips_debugfs_dir, &unaligned_action);
-	if (IS_ERR(d))
-		return PTR_ERR(d);
+	if (!d)
+		return -ENOMEM;
 	return 0;
 }
 __initcall(debugfs_unaligned);
-- 
1.5.5.3


