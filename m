Return-Path: <linux-kernel-owner+w=401wt.eu-S936593AbZLQEeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936593AbZLQEeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935598AbZLQEE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:29 -0500
Received: from kroah.org ([198.145.64.141]:55526 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934155AbZLQEEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:20 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:50 2009
Message-Id: <20091217035650.161652420@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [056/151] SUNRPC: IS_ERR/PTR_ERR confusion
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit 480e3243df156e39eea6c91057e2ae612a6bbe19 upstream.

IS_ERR returns 1 or 0, PTR_ERR returns the error value.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/auth_gss/auth_gss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -485,7 +485,7 @@ gss_refresh_upcall(struct rpc_task *task
 	dprintk("RPC: %5u gss_refresh_upcall for uid %u\n", task->tk_pid,
 								cred->cr_uid);
 	gss_msg = gss_setup_upcall(task->tk_client, gss_auth, cred);
-	if (IS_ERR(gss_msg) == -EAGAIN) {
+	if (PTR_ERR(gss_msg) == -EAGAIN) {
 		/* XXX: warning on the first, under the assumption we
 		 * shouldn't normally hit this case on a refresh. */
 		warn_gssd();


