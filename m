Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYJQLN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYJQLN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYJQLNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:13:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60663 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbYJQLNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:13:47 -0400
Message-ID: <48F8731E.40100@cn.fujitsu.com>
Date: Fri, 17 Oct 2008 19:12:30 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: ralf@linux-mips.org
CC: linux-mips@linux-mips.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix debugfs_create_*'s error checking method for mips/math-emu/
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
 arch/mips/math-emu/cp1emu.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
index b08fc65..7ec0b21 100644
--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -1299,12 +1299,12 @@ static int __init debugfs_fpuemu(void)
 	if (!mips_debugfs_dir)
 		return -ENODEV;
 	dir = debugfs_create_dir("fpuemustats", mips_debugfs_dir);
-	if (IS_ERR(dir))
-		return PTR_ERR(dir);
+	if (!dir)
+		return -ENOMEM;
 	for (i = 0; i < ARRAY_SIZE(vars); i++) {
 		d = debugfs_create_u32(vars[i].name, S_IRUGO, dir, vars[i].v);
-		if (IS_ERR(d))
-			return PTR_ERR(d);
+		if (!d)
+			return -ENOMEM;
 	}
 	return 0;
 }
-- 
1.5.5.3


