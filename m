Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbYIIGTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbYIIGTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbYIIGT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:19:29 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:1055 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbYIIGT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:19:28 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elite.hu, steven@uplinklabs.net
Subject: [PATCH] init/initramfs.c: unused function when compiling without CONFIG_BLK_DEV_RAM
Date: Mon,  8 Sep 2008 16:19:10 -0700
Message-Id: <1220915951-11434-2-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1220915951-11434-1-git-send-email-steven@uplinklabs.net>
References: <1220915951-11434-1-git-send-email-steven@uplinklabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing compiler warning when the kernel isn't compiled with support
for RAM block devices enabled.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 init/initramfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index da8d030..2f056e2 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -512,6 +512,7 @@ skip:
 	initrd_end = 0;
 }
 
+#ifdef CONFIG_BLK_DEV_RAM
 #define BUF_SIZE 1024
 static void __init clean_rootfs(void)
 {
@@ -558,6 +559,7 @@ static void __init clean_rootfs(void)
 	sys_close(fd);
 	kfree(buf);
 }
+#endif
 
 static int __init populate_rootfs(void)
 {
-- 
1.6.0.1

