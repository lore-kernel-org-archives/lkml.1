Return-Path: <linux-kernel-owner+w=401wt.eu-S1761012AbYAUKHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761012AbYAUKHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbYAUKCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759453AbYAUKCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:13 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/58] [GFS2] Add sync_page to metadata address space operations
Date: Mon, 21 Jan 2008 09:21:32 +0000
Message-Id: <12009073662309-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073642512-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
Message-Id: <c22f2c89becb248eb154146a842b1b158dbc291e.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This set of address space operations was missing a sync_page
operation.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 01ef902..4b1aced 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -50,6 +50,7 @@ static int gfs2_aspace_writepage(struct page *page,
 static const struct address_space_operations aspace_aops = {
 	.writepage = gfs2_aspace_writepage,
 	.releasepage = gfs2_releasepage,
+	.sync_page = block_sync_page,
 };
 
 /**
-- 
1.5.1.2

