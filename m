Return-Path: <linux-kernel-owner+w=401wt.eu-S1763409AbYEIMm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763409AbYEIMm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbYEIMlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:41:32 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59642 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbYEIMla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:41:30 -0400
Message-Id: <20080509124127.179314495@szeredi.hu>
References: <20080509124107.645600519@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 09 May 2008 14:41:08 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: [patch 1/9] lockd: dont return EAGAIN from blocking lock request
Content-Disposition: inline; filename=lockd_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

EAGAIN does not make sense as a return value from a blocking lock
request, the lock should be retried by the kernel until either it is
successful or fails permanently.

Looking at the server side NLM_LCK_DENIED means a permanent error in
this case, so just turn this into an ENOLCK.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: "J. Bruce Fields" <bfields@fieldses.org>
---
 fs/lockd/clntproc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/lockd/clntproc.c
===================================================================
--- linux-2.6.orig/fs/lockd/clntproc.c	2008-05-09 14:04:16.000000000 +0200
+++ linux-2.6/fs/lockd/clntproc.c	2008-05-09 14:04:46.000000000 +0200
@@ -808,7 +808,7 @@ nlm_stat_to_errno(__be32 status)
 	case NLM_LCK_GRANTED:
 		return 0;
 	case NLM_LCK_DENIED:
-		return -EAGAIN;
+		return -ENOLCK;
 	case NLM_LCK_DENIED_NOLOCKS:
 	case NLM_LCK_DENIED_GRACE_PERIOD:
 		return -ENOLCK;

--
