Return-Path: <linux-kernel-owner+w=401wt.eu-S1751378AbXGBKEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbXGBKEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 06:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbXGBKED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 06:04:03 -0400
Received: from mx10.go2.pl ([193.17.41.74]:34473 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750775AbXGBKEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 06:04:01 -0400
Date: Mon, 2 Jul 2007 12:12:23 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S\. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH 2/2][NETPOLL] netconsole: delete flush_scheduled_work
Message-ID: <20070702101223.GC1639@ff.dom.local>
References: <20070701173558.GA207@tv-sign.ru> <20070702075226.GB1639@ff.dom.local> <20070702085949.GA110@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070702085949.GA110@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 12:59:49PM +0400, Oleg Nesterov wrote:
...
> While you are here, could you also delete this flush_scheduled_work() ?
> It is not needed any longer.

Yes. I've thought about this, and even planned to mention, but then
forgotten... Of course, you are right, but since it stayed so long
and doesn't seem to be dangerous, and there is -rc7 I wasn't so brave.
But now I have an explanation...

Jarek P.

---------->

Subject: [PATCH][NETPOLL] netconsole: delete flush_scheduled_work

flush_scheduled_work() isn't needed after cancel_rearming_delayed_work(),
so here it's removed from netpoll_cleanup().

PS: This patch was prepared on 2.6.22-rc7 with my other today's patch:
netconsole: fix soft lockup ...

Noticed-by: Oleg Nesterov <oleg@tv-sign.ru>

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.22-rc7-plus-revert1-/net/core/netpoll.c 2.6.22-rc7-plus-revert1/net/core/netpoll.c
--- 2.6.22-rc7-plus-revert1-/net/core/netpoll.c	2007-07-02 09:32:34.000000000 +0200
+++ 2.6.22-rc7-plus-revert1/net/core/netpoll.c	2007-07-02 11:43:29.000000000 +0200
@@ -786,7 +786,6 @@ void netpoll_cleanup(struct netpoll *np)
 				skb_queue_purge(&npinfo->arp_tx);
 				skb_queue_purge(&npinfo->txq);
 				cancel_rearming_delayed_work(&npinfo->tx_work);
-				flush_scheduled_work();
 
 				/* clean after last, unfinished work */
 				if (!skb_queue_empty(&npinfo->txq)) {
