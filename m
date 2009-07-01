Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZGAStd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZGAStd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZGAStW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:49:22 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:63209 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbZGAStV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:49:21 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net,
       Abhishek Kulkarni <adkulkar@umail.iu.edu>, netdev@vger.kernel.org
Subject: [9P PATCH 2/2] net/9p: Fix crash due to bad mount parameters.
Date: Wed,  1 Jul 2009 12:50:54 -0600
Message-Id: <1246474254-10401-2-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1246474254-10401-1-git-send-email-adkulkar@umail.iu.edu>
References: <1246474254-10401-1-git-send-email-adkulkar@umail.iu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not safe to use match_int without checking the token type returned
by match_token (especially when the token type returned is Opt_err and
args is empty). Fix it.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 c613ed08.. b884d98... M	net/9p/trans_fd.c
 net/9p/trans_fd.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index c613ed0..b884d98 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -731,12 +731,14 @@ static int parse_opts(char *params, struct p9_fd_opts *opts)
 		if (!*p)
 			continue;
 		token = match_token(p, tokens, args);
-		r = match_int(&args[0], &option);
-		if (r < 0) {
-			P9_DPRINTK(P9_DEBUG_ERROR,
-			 "integer field, but no integer?\n");
-			ret = r;
-			continue;
+		if (token != Opt_err) {
+			r = match_int(&args[0], &option);
+			if (r < 0) {
+				P9_DPRINTK(P9_DEBUG_ERROR,
+				"integer field, but no integer?\n");
+				ret = r;
+				continue;
+			}
 		}
 		switch (token) {
 		case Opt_port:
-- 
1.6.3.3

