Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbXLWUBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbXLWUBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 15:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXLWUBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 15:01:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52235 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbXLWUBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 15:01:06 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] uml: user of helper_wait() got missed when it got extra arguments
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1J6X0S-0007SZ-Aa@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 23 Dec 2007 20:01:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/drivers/harddog_user.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/harddog_user.c b/arch/um/drivers/harddog_user.c
index b56f8e0..448ba59 100644
--- a/arch/um/drivers/harddog_user.c
+++ b/arch/um/drivers/harddog_user.c
@@ -79,14 +79,14 @@ int start_watchdog(int *in_fd_ret, int *out_fd_ret, char *sock)
 	n = read(in_fds[0], &c, sizeof(c));
 	if (n == 0) {
 		printk("harddog_open - EOF on watchdog pipe\n");
-		helper_wait(pid);
+		helper_wait(pid, 1, NULL);
 		err = -EIO;
 		goto out_close_out;
 	}
 	else if (n < 0) {
 		printk("harddog_open - read of watchdog pipe failed, "
 		       "err = %d\n", errno);
-		helper_wait(pid);
+		helper_wait(pid, 1, NULL);
 		err = n;
 		goto out_close_out;
 	}
-- 
1.5.3.GIT

