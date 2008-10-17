Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYJQKBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYJQKBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYJQKBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:01:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61831 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbYJQKBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:01:22 -0400
Message-ID: <48F86226.60806@cn.fujitsu.com>
Date: Fri, 17 Oct 2008 18:00:06 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Russell King <rmk+kernel@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] Fix debugfs_create_file's error checking method for arm/mach-ns9xxx
References: <48F8591E.7090008@cn.fujitsu.com>
In-Reply-To: <48F8591E.7090008@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs_create_file() returns NULL if an error occurs, returns -ENODEV
when debugfs is not enabled in the kernel.

Comparing to PATCH v1, because clk_debugfs_init is included in
"#if defined CONFIG_DEBUG_FS", we only need to check NULL return.
Thanks Li Zefan <lizf@cn.fujitsu.com>

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 arch/arm/mach-ns9xxx/clock.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ns9xxx/clock.c b/arch/arm/mach-ns9xxx/clock.c
index 44ed20d..f2dba83 100644
--- a/arch/arm/mach-ns9xxx/clock.c
+++ b/arch/arm/mach-ns9xxx/clock.c
@@ -208,7 +208,9 @@ static int __init clk_debugfs_init(void)
 
 	dentry = debugfs_create_file("clk", S_IFREG | S_IRUGO, NULL, NULL,
 			&clk_debugfs_operations);
-	return IS_ERR(dentry) ? PTR_ERR(dentry) : 0;
+	if (!dentry)
+		return -ENOMEM;
+	return 0;
 }
 subsys_initcall(clk_debugfs_init);
 
-- 
1.5.5.3



