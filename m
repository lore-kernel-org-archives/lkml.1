Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbZC3UdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbZC3UdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbZC3Uc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:32:57 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:11706 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZC3Uc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:32:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qAsRIGtT/EeEY6t8Ln4/9sUE3iabyJsbFQ9cTh1gXzgHRD1nyXyuot4cjog8PfqpLE
         X37TtutdsKXYWr6hP5jYJFbw/iuWmXbXe7L7F9HqzyvzZkDGVjKaf7dHle+YBBptfKSC
         DMIStY9pxDGj+vRIOt4vvYtrLoRGaKNzioqU8=
Date: Tue, 31 Mar 2009 00:32:40 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [PATCH] reiserfs: fix build breakage
Message-ID: <20090330203240.GA19456@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/reiserfs/inode.c: In function 'reiserfs_new_inode':
fs/reiserfs/inode.c:1919: warning: passing argument 1 of
'reiserfs_inherit_default_acl' from incompatible pointer type
fs/reiserfs/inode.c:1919: warning: passing argument 2 of
'reiserfs_inherit_default_acl' from incompatible pointer type
fs/reiserfs/inode.c:1919: warning: passing argument 3 of
'reiserfs_inherit_default_acl' from incompatible pointer type
fs/reiserfs/inode.c:1919: error: too many arguments to function
'reiserfs_inherit_default_acl'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 include/linux/reiserfs_acl.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/reiserfs_acl.h b/include/linux/reiserfs_acl.h
index 52240e0..8cc6575 100644
--- a/include/linux/reiserfs_acl.h
+++ b/include/linux/reiserfs_acl.h
@@ -80,7 +80,8 @@ static inline int reiserfs_acl_chmod(struct inode *inode)
 }
 
 static inline int
-reiserfs_inherit_default_acl(const struct inode *dir, struct dentry *dentry,
+reiserfs_inherit_default_acl(struct reiserfs_transaction_handle *th,
+			     const struct inode *dir, struct dentry *dentry,
 			     struct inode *inode)
 {
 	return 0;
