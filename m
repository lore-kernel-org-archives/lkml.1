Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbYGUBRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbYGUBRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 21:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYGUBRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 21:17:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36836
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754780AbYGUBRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 21:17:02 -0400
Date: Sun, 20 Jul 2008 18:17:02 -0700 (PDT)
Message-Id: <20080720.181702.239050112.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0807201804410.31863@woody.linux-foundation.org>
References: <20080720.104411.81744468.davem@davemloft.net>
	<alpine.LFD.1.10.0807201751440.31863@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807201804410.31863@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6L1HNfq021508

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Jul 2008 18:07:28 -0700 (PDT)

> This warning also seems to be new:
> 
> 	net/ipv6/addrconf.c: In function ¡addrconf_add_linklocal¢:
> 	net/ipv6/addrconf.c:2318: warning: unused variable ¡net¢
> 
> and looking at the code it's apparently because I'm not an optimistic 
> enough dad.
> 
> But hey, if you had three pre-teenage girls, you might not be all that 
> optimistic either. So I think that's reasonable.
> 
> Problem seems to have been introduced by 53b7997f ("ipv6 netns: Make 
> several "global" sysctl variables namespace aware")

Let's just expand the thing in the one spot it gets
referenced in.

Please apply, thanks.

ipv6: Fix warning in addrconf code.

Reported by Linus.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 580ae50..9f4fcce 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2315,12 +2315,11 @@ static void init_loopback(struct net_device *dev)
 static void addrconf_add_linklocal(struct inet6_dev *idev, struct in6_addr *addr)
 {
 	struct inet6_ifaddr * ifp;
-	struct net *net = dev_net(idev->dev);
 	u32 addr_flags = IFA_F_PERMANENT;
 
 #ifdef CONFIG_IPV6_OPTIMISTIC_DAD
 	if (idev->cnf.optimistic_dad &&
-	    !net->ipv6.devconf_all->forwarding)
+	    !dev_net(idev->dev)->ipv6.devconf_all->forwarding)
 		addr_flags |= IFA_F_OPTIMISTIC;
 #endif
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
