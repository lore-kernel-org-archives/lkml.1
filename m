Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbZLaCXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbZLaCXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 21:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZLaCXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 21:23:19 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:40479 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZLaCXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 21:23:18 -0500
X-Authority-Analysis: v=1.0 c=1 a=f7fQcPUqutgA:10 a=rOUgymgbAAAA:8 a=20KFwNOVAAAA:8 a=L1R48PyKPDoFwxzuPTsA:9 a=SbemwMtWDMmYNdYgzKR4YbcAfC4A:4 a=jEp0ucaQiEUA:10
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
From: Jeff Layton <jlayton@redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: [PATCH] sunrpc: fix build-time warning
Date: Wed, 30 Dec 2009 21:23:15 -0500
Message-Id: <1262226195-27733-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 486bad2e40e938cd68fd853b7a9fa3115a9d3a4a introduced this warning
at build time on some 32-bit architectures:

net/sunrpc/auth_gss/auth_gss.c: In function 'gss_pipe_downcall':
net/sunrpc/auth_gss/auth_gss.c:660: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t

...fix it by changing the length modifier in the printk.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 net/sunrpc/auth_gss/auth_gss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 66cb89c..6de4f91 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -657,7 +657,7 @@ gss_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 			break;
 		default:
 			printk(KERN_CRIT "%s: bad return from "
-				"gss_fill_context: %ld\n", __func__, err);
+				"gss_fill_context: %Zd\n", __func__, err);
 			BUG();
 		}
 		goto err_release_msg;
-- 
1.6.5.2

