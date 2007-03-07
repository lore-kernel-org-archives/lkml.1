Return-Path: <linux-kernel-owner+w=401wt.eu-S1030181AbXCGO2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181AbXCGO2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030474AbXCGO2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:28:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030181AbXCGO2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:28:06 -0500
Subject: [GFS2] Fix bz 230143, incorrect flushing of rgrps [7/12]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1173277501.11001.752.camel@quoit.chygwyn.com>
References: <1173277501.11001.752.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Mar 2007 14:31:07 +0000
Message-Id: <1173277867.11001.766.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From cad5b9392754910ee7dbe551eb004010a864c882 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 28 Feb 2007 14:03:00 +0000
Subject: [PATCH] [GFS2] Fix bz 230143, incorrect flushing of rgrps

The below patch fixes a problem where we were not flushing rgrps
correctly. It only occurred in the specific case that a callback was
received for an rgrp which was dirty and when a journal log flush had
not already resulted in the rgrp being flushed anyway. This fixes Red
Hat bz 230143,

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 46af553..4221110 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -459,6 +459,8 @@ const struct gfs2_glock_operations gfs2_inode_glops = {
 };
 
 const struct gfs2_glock_operations gfs2_rgrp_glops = {
+	.go_xmote_th = meta_go_sync,
+	.go_drop_th = meta_go_sync,
 	.go_inval = meta_go_inval,
 	.go_demote_ok = rgrp_go_demote_ok,
 	.go_lock = rgrp_go_lock,
-- 
1.4.4.2



