Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbYBIACb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbYBIACb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbYBIACM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:02:12 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:60938 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751AbYBIACK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:02:10 -0500
To: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Tom Tucker <tom@opengridcomputing.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] SUNPRC: Fix printk format warning
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 08 Feb 2008 16:02:04 -0800
Message-ID: <aday79v0zgj.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Feb 2008 00:02:04.0816 (UTC) FILETIME=[00F86900:01C86AAF]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net/sunrpc/xprtrdma/svc_rdma_sendto.c:160: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'u64'

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index 3e32194..4b913e7 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -159,7 +159,7 @@ static int send_write(struct svcxprt_rdma *xprt, struct svc_rqst *rqstp,
 	BUG_ON(sge_count >= 32);
 	dprintk("svcrdma: RDMA_WRITE rmr=%x, to=%llx, xdr_off=%d, "
 		"write_len=%d, xdr_sge=%p, sge_count=%d\n",
-		rmr, to, xdr_off, write_len, xdr_sge, sge_count);
+		rmr, (unsigned long long) to, xdr_off, write_len, xdr_sge, sge_count);
 
 	ctxt = svc_rdma_get_context(xprt);
 	ctxt->count = 0;
