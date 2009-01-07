Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbZAGKPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbZAGKPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 05:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZAGKOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 05:14:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48223 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZAGKOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 05:14:38 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/3] GFS2: Set GFP_NOFS when allocating page on write
Date: Wed,  7 Jan 2009 09:16:22 +0000
Message-Id: <1231319784-18695-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1231319784-18695-1-git-send-email-swhiteho@redhat.com>
References: <1231319784-18695-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to ensure that we always set GFP_NOFS in this one
particular case when allocating pages for write.

Reported-by: Fabio M. Di Nitto <fdinitto@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 6e4ea36..4ddab67 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -675,6 +675,7 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 		goto out_trans_fail;
 
 	error = -ENOMEM;
+	flags |= AOP_FLAG_NOFS;
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	*pagep = page;
 	if (unlikely(!page))
-- 
1.6.0.3

