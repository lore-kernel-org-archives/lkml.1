Return-Path: <linux-kernel-owner+w=401wt.eu-S1761027AbYDQBbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027AbYDQBbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761204AbYDQBKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:10:08 -0400
Received: from sous-sol.org ([216.99.217.87]:59035 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760874AbYDQBKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:10:07 -0400
Message-Id: <20080417010354.950049854@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Chuck Lever <chuck.lever@oracle.com>
Subject: SUNRPC: Fix a memory leak in rpc_create()
Content-Disposition: inline; filename=sunrpc-fix-a-memory-leak-in-rpc_create.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Chuck Lever <chuck.lever@oracle.com>

upstream commit: ed13c27e546667fb0967ae30f5070cd7f6455f90

Commit 510deb0d was supposed to move the xprt_create_transport() call in
rpc_create(), but neglected to remove the old call site.  This resulted in
a transport leak after every rpc_create() call.

This leak is present in 2.6.24 and 2.6.25.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 net/sunrpc/clnt.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -249,10 +249,6 @@ struct rpc_clnt *rpc_create(struct rpc_c
 	};
 	char servername[20];
 
-	xprt = xprt_create_transport(&xprtargs);
-	if (IS_ERR(xprt))
-		return (struct rpc_clnt *)xprt;
-
 	/*
 	 * If the caller chooses not to specify a hostname, whip
 	 * up a string representation of the passed-in address.

-- 
