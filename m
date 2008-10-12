Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbYJLKx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbYJLKx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 06:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYJLKxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 06:53:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46064 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYJLKxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 06:53:44 -0400
Date: Sun, 12 Oct 2008 12:53:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Julius Volz <juliusv@google.com>, Simon Horman <horms@verge.net.au>
Subject: [PATCH] net, ipvs: fix build on !CONFIG_INET
Message-ID: <20081012105329.GA29306@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


quick fixlet below - please double-check.

---------------->
>From 04f0c230107f2bdc9d0eaf7bdae9490eb3675791 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 12 Oct 2008 12:51:28 +0200
Subject: [PATCH] net, ipvs: fix build on !CONFIG_INET

fix:

  net/netfilter/ipvs/ip_vs_xmit.c: In function 'ip_vs_tunnel_xmit':
  net/netfilter/ipvs/ip_vs_xmit.c:616: error: implicit declaration of function 'ip_select_ident'

ip_vs_xmit depends on CONFIG_INET capabilities.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 net/netfilter/ipvs/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index de6004d..a67a235 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -4,6 +4,7 @@
 menuconfig IP_VS
 	tristate "IP virtual server support (EXPERIMENTAL)"
 	depends on NETFILTER
+	depends on INET
 	---help---
 	  IP Virtual Server support will let you build a high-performance
 	  virtual server based on cluster of two or more real servers. This
