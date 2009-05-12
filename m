Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbZELAsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbZELAsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZELAsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:48:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37852 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256AbZELAsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:48:31 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] securityfs: securityfs_remove should handle IS_ERR pointers
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 11 May 2009 20:47:15 -0400
Message-ID: <20090512004714.4111.46789.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both of the securityfs users (TPM and IMA) can call securityfs_remove and pass
an IS_ERR(dentry) in their failure paths.  This patch handles those rather
than panicing when it tries to start deferencing some negative memory.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/inode.c b/security/inode.c
index f3b91bf..f7496c6 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -287,7 +287,7 @@ void securityfs_remove(struct dentry *dentry)
 {
 	struct dentry *parent;
 
-	if (!dentry)
+	if (!dentry || IS_ERR(dentry))
 		return;
 
 	parent = dentry->d_parent;

