Return-Path: <linux-kernel-owner+w=401wt.eu-S1761424AbXKOQPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbXKOQPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760241AbXKOQPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:15:35 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:41953 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764785AbXKOQPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:15:33 -0500
Date: Thu, 15 Nov 2007 19:14:22 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] proc: remove useless check on symlink removal
Message-ID: <20071115161422.GH6216@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

proc symlinks always have valid ->data containing destination of symlink.
No need to check it on removal -- proc_symlink() already done it.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/proc/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -704,7 +704,7 @@ void free_proc_entry(struct proc_dir_entry *de)
 
 	release_inode_number(ino);
 
-	if (S_ISLNK(de->mode) && de->data)
+	if (S_ISLNK(de->mode))
 		kfree(de->data);
 	kfree(de);
 }

