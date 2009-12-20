Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZLTVVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZLTVVv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 16:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbZLTVVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 16:21:50 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:63928 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbZLTVVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 16:21:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=m99ijd7HnxcL2hjjX0Z/bChRA6xz5cf8IAyEXWaiUoV6GmJK7N+MC4hEkWYNOLIG3k
         Tfwrp07GdFmDa5RSPaQfhhYvzCmnAXg6lIu34XoEqZMMjZMV/kTv5AXLSplF2qSpnBZk
         +YcHlN/yX2YT+TuHb0/b/MSM1/FrSSpCJ5OQA=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: viro@zeniv.linux.org.uk, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] fs/compat_ioctl.c: fix build error when !BLOCK
Date: Mon, 21 Dec 2009 00:21:32 +0300
Message-Id: <1261344092-30700-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error when CONFIG_BLOCK is not set.
fs/compat_ioctl.c:1604: error: 'SG_SET_TRANSFORM' undeclared

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 fs/compat_ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 14cbc83..e4d4765 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1600,8 +1600,10 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case KDSKBMETA:
 	case KDSKBLED:
 	case KDSETLED:
+#ifdef CONFIG_BLOCK	
 	/* SG stuff */
 	case SG_SET_TRANSFORM:
+#endif
 	/* AUTOFS */
 	case AUTOFS_IOC_READY:
 	case AUTOFS_IOC_FAIL:
-- 
1.6.6.rc3

