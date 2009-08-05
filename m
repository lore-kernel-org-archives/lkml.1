Return-Path: <linux-kernel-owner+w=401wt.eu-S934266AbZHEMfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266AbZHEMfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933122AbZHEMfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:35:09 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50365 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934251AbZHEMfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:35:08 -0400
Date: Wed, 5 Aug 2009 14:34:55 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] security/smack: Use AF_INET for sin_family field
Message-ID: <Pine.LNX.4.64.0908051434340.20453@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Elsewhere the sin_family field holds a value with a name of the form
AF_..., so it seems reasonable to do so here as well.  Also the values of
PF_INET and AF_INET are the same.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
struct sockaddr_in sip;
@@

(
sip.sin_family ==
- PF_INET
+ AF_INET
|
sip.sin_family !=
- PF_INET
+ AF_INET
|
sip.sin_family =
- PF_INET
+ AF_INET
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 security/smack/smack_lsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2464,7 +2464,7 @@ static int smack_socket_sendmsg(struct s
 	/*
 	 * Perfectly reasonable for this to be NULL
 	 */
-	if (sip == NULL || sip->sin_family != PF_INET)
+	if (sip == NULL || sip->sin_family != AF_INET)
 		return 0;
 
 	return smack_netlabel_send(sock->sk, sip);
