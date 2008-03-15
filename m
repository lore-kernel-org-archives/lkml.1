Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYCOQDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYCOQDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 12:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYCOQDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 12:03:23 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:42262 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbYCOQDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 12:03:00 -0400
Date: Sat, 15 Mar 2008 17:02:58 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/7] net/9p/trans_fd.c: remove unused variable
Message-ID: <Pine.LNX.4.64.0803151702380.24178@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable cb is initialized but never used otherwise.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier i;
constant C;
@@

(
extern T i;
|
- T i;
  <+... when != i
- i = C;
  ...+>
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 net/9p/trans_fd.c |    2 --
 1 file changed, 2 deletions(-)

diff -u -p a/net/9p/trans_fd.c b/net/9p/trans_fd.c
--- a/net/9p/trans_fd.c 2008-03-12 14:13:15.000000000 +0100
+++ b/net/9p/trans_fd.c 2008-03-15 07:27:23.000000000 +0100
@@ -861,7 +861,6 @@ static void p9_mux_free_request(struct p
 
 static void p9_mux_flush_cb(struct p9_req *freq, void *a)
 {
-	p9_conn_req_callback cb;
 	int tag;
 	struct p9_conn *m;
 	struct p9_req *req, *rreq, *rptr;
@@ -872,7 +871,6 @@ static void p9_mux_flush_cb(struct p9_re
 		freq->tcall->params.tflush.oldtag);
 
 	spin_lock(&m->lock);
-	cb = NULL;
 	tag = freq->tcall->params.tflush.oldtag;
 	req = NULL;
 	list_for_each_entry_safe(rreq, rptr, &m->req_list, req_list) {
