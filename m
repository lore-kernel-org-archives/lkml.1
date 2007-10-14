Return-Path: <linux-kernel-owner+w=401wt.eu-S1762684AbXJNRyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762684AbXJNRyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbXJNRvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:51:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35265 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758492AbXJNRvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:51:42 -0400
Date: Sun, 14 Oct 2007 19:52:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>,
       Masahide NAKAMURA <nakam@linux-ipv6.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] __inet6_csk_dst_store(): fix check-after-use
Message-ID: <20071014175212.GP4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that we have already oops'ed if "dst"
was NULL.

Since "dst" being NULL doesn't seem to be possible at this point this 
patch removes the NULL check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
eeb6009cf3ef5f6993ced359330d877680617a70 
diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
index 25b9317..78de42a 100644
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -146,7 +146,7 @@ void __inet6_csk_dst_store(struct sock *sk, struct dst_entry *dst,
 	__ip6_dst_store(sk, dst, daddr, saddr);
 
 #ifdef CONFIG_XFRM
-	if (dst) {
+	{
 		struct rt6_info *rt = (struct rt6_info  *)dst;
 		rt->rt6i_flow_cache_genid = atomic_read(&flow_cache_genid);
 	}
