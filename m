Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbXIBEUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbXIBEUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 00:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXIBEUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 00:20:05 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1945 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750969AbXIBEUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 00:20:03 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: lists@nerdbynature.de (Christian Kujau)
Subject: Re: Oops in 2.6.23-rc5
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       torvalds@linux-foundation.org, davem@davemloft.net
Organization: Core
In-Reply-To: <alpine.DEB.0.999.0709012236460.6640@sheep.housecafe.de>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IRgwF-0004G0-00@gondolin.me.apana.org.au>
Date: Sun, 02 Sep 2007 12:19:55 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau <lists@nerdbynature.de> wrote:
> 
> today I switched from 2.6.22.3 to 2.6.23-rc5 (skipped quite a few -rc 
> versions due to lack of time), and the box keeps panicking under certain 
> circumstances. I suspected disk related problems, because: when the box 
> is up, I usually resume ~10 bittorrent files. When doing this, each
> file (~200MB...1GB) is checked and disk activity is pretty high (20MB/s
> or so), and after 1 minute of doing so the box panicks. Every time.

You want this patch (by davem).

Unfortunately people are travelling so I'm not sure when it'll
get picked up by Linus.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
From: davem@davemloft.net (David Miller)

> ip is at tcp_rto_min+0x20/0x40

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 1ee7212..bbad2cd 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -560,7 +560,7 @@ static u32 tcp_rto_min(struct sock *sk)
 	struct dst_entry *dst = __sk_dst_get(sk);
 	u32 rto_min = TCP_RTO_MIN;
 
-	if (dst_metric_locked(dst, RTAX_RTO_MIN))
+	if (dst && dst_metric_locked(dst, RTAX_RTO_MIN))
 		rto_min = dst->metrics[RTAX_RTO_MIN-1];
 	return rto_min;
 }
