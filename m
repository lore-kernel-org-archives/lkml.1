Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZG1X7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZG1X7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZG1Xtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:53 -0400
Received: from kroah.org ([198.145.64.141]:35710 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbZG1Xtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:54 2009
Message-Id: <20090728234154.259631161@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [patch 20/71] cifs: free nativeFileSystem field before allocating a new one
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=cifs-free-nativefilesystem-field-before-allocating-a-new-one.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 90a98b2f3f3647fb17667768a348b2b219f2a9f7 upstream.

...otherwise, we'll leak this memory if we have to reconnect (e.g. after
network failure).

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2745,6 +2745,7 @@ CIFSTCon(unsigned int xid, struct cifsSe
 		strncpy(tcon->treeName, tree, MAX_TREE_SIZE);
 
 		/* mostly informational -- no need to fail on error here */
+		kfree(tcon->nativeFileSystem);
 		tcon->nativeFileSystem = cifs_strndup_from_ucs(bcc_ptr,
 						      bytes_left, is_unicode,
 						      nls_codepage);


