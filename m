Return-Path: <linux-kernel-owner+w=401wt.eu-S932504AbXCVJt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbXCVJt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932690AbXCVJt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:49:26 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:40937 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbXCVJtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:49:25 -0400
Date: Thu, 22 Mar 2007 12:56:00 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] Fix lseek on /proc/kcore
Message-ID: <20070322095600.GA6816@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/proc/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -167,8 +167,9 @@ static loff_t proc_reg_llseek(struct fil
 	llseek = pde->proc_fops->llseek;
 	spin_unlock(&pde->pde_unload_lock);
 
-	if (llseek)
-		rv = llseek(file, offset, whence);
+	if (!llseek)
+		llseek = default_llseek;
+	rv = llseek(file, offset, whence);
 
 	spin_lock(&pde->pde_unload_lock);
 	pde->pde_users--;

