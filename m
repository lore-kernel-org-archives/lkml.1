Return-Path: <linux-kernel-owner+w=401wt.eu-S1751514AbZHXFnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbZHXFnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 01:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZHXFnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 01:43:41 -0400
Received: from server1.wserver.cz ([82.113.45.157]:57833 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbZHXFnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 01:43:41 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH v2 1/1] NET: llc, zero sockaddr_llc struct
Date: Mon, 24 Aug 2009 07:43:39 +0200
Message-Id: <1251092619-3368-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090823.185617.36449822.davem@davemloft.net>
References: <20090823.185617.36449822.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sllc_arphrd member of sockaddr_llc might not be changed. Zero sllc
before copying to the above layer's structure.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 net/llc/af_llc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 9208cf5..c45eee1 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -914,6 +914,7 @@ static int llc_ui_getname(struct socket *sock, struct sockaddr *uaddr,
 	struct llc_sock *llc = llc_sk(sk);
 	int rc = 0;
 
+	memset(&sllc, 0, sizeof(sllc));
 	lock_sock(sk);
 	if (sock_flag(sk, SOCK_ZAPPED))
 		goto out;
-- 
1.6.3.3

