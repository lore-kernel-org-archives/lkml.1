Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbYH0Nue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbYH0Nue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbYH0Nrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:47:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594AbYH0Nrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:47:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/59] CRED: Wrap task credential accesses in the ISDN drivers
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Karsten Keil <kkeil@suse.de>,
       isdn4linux@listserv.isdn4linux.de
Date: Wed, 27 Aug 2008 14:46:33 +0100
Message-ID: <20080827134633.19980.81789.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Karsten Keil <kkeil@suse.de>
Cc: isdn4linux@listserv.isdn4linux.de
---

 drivers/isdn/capi/capifs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/isdn/capi/capifs.c b/drivers/isdn/capi/capifs.c
index 550e80f..0aa66ec 100644
--- a/drivers/isdn/capi/capifs.c
+++ b/drivers/isdn/capi/capifs.c
@@ -156,8 +156,8 @@ void capifs_new_ncci(unsigned int number, dev_t device)
 	if (!inode)
 		return;
 	inode->i_ino = number+2;
-	inode->i_uid = config.setuid ? config.uid : current->fsuid;
-	inode->i_gid = config.setgid ? config.gid : current->fsgid;
+	inode->i_uid = config.setuid ? config.uid : current_fsuid();
+	inode->i_gid = config.setgid ? config.gid : current_fsgid();
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	init_special_inode(inode, S_IFCHR|config.mode, device);
 	//inode->i_op = &capifs_file_inode_operations;

