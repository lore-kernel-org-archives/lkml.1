Return-Path: <linux-kernel-owner+w=401wt.eu-S1764243AbYDPQAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764243AbYDPQAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbYDPQAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:00:06 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:51765 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbYDPQAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:00:04 -0400
Message-ID: <48062282.4070204@tiscali.nl>
Date: Wed, 16 Apr 2008 18:00:02 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: kaber@trash.net, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] NETFILTER: signed tcphoff for ipv6_skip_exthdr() retval
References: <480558CA.7090800@tiscali.nl>
In-Reply-To: <480558CA.7090800@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if tcphoff remains unsigned, a negative ipv6_skip_exthdr() return value will
go unnoticed,
    
Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 3b2aa56..9685b6f 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -90,7 +90,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct net_device *in,
 		const struct xt_target *target, const void *targinfo)
 {
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-	unsigned int tcphoff;
+	int tcphoff;
 	u_int8_t nexthdr;
 
 	nexthdr = ipv6h->nexthdr;

