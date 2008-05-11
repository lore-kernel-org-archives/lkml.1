Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbYEKUIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbYEKUIF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbYEKUHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:07:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:57969 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183AbYEKUHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Qh4lx0+AJyu4XM3yHNiB3Y/9RnYiWNvSMSHrT40qIv3YCAAKR/th87LqB/adFJh5n8zPimHPn/y1Csi5Lgt/h8pZ7ry2zxZDcyKjiHYICMc/987e+QSPZlQfNXpb5r/mHqDOOLjP1oj2nCbhbkfUDrYw6vDLqL1F31DOAbR8Gts=
Date: Sun, 11 May 2008 22:07:25 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tom Tucker <tom@opengridcomputing.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH] net/sunrpc/xprtrdma: fix svc_rdma_create out of memory
	error path
Message-ID: <20080511200719.GM19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERR_PTR takes negative errno as a parameter

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Tom Tucker <tom@opengridcomputing.com>
Cc: J. Bruce Fields <bfields@citi.umich.edu>
---
compile tested only
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -661,7 +661,7 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
 
 	cma_xprt = rdma_create_xprt(serv, 1);
 	if (!cma_xprt)
-		return ERR_PTR(ENOMEM);
+		return ERR_PTR(-ENOMEM);
 	xprt = &cma_xprt->sc_xprt;
 
 	listen_id = rdma_create_id(rdma_listen_handler, cma_xprt, RDMA_PS_TCP);
-- 
