Return-Path: <linux-kernel-owner+w=401wt.eu-S1030198AbXCGO2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030198AbXCGO2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030501AbXCGO2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:28:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030500AbXCGO2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:28:38 -0500
Subject: [GFS2] Fix bz 229831, lookup returns wrong inode [8/12]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1173277501.11001.752.camel@quoit.chygwyn.com>
References: <1173277501.11001.752.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Mar 2007 14:31:44 +0000
Message-Id: <1173277904.11001.768.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1be3867955731b5cb2dc14060cc46f0882e87873 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Thu, 1 Mar 2007 10:00:53 +0000
Subject: [PATCH] [GFS2] Fix bz 229831, lookup returns wrong inode

The following patch fixes Red Hat bz 229831. Without this patch its
possible for the wrong inode to be returned in certain cases. It is a
pretty unusual event, so that its taken some time to track down. Thanks
and due to Josef Whiter who did a lot of the testing required to thrack
this down and fix it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 902dd81..df0b8b3 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -43,7 +43,8 @@ static int iget_test(struct inode *inode, void *opaque)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_inum_host *inum = opaque;
 
-	if (ip->i_num.no_addr == inum->no_addr)
+	if (ip->i_num.no_addr == inum->no_addr &&
+	    inode->i_private != NULL)
 		return 1;
 
 	return 0;
-- 
1.4.4.2



