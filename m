Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZGMNuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZGMNuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbZGMNuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:50:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:39641 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbZGMNuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:50:17 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: ericvh@gmail.com, Abhishek Kulkarni <adkulkar@umail.iu.edu>,
       v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH] [net/9p]: default 9p transport module fix
Date: Mon, 13 Jul 2009 07:49:51 -0600
Message-Id: <1247492991-26009-2-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1247492991-26009-1-git-send-email-adkulkar@umail.iu.edu>
References: <1247492991-26009-1-git-send-email-adkulkar@umail.iu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default 9p transport module is not chosen unless an option parameter (any)
is passed to mount, which thus returns a ENOPROTOSUPPORT. This fix moves the
check out of parse_opts into p9_client_create.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 cc25e63... 787ccdd... M	net/9p/client.c
 net/9p/client.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index cc25e63..787ccdd 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -117,9 +117,6 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 		}
 	}
 
-	if (!clnt->trans_mod)
-		clnt->trans_mod = v9fs_get_default_trans();
-
 	kfree(options);
 	return ret;
 }
@@ -689,6 +686,9 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (err < 0)
 		goto error;
 
+	if (!clnt->trans_mod)
+		clnt->trans_mod = v9fs_get_default_trans();
+
 	if (clnt->trans_mod == NULL) {
 		err = -EPROTONOSUPPORT;
 		P9_DPRINTK(P9_DEBUG_ERROR,
-- 
1.6.0.4

