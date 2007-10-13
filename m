Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbXJMOz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbXJMOz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762073AbXJMOm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:59 -0400
Received: from 1wt.eu ([62.212.114.60]:3038 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761519AbXJMOm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:57 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143513.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:56 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 34/35] Fix datagram recvmsg NULL iov handling regression.
Content-Disposition: inline; filename=0100-Fix-datagram-recvmsg-NULL-iov-handling-regression.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit ef8aef55ce61fd0e2af798695f7386ac756ae1e7 in mainline

Subject: [2.6.20.21 review 34/35] [PATCH] [NET]: Do not dereference iov if length is zero

When msg_iovlen is zero we shouldn't try to dereference
msg_iov.  Right now the only thing that tries to do so
is skb_copy_and_csum_datagram_iovec.  Since the total
length should also be zero if msg_iovlen is zero, it's
sufficient to check the total length there and simply
return if it's zero.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/datagram.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

Index: 2.6/net/core/datagram.c
===================================================================
--- 2.6.orig/net/core/datagram.c
+++ 2.6/net/core/datagram.c
@@ -444,6 +444,9 @@ int skb_copy_and_csum_datagram_iovec(str
 	__wsum csum;
 	int chunk = skb->len - hlen;
 
+	if (!chunk)
+		return 0;
+
 	/* Skip filled elements.
 	 * Pretty silly, look at memcpy_toiovec, though 8)
 	 */

-- 
