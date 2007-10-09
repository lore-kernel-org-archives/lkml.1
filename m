Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbXJISIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbXJISIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbXJISHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:07:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbXJISHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:07:42 -0400
Message-Id: <20071009180512.277617567@X40.localnet>
References: <20071009180503.075306583@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Tue, 09 Oct 2007 20:05:05 +0200
From: Jan Blunck <jblunck@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [patch 02/10] Dont touch fs_struct in usermodehelper
Content-Disposition: inline; filename=vfs/dont-touch-current-fs-usermodehelper.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This test seems to be unnecessary since we always have rootfs mounted before
calling a usermodehelper.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Acked-by: Greg KH <greg@kroah.com>
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

