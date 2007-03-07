Return-Path: <linux-kernel-owner+w=401wt.eu-S1030528AbXCGObS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030528AbXCGObS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030500AbXCGObR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:31:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030474AbXCGObP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:31:15 -0500
Subject: [GFS2] Fix bz 229873, alternate test: assertion
	"!ip->i_inode.i_mapping->nrpages" failed [12/12]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1173277501.11001.752.camel@quoit.chygwyn.com>
References: <1173277501.11001.752.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Mar 2007 14:34:19 +0000
Message-Id: <1173278059.11001.776.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From c3f49bc209b28d2b5f82b78baaa827eb3a4d1891 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 7 Mar 2007 09:06:48 +0000
Subject: [PATCH] [GFS2] Fix bz 229873, alternate test: assertion "!ip->i_inode.i_mapping->nrpages" failed

The following removes an incorrect assertion from the GFS2 glops code. This
fixes Red Hat bz 229873. Thanks to Abhijith Das for testing the patch
and confirming the fix.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 4221110..39c8ae2 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -245,7 +245,6 @@ static void inode_go_inval(struct gfs2_glock *gl, int flags)
 
 	if (ip && S_ISREG(ip->i_inode.i_mode)) {
 		truncate_inode_pages(ip->i_inode.i_mapping, 0);
-		gfs2_assert_withdraw(GFS2_SB(&ip->i_inode), !ip->i_inode.i_mapping->nrpages);
 		clear_bit(GIF_PAGED, &ip->i_flags);
 	}
 }
-- 
1.4.4.2



