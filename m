Return-Path: <linux-kernel-owner+w=401wt.eu-S933442AbYEUBHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442AbYEUBHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932999AbYEUBGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:06:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48413 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765716AbYEUBGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:06:42 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] sbus bpp: instances missed in s/dev_name/bpp_dev_name/
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Message-Id: <E1Jycmv-0008JI-Kt@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 02:06:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Length: 1164
Lines: 39

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/sbus/char/bpp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/sbus/char/bpp.c b/drivers/sbus/char/bpp.c
index b87037e..03c9660 100644
--- a/drivers/sbus/char/bpp.c
+++ b/drivers/sbus/char/bpp.c
@@ -869,7 +869,7 @@ static void probeLptPort(unsigned idx)
       instances[idx].mode = COMPATIBILITY;
       instances[idx].run_length = 0;
       instances[idx].run_flag = 0;
-      if (!request_region(lpAddr,3, dev_name)) return;
+      if (!request_region(lpAddr,3, bpp_dev_name)) return;
 
       /*
        * First, make sure the instance exists. Do this by writing to
@@ -1021,7 +1021,7 @@ static int __init bpp_init(void)
 	if (rc == 0)
 		return -ENODEV;
 
-	rc = register_chrdev(BPP_MAJOR, dev_name, &bpp_fops);
+	rc = register_chrdev(BPP_MAJOR, bpp_dev_name, &bpp_fops);
 	if (rc < 0)
 		return rc;
 
@@ -1037,7 +1037,7 @@ static void __exit bpp_cleanup(void)
 {
 	unsigned idx;
 
-	unregister_chrdev(BPP_MAJOR, dev_name);
+	unregister_chrdev(BPP_MAJOR, bpp_dev_name);
 
 	for (idx = 0;  idx < BPP_NO; idx++) {
 		if (instances[idx].present)
-- 
1.5.3.GIT


