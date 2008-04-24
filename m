Return-Path: <linux-kernel-owner+w=401wt.eu-S1763501AbYDXTkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763501AbYDXTkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbYDXTkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:40:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095AbYDXTkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:40:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] RxRPC: Fix a regression in the RXKAD security module
To: torvalds@osdl.org, akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 24 Apr 2008 20:38:56 +0100
Message-ID: <20080424193856.14737.16718.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a regression in the RXKAD security module introduced in:

	commit 91e916cffec7c0153c5cbaa447151862a7a9a047
	Author: Al Viro <viro@ftp.linux.org.uk>
	Date:   Sat Mar 29 03:08:38 2008 +0000

	net/rxrpc trivial annotations

A variable was declared as a 16-bit type rather than a 32-bit type.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/rxkad.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 6d38a81..ba3f6e4 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -493,8 +493,8 @@ static int rxkad_verify_packet(const struct rxrpc_call *call,
 		__be32 x[2];
 	} tmpbuf __attribute__((aligned(8))); /* must all be in same page */
 	__be32 x;
-	u16 y;
 	__be16 cksum;
+	u32 y;
 	int ret;
 
 	sp = rxrpc_skb(skb);

