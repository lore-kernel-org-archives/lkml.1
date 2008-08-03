Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbYHCUTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbYHCUTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 16:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYHCUTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 16:19:10 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:33233 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbYHCUTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 16:19:09 -0400
Date: Sun, 3 Aug 2008 22:18:59 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: "David S. Miller" <davem@davemloft.net>
cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH] net: Add missing extra2 parameter for ip_default_ttl
 sysctl
In-Reply-To: <1217793894.8154.38.camel@iris.sw.ru>
Message-ID: <alpine.LNX.1.10.0808032214130.29048@titan.stealer.net>
References: <20080803170241.GD5414@joi>  <1217789775.8154.34.camel@iris.sw.ru>  <alpine.LNX.1.10.0808032110520.7765@titan.stealer.net> <1217793894.8154.38.camel@iris.sw.ru>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.6
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sun, 03 Aug 2008 20:19:08 +0000
	Bayes: 0.1346 Tokens: new, 198; hammy, 2; neutral, 2; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1346]
X-Spam-Signature: 46c731b93aebb8e3bb69a2ab2b3e3e5a35c8b51b
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 76e6ebfb40a2455c18234dcb0f9df37533215461 acceses the extra2 parameter of
the ip_default_ttl ctl_table, but it is never set to a meaningful value. When
e84f84f276473dcc673f360e8ff3203148bdf0e2 is applied, we'll oops in
rt_cache_invalidate(). Set extra2 to init_net, to avoid that.

Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Tested-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Denis V. Lunev <den@openvz.org>
---
 net/ipv4/sysctl_net_ipv4.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 770d827..e0689fd 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -232,6 +232,7 @@ static struct ctl_table ipv4_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &ipv4_doint_and_flush,
 		.strategy	= &ipv4_doint_and_flush_strategy,
+		.extra2		= &init_net,
 	},
 	{
 		.ctl_name	= NET_IPV4_NO_PMTU_DISC,
