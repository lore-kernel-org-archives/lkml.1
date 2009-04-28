Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZD1EYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZD1EYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 00:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZD1EX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 00:23:58 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:39520 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZD1EX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 00:23:58 -0400
Message-ID: <49F684FC.7030403@oracle.com>
Date: Mon, 27 Apr 2009 21:24:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mmotm] ecryptfs: fix printk format warning
References: <200904272305.n3RN51mu031395@imap1.linux-foundation.org>
In-Reply-To: <200904272305.n3RN51mu031395@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.49F684AF.0002:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

fs/ecryptfs/inode.c:670: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/ecryptfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2009-0427-1545.orig/fs/ecryptfs/inode.c
+++ mmotm-2009-0427-1545/fs/ecryptfs/inode.c
@@ -667,7 +667,7 @@ ecryptfs_readlink(struct dentry *dentry,
 	lower_buf = kmalloc(lower_bufsiz, GFP_KERNEL);
 	if (lower_buf == NULL) {
 		printk(KERN_ERR "%s: Out of memory whilst attempting to "
-		       "kmalloc [%d] bytes\n", __func__, lower_bufsiz);
+		       "kmalloc [%zd] bytes\n", __func__, lower_bufsiz);
 		rc = -ENOMEM;
 		goto out;
 	}
