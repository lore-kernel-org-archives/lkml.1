Return-Path: <linux-kernel-owner+w=401wt.eu-S1161843AbXDYK4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161843AbXDYK4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992690AbXDYKyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:54:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992644AbXDYKv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:51:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/16] commit ad495d7b6cfcd1bc2eaf06c42699be0bb5d84234 [try #3]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, dhowells@redhat.com
Date: Wed, 25 Apr 2007 11:51:44 +0100
Message-ID: <20070425105144.10872.72648.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070425105036.10872.48596.stgit@warthog.cambridge.redhat.com>
References: <20070425105036.10872.48596.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[NETLINK]: Mirror UDP MSG_TRUNC semantics.

    If the user passes MSG_TRUNC in via msg_flags, return
    the full packet size not the truncated size.

    Idea from Herbert Xu and Thomas Graf.

    Signed-off-by: David S. Miller <davem@davemloft.net>
---

 net/netlink/af_netlink.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c48b0f4..5890210 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1242,6 +1242,9 @@ static int netlink_recvmsg(struct kiocb *kiocb, struct socket *sock,
 
 	scm_recv(sock, msg, siocb->scm, flags);
 
+	if (flags & MSG_TRUNC)
+		copied = skb->len;
+
 out:
 	netlink_rcv_wake(sk);
 	return err ? : copied;

