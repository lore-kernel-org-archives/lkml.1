Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbXL1Uq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbXL1Uq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXL1Un4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:43:56 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37127 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbXL1Unp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:45 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 23/30] Unionfs: set our superblock a/m/ctime granularity
Date: Fri, 28 Dec 2007 15:42:57 -0500
Message-Id: <11988745962938-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set it to 1 ns, because we could be stacked on top of file systems with such
granularity.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/main.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 92f0e9d..23c18f7 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -642,6 +642,13 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 	/* max Bytes is the maximum bytes from highest priority branch */
 	sb->s_maxbytes = unionfs_lower_super_idx(sb, 0)->s_maxbytes;
 
+	/*
+	 * Our c/m/atime granularity is 1 ns because we may stack on file
+	 * systems whose granularity is as good.  This is important for our
+	 * time-based cache coherency.
+	 */
+	sb->s_time_gran = 1;
+
 	sb->s_op = &unionfs_sops;
 
 	/* See comment next to the definition of unionfs_d_alloc_root */
-- 
1.5.2.2

