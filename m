Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbXJVGz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbXJVGz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 02:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbXJVGzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 02:55:51 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39732 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbXJVGzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 02:55:50 -0400
Date: Mon, 22 Oct 2007 12:25:46 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Blunck <jblunck@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: [PATCH 02/13] Don't touch fs_struct in usermodehelper
Message-ID: <20071022065546.GC6489@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071022065352.GA6489@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022065352.GA6489@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

This test seems to be unnecessary since we always have rootfs mounted before
calling a usermodehelper.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 kernel/kmod.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

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
