Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbXLKWVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbXLKWVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbXLKWVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:21:12 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38482 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755949AbXLKWVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:21:10 -0500
Date: Tue, 11 Dec 2007 23:21:11 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Chuck Lever <chuck.lever@oracle.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/nfs/direct.c: remove dead code
Message-ID: <20071211222111.GF14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code became dead after commit b9148c6b80d802dbc2a7530b29915a80432e50c7
(which BTW doesn't seem to have changed any behaviour) and can therefore 
be removed.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/fs/nfs/direct.c.old	2007-12-02 21:54:53.000000000 +0100
+++ linux-2.6/fs/nfs/direct.c	2007-12-02 21:55:10.000000000 +0100
@@ -897,15 +897,12 @@ ssize_t nfs_file_direct_write(struct kio
 	if (!count)
 		goto out;	/* return 0 */
 
 	retval = -EINVAL;
 	if ((ssize_t) count < 0)
 		goto out;
-	retval = 0;
-	if (!count)
-		goto out;
 
 	retval = nfs_sync_mapping(mapping);
 	if (retval)
 		goto out;
 
 	retval = nfs_direct_write(iocb, iov, nr_segs, pos, count);

