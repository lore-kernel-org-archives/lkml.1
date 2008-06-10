Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbYFJMyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbYFJMyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYFJMyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:54:13 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2699 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560AbYFJMyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:54:08 -0400
Date: Tue, 10 Jun 2008 08:53:39 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, nhorman@tuxdriver.com, torvalds@linux-foundation.org
Subject: [PATCH] shm: Remove silly double assignment
Message-ID: <20080610125338.GB3165@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Found a silly double assignment of err is do_shmat.  Silly, but good to clean up
    the useless code.
    
    Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

diff --git a/ipc/shm.c b/ipc/shm.c
index 554429a..d05f6b5 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -894,8 +894,6 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
 	if (!sfd)
 		goto out_put_dentry;
 
-	err = -ENOMEM;
-
 	file = alloc_file(path.mnt, path.dentry, f_mode, &shm_file_operations);
 	if (!file)
 		goto out_free;
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
