Return-Path: <linux-kernel-owner+w=401wt.eu-S934115AbZLGLdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115AbZLGLdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 06:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934038AbZLGLdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 06:33:24 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:44462 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933740AbZLGLdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 06:33:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=tGn+YN9AYFJOzTMsMzHhxEfalnsAZsEpFTJa0ne3TSkLCjOmEb4bfV91/vfnENEw8b
         varreV6gI7CsoiB7rRiYiWVIdqrPt+Xf3XMxN3rMFA2o/ETWJbEMxb652eIThSOYgsOv
         ZJA4IGW1UGsjdDMVNpM1ZgmN/tmCDsKlwspS0=
Message-ID: <4B1CE844.1040108@gmail.com>
Date: Mon, 07 Dec 2009 12:34:28 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       linux-nfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] SUNRPC: IS_ERR/PTR_ERR confusion
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR returns 1 or 0, PTR_ERR returns the error value.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 net/sunrpc/auth_gss/auth_gss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index fc6a43c..129d75e 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -485,7 +485,7 @@ gss_refresh_upcall(struct rpc_task *task)
 	dprintk("RPC: %5u gss_refresh_upcall for uid %u\n", task->tk_pid,
 								cred->cr_uid);
 	gss_msg = gss_setup_upcall(task->tk_client, gss_auth, cred);
-	if (IS_ERR(gss_msg) == -EAGAIN) {
+	if (PTR_ERR(gss_msg) == -EAGAIN) {
 		/* XXX: warning on the first, under the assumption we
 		 * shouldn't normally hit this case on a refresh. */
 		warn_gssd();
