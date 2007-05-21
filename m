Return-Path: <linux-kernel-owner+w=401wt.eu-S933769AbXEUT1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbXEUT1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765379AbXEUTVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:33 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46348 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765336AbXEUTV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:27 -0400
Message-Id: <20070521191701.006984000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, tiwai@suse.de,
       adaplas@pol.net, jeffm@suse.de
Subject: [patch 06/69] reiserfs: suppress lockdep warning
Content-Disposition: inline; filename=reiserfs-suppress-lockdep-warning.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jeff Mahoney <jeffm@suse.de>

We're getting lockdep warnings due to a post-2.6.21-rc7 bugfix.

The xattr_sem can never be taken in the manner described. Internal inodes
are protected by I_PRIVATE.  Add the appropriate annotation.

Cc: <stable@kernel.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 fs/reiserfs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.1.orig/fs/reiserfs/xattr.c
+++ linux-2.6.21.1/fs/reiserfs/xattr.c
@@ -68,7 +68,7 @@ static struct dentry *get_xa_root(struct
 	if (!privroot)
 		return ERR_PTR(-ENODATA);
 
-	mutex_lock(&privroot->d_inode->i_mutex);
+	mutex_lock_nested(&privroot->d_inode->i_mutex, I_MUTEX_XATTR);
 	if (REISERFS_SB(sb)->xattr_root) {
 		xaroot = dget(REISERFS_SB(sb)->xattr_root);
 		goto out;

-- 
