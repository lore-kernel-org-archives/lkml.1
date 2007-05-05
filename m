Return-Path: <linux-kernel-owner+w=401wt.eu-S1422653AbXEEPjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422653AbXEEPjG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161937AbXEEPjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:39:06 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:20447 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161911AbXEEPjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:39:02 -0400
Date: Sat, 5 May 2007 15:20:58 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Cc: Frank Pavlic <fpavlic@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch] af_iucv: compile fix - adopt to skbuff changes.
Message-ID: <20070505132058.GC13660@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[patch] af_iucv: compile fix - adopt to skbuff changes.

From: Heiko Carstens <heiko.carstens@de.ibm.com>

  CC [M]  net/iucv/af_iucv.o
net/iucv/af_iucv.c: In function `iucv_fragment_skb':
net/iucv/af_iucv.c:984: error: structure has no member named `h'
net/iucv/af_iucv.c:985: error: structure has no member named `nh'
net/iucv/af_iucv.c:988: error: incompatible type for argument 1 of
			`skb_queue_tail'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Frank Pavlic <fpavlic@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 net/iucv/af_iucv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/net/iucv/af_iucv.c
===================================================================
--- linux-2.6.orig/net/iucv/af_iucv.c
+++ linux-2.6/net/iucv/af_iucv.c
@@ -961,7 +961,7 @@ static void iucv_callback_connack(struct
 }
 
 static int iucv_fragment_skb(struct sock *sk, struct sk_buff *skb, int len,
-			     struct sk_buff_head fragmented_skb_q)
+			     struct sk_buff_head *fragmented_skb_q)
 {
 	int dataleft, size, copied = 0;
 	struct sk_buff *nskb;
@@ -981,8 +981,8 @@ static int iucv_fragment_skb(struct sock
 		copied += size;
 		dataleft -= size;
 
-		nskb->h.raw = nskb->data;
-		nskb->nh.raw = nskb->data;
+		skb_reset_transport_header(nskb);
+		skb_reset_network_header(nskb);
 		nskb->len = size;
 
 		skb_queue_tail(fragmented_skb_q, nskb);
