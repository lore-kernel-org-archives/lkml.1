Return-Path: <linux-kernel-owner+w=401wt.eu-S1762032AbXKQEeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032AbXKQEeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 23:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbXKQEd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 23:33:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:45942 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbXKQEd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 23:33:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=GUII8Kgm8gguAc0K2VPrKQEZd3zWJtp6gX/eM8ZnPm8LkJ+vtaYAtbjvwXwgBMhrKi471xQ5n1451k2bSYFEsj2IrQh9Kktbz9X+ggj/CvwiuFY5/cBRgq+lpsR4YGqDz2S5HwsMfYiuGJvPZ3wKnvgt02fpJrwx2+/1D/JlN30=
Date: Sat, 17 Nov 2007 13:28:01 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fs: use hlist_unhashed
Message-ID: <20071117042801.GA4580@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use hlist_unhashed() instead of opencoded equivalent.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6-mm/fs/dcache.c
===================================================================
--- 2.6-mm.orig/fs/dcache.c
+++ 2.6-mm/fs/dcache.c
@@ -89,7 +89,7 @@ static void d_free(struct dentry *dentry
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 	/* if dentry was never inserted into hash, immediate free is OK */
-	if (dentry->d_hash.pprev == NULL)
+	if (hlist_unhashed(&dentry->d_hash))
 		__d_free(dentry);
 	else
 		call_rcu(&dentry->d_u.d_rcu, d_callback);
