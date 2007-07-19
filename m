Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbXGSUFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbXGSUFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbXGSUE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:04:58 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40156 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbXGSUE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:04:57 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Thu, 19 Jul 2007 22:02:49 +0200
User-Agent: KMail/1.9.1
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
References: <20070716091236.GA10718@elte.hu> <200707192135.43652.olaf.kirch@oracle.com> <20070719195650.GA2136@elte.hu>
In-Reply-To: <20070719195650.GA2136@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707192202.51580.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 21:56, Ingo Molnar wrote:
> nope - with this patch applied the box still has no network, symptoms 
> are similar. (should i apply the WARN_ON() patch too?)

Yes, that would be nice. If that doesn't help, you can also throw in
the one below.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
---
Index: build-2.6/net/core/netpoll.c
===================================================================
--- build-2.6.orig/net/core/netpoll.c
+++ build-2.6/net/core/netpoll.c
@@ -650,7 +650,6 @@ int netpoll_setup(struct netpoll *np)
 		return -ENODEV;
 	}
 
-	np->dev = ndev;
 	if (!ndev->npinfo) {
 		npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
 		if (!npinfo) {
@@ -722,6 +721,8 @@ int netpoll_setup(struct netpoll *np)
 		}
 	}
 
+	np->dev = ndev;
+
 	if (is_zero_ether_addr(np->local_mac) && ndev->dev_addr)
 		memcpy(np->local_mac, ndev->dev_addr, 6);
 

