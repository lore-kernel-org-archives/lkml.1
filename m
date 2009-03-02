Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbZCJQpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbZCJQpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZCJQno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:44 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34590 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbZCJQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:38 -0400
Message-Id: <1ac10308df52b2e58c3a77313d3608c1a130341f.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 17:05:12 +0000
Subject: [PATCH 05/31] netfilter: Auto-load ip6_queue module when socket opened.
To: linux-kernel@vger.kernel.org
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ip6_queue module is missing the net-pf-16-proto-13 alias that would
cause it to be auto-loaded when a socket of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 net/ipv6/netfilter/ip6_queue.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 5859c04..b693f84 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -643,6 +643,7 @@ static void __exit ip6_queue_fini(void)
 
 MODULE_DESCRIPTION("IPv6 packet queue handler");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_IP6_FW);
 
 module_init(ip6_queue_init);
 module_exit(ip6_queue_fini);
-- 
1.6.0.5

