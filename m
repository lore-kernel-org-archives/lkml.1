Return-Path: <linux-kernel-owner+w=401wt.eu-S1761938AbZJIXnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938AbZJIXnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761921AbZJIXnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:43:41 -0400
Received: from kroah.org ([198.145.64.141]:51491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761696AbZJIXmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:42:52 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:34:40 2009
Message-Id: <20091009233440.660965082@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:34:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 36/37] ax25: Fix SIOCAX25GETINFO ioctl
References: <20091009233411.852013234@mini.kroah.org>
Content-Disposition: inline; filename=ax25-fix-siocax25getinfo-ioctl.patch
In-Reply-To: <20091009233812.GA15982@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 407fc5cf019fc5cb990458a2e38d2c0a27b3cb30 ]

rcv_q & snd_q initializations were reversed in commit
31e6d363abcd0d05766c82f1a9c905a4c974a199
(net: correct off-by-one write allocations reports)

Signed-off-by: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ax25/af_ax25.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1781,8 +1781,8 @@ static int ax25_ioctl(struct socket *soc
 		ax25_info.idletimer = ax25_display_timer(&ax25->idletimer) / (60 * HZ);
 		ax25_info.n2count   = ax25->n2count;
 		ax25_info.state     = ax25->state;
-		ax25_info.rcv_q     = sk_wmem_alloc_get(sk);
-		ax25_info.snd_q     = sk_rmem_alloc_get(sk);
+		ax25_info.rcv_q     = sk_rmem_alloc_get(sk);
+		ax25_info.snd_q     = sk_wmem_alloc_get(sk);
 		ax25_info.vs        = ax25->vs;
 		ax25_info.vr        = ax25->vr;
 		ax25_info.va        = ax25->va;


