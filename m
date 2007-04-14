Return-Path: <linux-kernel-owner+w=401wt.eu-S1030672AbXDNIrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672AbXDNIrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 04:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030817AbXDNIrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 04:47:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:41098 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030672AbXDNIrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 04:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=qnEKJHaIoi/O5q4sBAi9eFdDeUkh51S+70/dve0dJw9paaepaBKkMYzSpXMkIGHKKgrpav7G79OmxOJVeMSoiw3l5dbm1yir8EWEyQJdh8xzaf1HP1ZF00sOuup2CxKBIjAWT4G6znt3hdF9ROv8jwFK/CmkepJIfgMWpRyZ4G0=
Date: Sat, 14 Apr 2007 14:19:56 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org, nfs@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       trond.myklebust@fys.uio.no
Subject: [KJ][PATCH 03/04]use set_current_state in fs
Message-ID: <20070414084956.GD14084@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use set_current_state(TASK_*) instead of current->state = TASK_*, in fs/nfs

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>


---
 idmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index 9d4a6b2..054ca15 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -272,7 +272,7 @@ nfs_idmap_id(struct idmap *idmap, struct idmap_hashtable *h,
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	mutex_unlock(&idmap->idmap_im_lock);
 	schedule();
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&idmap->idmap_wq, &wq);
 	mutex_lock(&idmap->idmap_im_lock);
 
@@ -333,7 +333,7 @@ nfs_idmap_name(struct idmap *idmap, struct idmap_hashtable *h,
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	mutex_unlock(&idmap->idmap_im_lock);
 	schedule();
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&idmap->idmap_wq, &wq);
 	mutex_lock(&idmap->idmap_im_lock);
 
-- 
Milind Arun Choudhary
