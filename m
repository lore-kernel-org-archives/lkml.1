Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYDMWoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYDMWoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYDMWnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:43:43 -0400
Received: from smtp05.mtu.ru ([62.5.255.52]:57159 "EHLO smtp05.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbYDMWnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:43:42 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] 9p: four functions can become static
Date: Mon, 14 Apr 2008 02:43:45 +0400
Message-Id: <1208126626-25838-2-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1208126626-25838-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1208126626-25838-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp05.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following functions can become static:

p9_client_rpc()
p9_fd_rpc()
p9_conn_rpcnb()
p9_conn_cancel()

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 net/9p/client.c   |    2 +-
 net/9p/trans_fd.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 84e087e..0a20095 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -117,7 +117,7 @@ static void parse_opts(char *options, struct p9_client *clnt)
  * @tc: request to be sent
  * @rc: pointer where a pointer to the response is stored
  */
-int
+static int
 p9_client_rpc(struct p9_client *c, struct p9_fcall *tc,
 	struct p9_fcall **rc)
 {
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index f624dff..7ec221f 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -965,7 +965,7 @@ p9_conn_rpc_cb(struct p9_req *req, void *a)
  * @tc: request to be sent
  * @rc: pointer where a pointer to the response is stored
  */
-int
+static int
 p9_fd_rpc(struct p9_trans *t, struct p9_fcall *tc, struct p9_fcall **rc)
 {
 	struct p9_trans_fd *p = t->priv;
@@ -1043,7 +1043,7 @@ p9_fd_rpc(struct p9_trans *t, struct p9_fcall *tc, struct p9_fcall **rc)
  * @cb: callback function to be called when response arrives
  * @cba: value to pass to the callback function
  */
-int p9_conn_rpcnb(struct p9_conn *m, struct p9_fcall *tc,
+static int p9_conn_rpcnb(struct p9_conn *m, struct p9_fcall *tc,
 		   p9_conn_req_callback cb, void *a)
 {
 	int err;
@@ -1066,7 +1066,7 @@ int p9_conn_rpcnb(struct p9_conn *m, struct p9_fcall *tc,
  * @m: mux data
  * @err: error code
  */
-void p9_conn_cancel(struct p9_conn *m, int err)
+static void p9_conn_cancel(struct p9_conn *m, int err)
 {
 	struct p9_req *req, *rtmp;
 	LIST_HEAD(cancel_list);
-- 
1.5.3

