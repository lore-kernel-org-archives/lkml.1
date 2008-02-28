Return-Path: <linux-kernel-owner+w=401wt.eu-S1763072AbYB1WMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763072AbYB1WMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760027AbYB1WL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:11:57 -0500
Received: from mx1.riseup.net ([204.13.164.18]:45055 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664AbYB1WL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:11:56 -0500
Date: Thu, 28 Feb 2008 23:11:45 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] fs/inode.c: use hlist_for_each_entry()
Message-ID: <20080228221145.GA5720@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/inode.c: use hlist_for_each_entry() in find_inode() and
find_inode_fast()

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

diff --git a/fs/inode.c b/fs/inode.c
index 53245ff..ab5dfc2 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -495,8 +495,7 @@ static struct inode * find_inode(struct super_block * sb, struct hlist_head *hea
 	struct inode * inode = NULL;
 
 repeat:
-	hlist_for_each (node, head) { 
-		inode = hlist_entry(node, struct inode, i_hash);
+	hlist_for_each_entry (inode, node, head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
 		if (!test(inode, data))
@@ -520,8 +519,7 @@ static struct inode * find_inode_fast(struct super_block * sb, struct hlist_head
 	struct inode * inode = NULL;
 
 repeat:
-	hlist_for_each (node, head) {
-		inode = hlist_entry(node, struct inode, i_hash);
+	hlist_for_each_entry (inode, node, head, i_hash) {
 		if (inode->i_ino != ino)
 			continue;
 		if (inode->i_sb != sb)

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

     The assumption that what currently exists must necessarily
      exist is the acid that corrodes all visionary thinking
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
