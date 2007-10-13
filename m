Return-Path: <linux-kernel-owner+w=401wt.eu-S1763404AbXJMOw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763404AbXJMOw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbXJMOmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:51 -0400
Received: from 1wt.eu ([62.212.114.60]:3025 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761561AbXJMOms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:48 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143512.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:55 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 33/35] Fix ipv6 double-sock-release with MSG_CONFIRM
Content-Disposition: inline; filename=0093-Fix-ipv6-double-sock-release-with-MSG_CONFIRM.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3ef9d943d26dea764f4fecf3767001c90b778b0c in mainline

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/raw.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

Index: 2.6/net/ipv6/raw.c
===================================================================
--- 2.6.orig/net/ipv6/raw.c
+++ 2.6/net/ipv6/raw.c
@@ -851,11 +851,10 @@ back_from_confirm:
 			ip6_flush_pending_frames(sk);
 		else if (!(msg->msg_flags & MSG_MORE))
 			err = rawv6_push_pending_frames(sk, &fl, rp);
+		release_sock(sk);
 	}
 done:
 	dst_release(dst);
-	if (!inet->hdrincl)
-		release_sock(sk);
 out:	
 	fl6_sock_release(flowlabel);
 	return err<0?err:len;

-- 
