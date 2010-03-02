Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0CBICj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 03:02:39 -0500
Received: from tundra.namei.org ([65.99.196.166]:47655 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab0CBICh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 03:02:37 -0500
Date: Tue, 2 Mar 2010 19:02:22 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
       Alex Elder <aelder@sgi.com>, Chris Mason <chris.mason@oracle.com>,
       a.gruenbacher@computer.org
Subject: [PATCH 2/2] ocfs2: ensure trusted xattrs are not returned to
 unprivileged users via listxattr
In-Reply-To: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org>
Message-ID: <alpine.LRH.2.00.1003021901530.1594@tundra.namei.org>
References: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that trusted xattrs are not returned to unprivileged users
via listxattr, in keeping with several other implmentations, such
as ext3.

Signed-off-by: James Morris <jmorris@namei.org>
---
 fs/ocfs2/xattr.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 8fc6fb0..da98448 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7077,6 +7077,9 @@ static size_t ocfs2_xattr_trusted_list(struct dentry *dentry, char *list,
 	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return 0;
+
 	if (list && total_len <= list_size) {
 		memcpy(list, XATTR_TRUSTED_PREFIX, prefix_len);
 		memcpy(list + prefix_len, name, name_len);
-- 
1.6.3.3

