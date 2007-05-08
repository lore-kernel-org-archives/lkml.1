Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbXEHSvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbXEHSvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXEHSvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:51:49 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:26496 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754846AbXEHSvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:51:46 -0400
X-YMail-OSG: xmHNghUVM1lgxVcRoK3YDECj4vQa1XEXczP0xed5I7WJQiUQvXW2hAggMWSINS1kYXUEup_PkQ--
From: Chris Wedgwood <cw@f00f.org>
Date: Tue, 8 May 2007 11:29:26 -0700
Subject: [PATCH] Type cast some size_t arguments to 'unsigned int' to avoid (harmless) gcc printk warnings.
To: linux-kernel@vger.kernel.org
Message-Id: <20070508185142.9ED501827261@tuatara.stupidest.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Wedgwood <cw@f00f.org>
---
 net/sunrpc/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 4a53e94..60df3c1 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -764,7 +764,7 @@ void *rpc_malloc(struct rpc_task *task, size_t size)
 		buf = kmalloc(size, gfp);
 	*buf = size;
 	dprintk("RPC: %5u allocated buffer of size %u at %p\n",
-			task->tk_pid, size, buf);
+			task->tk_pid, (unsigned int)size, buf);
 	return (void *) ++buf;
 }
 
@@ -783,7 +783,7 @@ void rpc_free(void *buffer)
 	buf--;
 
 	dprintk("RPC:       freeing buffer of size %u at %p\n",
-			size, buf);
+			(unsigned int)size, buf);
 	if (size <= RPC_BUFFER_MAXSIZE)
 		mempool_free(buf, rpc_buffer_mempool);
 	else
-- 
1.5.1.3

