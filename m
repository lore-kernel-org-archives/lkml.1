Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbZJMAMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbZJMAMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 20:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZJMAMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 20:12:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40912
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603AbZJMAMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 20:12:15 -0400
Date: Mon, 12 Oct 2009 17:12:11 -0700 (PDT)
Message-Id: <20091012.171211.94935517.davem@davemloft.net>
To: gregkh@suse.de
Cc: Fred.L.Templin@boeing.com, greg@kroah.com, contact@saschahlusiak.de,
       yoshfuji@linux-ipv6.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 37/37] sit: fix off-by-one
 inipip6_tunnel_get_prl
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091012235806.GA25153@suse.de>
References: <20091012220445.GB31010@kroah.com>
	<12F4112206976147A34FEC0277597CCF27A4164C1A@XCH-NW-15V.nw.nos.boeing.com>
	<20091012235806.GA25153@suse.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Mon, 12 Oct 2009 16:58:06 -0700

> Which patch?  I need it to be in Linus's tree before we can apply it to
> a stable release.

It's already upstream, and I already submitted it to -stable a few
days ago, remember?  This one below.

Greg, it's the one that you said "I already commited this one, is it
reall so broken?" about earlier today.

>From a9cb3db986f8bceaa741175cf016b0b7df59caf0 Mon Sep 17 00:00:00 2001
From: Sascha Hlusiak <contact@saschahlusiak.de>
Date: Tue, 29 Sep 2009 11:27:05 +0000
Subject: [PATCH 11/11] sit: fix off-by-one in ipip6_tunnel_get_prl

[ Upstream commit 298bf12ddb25841804f26234a43b89da1b1c0e21 ]

When requesting all prl entries (kprl.addr == INADDR_ANY) and there are
more prl entries than there is space passed from userspace, the existing
code would always copy cmax+1 entries, which is more than can be handled.

This patch makes the kernel copy only exactly cmax entries.

Signed-off-by: Sascha Hlusiak <contact@saschahlusiak.de>
Acked-By: Fred L. Templin <Fred.L.Templin@boeing.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv6/sit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 98b7327..2e41849 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -313,7 +313,7 @@ static int ipip6_tunnel_get_prl(struct ip_tunnel *t,
 
 	c = 0;
 	for (prl = t->prl; prl; prl = prl->next) {
-		if (c > cmax)
+		if (c >= cmax)
 			break;
 		if (kprl.addr != htonl(INADDR_ANY) && prl->addr != kprl.addr)
 			continue;
-- 
1.6.4.4

