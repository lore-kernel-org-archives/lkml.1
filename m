Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbXGMMsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbXGMMsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbXGMMsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:48:33 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60648 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbXGMMsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:48:32 -0400
Date: Fri, 13 Jul 2007 18:18:47 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Cc: xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com,
       adilger@clusterfs.com, dgc@sgi.com
Subject: [PATCH 3/6][TAKE7] revalidate write permissions for fallocate
Message-ID: <20070713124847.GC22961@amitarora.in.ibm.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713123816.GA18000@amitarora.in.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David P. Quigley <dpquigl@tycho.nsa.gov>

Revalidate the write permissions for fallocate(2), in case security policy has
changed since the files were opened.

Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>

---
 fs/open.c |    3 +++
 1 files changed, 3 insertions(+)

Index: linux-2.6.22/fs/open.c
===================================================================
--- linux-2.6.22.orig/fs/open.c
+++ linux-2.6.22/fs/open.c
@@ -407,6 +407,9 @@ asmlinkage long sys_fallocate(int fd, in
 		goto out;
 	if (!(file->f_mode & FMODE_WRITE))
 		goto out_fput;
+	ret = security_file_permission(file, MAY_WRITE);
+	if (ret)
+		goto out_fput;
 
 	inode = file->f_path.dentry->d_inode;
 
