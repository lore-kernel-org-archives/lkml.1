Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYFXFcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYFXFcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYFXFb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:31:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57268 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYFXFb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:31:56 -0400
Message-ID: <4860866F.7050703@cn.fujitsu.com>
Date: Tue, 24 Jun 2008 13:30:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sh: fix seq_file memory leak
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using single_open(), single_release() should be used instead
of seq_release(), otherwise there is a memory leak.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 arch/sh/mm/cache-debugfs.c |    2 +-
 arch/sh/mm/pmb.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/mm/cache-debugfs.c b/arch/sh/mm/cache-debugfs.c
index c5b56d5..0e189cc 100644
--- a/arch/sh/mm/cache-debugfs.c
+++ b/arch/sh/mm/cache-debugfs.c
@@ -120,7 +120,7 @@ static const struct file_operations cache_debugfs_fops = {
 	.open		= cache_debugfs_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 static int __init cache_debugfs_init(void)
diff --git a/arch/sh/mm/pmb.c b/arch/sh/mm/pmb.c
index 0b0ec6e..95653e2 100644
--- a/arch/sh/mm/pmb.c
+++ b/arch/sh/mm/pmb.c
@@ -385,7 +385,7 @@ static const struct file_operations pmb_debugfs_fops = {
 	.open		= pmb_debugfs_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 static int __init pmb_debugfs_init(void)
-- 
1.5.4.rc3
