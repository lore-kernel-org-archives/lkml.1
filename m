Return-Path: <linux-kernel-owner+w=401wt.eu-S934419AbXGLNQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419AbXGLNQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764160AbXGLNQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:16:46 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:51748 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763205AbXGLNQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:16:45 -0400
X-Greylist: delayed 1034 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 09:16:45 EDT
Subject: Re: [PATCH 2/7] fallocate() implementation in i386, x86_64 and
	powerpc
From: David Patrick Quigley <dpquigl@tycho.nsa.gov>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       eparis@redhat.com, jmorris@namei.org, sds@tycho.nsa.gov
In-Reply-To: <20070710202000.GB8797@amitarora.in.ibm.com>
References: <20070710201200.GA10255@amitarora.in.ibm.com>
	 <20070710202000.GB8797@amitarora.in.ibm.com>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 08:56:30 -0400
Message-Id: <1184244990.18175.6.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David P. Quigley <dpquigl@tycho.nsa.gov>

Revalidate the write permissions for fallocate(2), in case security policy has
changed since the files were opened.

Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>

fs/open.c |    3 +++
1 file changed, 3 insertions(+)

diff -uprN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22-fallocate/fs/open.c linux-2.6.22-fallocate-selinux/fs/open.c
--- linux-2.6.22-fallocate/fs/open.c	2007-07-11 15:51:10.000000000 -0400
+++ linux-2.6.22-fallocate-selinux/fs/open.c	2007-07-11 16:10:43.000000000 -0400
@@ -411,6 +411,9 @@ asmlinkage long sys_fallocate(int fd, in
 		goto out;
 	if (!(file->f_mode & FMODE_WRITE))
 		goto out_fput;
+	ret = security_file_permission(file, MAY_WRITE);
+	if (ret)
+		goto out_fput;
 
 	inode = file->f_path.dentry->d_inode;

