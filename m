Return-Path: <linux-kernel-owner+w=401wt.eu-S933300AbZHVS6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbZHVS6z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 14:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933244AbZHVS6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 14:58:54 -0400
Received: from server1.wserver.cz ([82.113.45.157]:50128 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933228AbZHVS6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 14:58:54 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 1/1] NET: llc, zero sockaddr_llc struct
Date: Sat, 22 Aug 2009 20:58:55 +0200
Message-Id: <1250967535-30692-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sllc_arphrd member of sockaddr_llc might not be set. Zero sllc
before copying it to the above layers.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 net/llc/af_llc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 9208cf5..22629fc 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -909,7 +909,7 @@ release:
 static int llc_ui_getname(struct socket *sock, struct sockaddr *uaddr,
 			  int *uaddrlen, int peer)
 {
-	struct sockaddr_llc sllc;
+	struct sockaddr_llc sllc = {};
 	struct sock *sk = sock->sk;
 	struct llc_sock *llc = llc_sk(sk);
 	int rc = 0;
-- 
1.6.3.3

