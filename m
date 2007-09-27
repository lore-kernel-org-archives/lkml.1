Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbXI0OKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbXI0OKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbXI0OJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:09:47 -0400
Received: from ns.suse.de ([195.135.220.2]:36782 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922AbXI0OJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:09:44 -0400
Message-Id: <20070927141227.559764756@X40.localnet>
References: <20070927141200.820970144@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Thu, 27 Sep 2007 16:12:02 +0200
From: jblunck@suse.de
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@lst.de, agruen@suse.de, tiwai@suse.de
Subject: [patch 02/10] Dont touch fs_struct in usermodehelper
Content-Disposition: inline; filename=dont-touch-current-fs-usermodehelper.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This test seems to be unnecessary since we always have rootfs mounted before
calling a usermodehelper.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 kernel/kmod.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: b/kernel/kmod.c
===================================================================
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -173,10 +173,7 @@ static int ____call_usermodehelper(void 
 	 */
 	set_user_nice(current, 0);
 
-	retval = -EPERM;
-	if (current->fs->root)
-		retval = kernel_execve(sub_info->path,
-				sub_info->argv, sub_info->envp);
+	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
 
 	/* Exec failed? */
 	sub_info->retval = retval;

-- 

