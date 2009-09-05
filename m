Return-Path: <linux-kernel-owner+w=401wt.eu-S933867AbZIEAcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867AbZIEAcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933637AbZIEAco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:32:44 -0400
Received: from kroah.org ([198.145.64.141]:42110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934570AbZIEAUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:50 2009
Message-Id: <20090905001450.075904809@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 17/71] SUNRPC: Fix rpc_task_force_reencode
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=sunrpc-fix-rpc_task_force_reencode.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2574cc9f4ffc6c681c9177111357efe5b76f0e36 upstream.

This patch fixes the bug that was reported in
  http://bugzilla.kernel.org/show_bug.cgi?id=14053

If we're in the case where we need to force a reencode and then resend of
the RPC request, due to xprt_transmit failing with a networking error, then
we _must_ retransmit the entire request.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/clnt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -876,6 +876,7 @@ static inline void
 rpc_task_force_reencode(struct rpc_task *task)
 {
 	task->tk_rqstp->rq_snd_buf.len = 0;
+	task->tk_rqstp->rq_bytes_sent = 0;
 }
 
 static inline void


