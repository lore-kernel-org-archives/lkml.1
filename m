Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZCERuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZCERuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 12:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbZCERt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 12:49:59 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:40833 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbZCERt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 12:49:58 -0500
Date: Thu, 5 Mar 2009 11:49:51 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>, Dave Hansen <haveblue@us.ibm.com>
Cc: Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] checkpoint: define pid==0 as self-checkpoint
Message-ID: <20090305174951.GA9782@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ this is on top of Dave's version of Oren's patchset, i.e.
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/daveh/linux-2.6-cr.git;a=shortlog;h=dave-v13.4 ]

Define pid=0 when calling sys_checkpoint as asking for
a self-checkpoint.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 checkpoint/sys.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/checkpoint/sys.c b/checkpoint/sys.c
index 4a51ed3..acc5121 100644
--- a/checkpoint/sys.c
+++ b/checkpoint/sys.c
@@ -224,6 +224,8 @@ asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags)
 	if (flags)
 		return -EINVAL;
 
+	if (pid == 0)
+		pid = current->pid;
 	ctx = cr_ctx_alloc(fd, flags | CR_CTX_CKPT);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
-- 
1.5.4.3

