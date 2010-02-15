Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0BOXH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 18:07:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756644Ab0BOXHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 18:07:55 -0500
Message-Id: <201002152307.o1FN7f10019719@int-mx02.intmail.prod.int.phx2.redhat.com>
Date: Mon, 15 Feb 2010 18:07:39 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] vfs: don't call ima_file_check() unconditionally in
 nfsd_open()
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>

vfs: don't call ima_file_check() unconditionally in nfsd_open()

commit 1e41568d7378d1ba8c64ba137b9ddd00b59f893a ("Take ima_path_check()
in nfsd past dentry_open() in nfsd_open()") moved this code back to its
original location but missed the "else".

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

--- linux-2.6.32.noarch.orig/fs/nfsd/vfs.c
+++ linux-2.6.32.noarch/fs/nfsd/vfs.c
@@ -752,7 +752,8 @@ nfsd_open(struct svc_rqst *rqstp, struct
 			    flags, current_cred());
 	if (IS_ERR(*filp))
 		host_err = PTR_ERR(*filp);
-	host_err = ima_file_check(*filp, access);
+	else
+		host_err = ima_file_check(*filp, access);
 out_nfserr:
 	err = nfserrno(host_err);
 out:
