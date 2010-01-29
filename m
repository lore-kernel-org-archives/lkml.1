Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883Ab0A2Kg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab0A2Kg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927Ab0A2Kg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:36:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61805 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0A2Kg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:36:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=t/MEPVZF/D37skOFLJYyRb3dWJCQ57Cj2DWltVokG0Xyi20NK/51o11QYpXHKmtHR0
         eL7iJj16kRhpdmA2kRG5X+FHOjNyCACl9f+hiKdbL9emM0ySW+6WMCCUwTOfS6Clc1mg
         sHwfCWrecsruwyNYGROLqyRKok8ReAC6qmcp4=
Message-ID: <4B62BB83.7030907@gmail.com>
Date: Fri, 29 Jan 2010 11:42:11 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Btrfs: make error return negative in btrfs_sync_file()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears the error return should be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
But I fail to see how ret can be positive, unless maybe when we already
did a BUG()?

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c020335..9d08096 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1133,7 +1133,7 @@ int btrfs_sync_file(struct file *file, struct dentry *dentry, int datasync)
 	}
 	mutex_lock(&dentry->d_inode->i_mutex);
 out:
-	return ret > 0 ? EIO : ret;
+	return ret > 0 ? -EIO : ret;
 }
 
 static const struct vm_operations_struct btrfs_file_vm_ops = {
