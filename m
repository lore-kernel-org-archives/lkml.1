Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbZH1PNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbZH1PNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 11:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZH1PNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 11:13:24 -0400
Received: from mx2.netapp.com ([216.240.18.37]:2909 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbZH1PNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 11:13:23 -0400
X-IronPort-AV: E=Sophos;i="4.44,291,1249282800"; 
   d="scan'208";a="233230387"
Subject: SUNRPC: Fix rpc_task_force_reencode
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, stable <stable@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Fri, 28 Aug 2009 11:12:12 -0400
Message-Id: <1251472332.4844.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 28 Aug 2009 15:13:09.0180 (UTC) FILETIME=[0D46E7C0:01CA27F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the bug that was reported in
  http://bugzilla.kernel.org/show_bug.cgi?id=14053

If we're in the case where we need to force a reencode and then resend of
the RPC request, due to xprt_transmit failing with a networking error, then
we _must_ retransmit the entire request.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
Please apply to mainline and stable

 net/sunrpc/clnt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index c1e467e..fac0ca9 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -955,6 +955,7 @@ static inline void
 rpc_task_force_reencode(struct rpc_task *task)
 {
 	task->tk_rqstp->rq_snd_buf.len = 0;
+	task->tk_rqstp->rq_bytes_sent = 0;
 }
 
 static inline void

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
