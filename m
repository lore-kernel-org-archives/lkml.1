Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965295Ab0CMBgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:36:35 -0500
Received: from kroah.org ([198.145.64.141]:60528 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934779Ab0CMATe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:34 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:05 2010
Message-Id: <20100313001505.594170518@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Xiaotian Feng <dfeng@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [patch 005/123] security: fix error return path in ima_inode_alloc
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Xiaotian Feng <dfeng@redhat.com>

commit baac35c4155a8aa826c70acee6553368ca5243a2 upstream.

If radix_tree_preload is failed in ima_inode_alloc, we don't need
radix_tree_preload_end because kernel is alread preempt enabled

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/integrity/ima/ima_iint.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -63,12 +63,11 @@ int ima_inode_alloc(struct inode *inode)
 	spin_lock(&ima_iint_lock);
 	rc = radix_tree_insert(&ima_iint_store, (unsigned long)inode, iint);
 	spin_unlock(&ima_iint_lock);
+	radix_tree_preload_end();
 out:
 	if (rc < 0)
 		kmem_cache_free(iint_cache, iint);
 
-	radix_tree_preload_end();
-
 	return rc;
 }
 


