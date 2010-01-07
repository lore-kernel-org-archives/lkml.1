Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519Ab0AGCUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab0AGCUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271Ab0AGCUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:20:22 -0500
Received: from mail.perches.com ([173.55.12.10]:1614 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab0AGCUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:20:20 -0500
Subject: [PATCH] net/netfilter/xt_osf.c: Change %pi4 to %pI4
From: Joe Perches <joe@perches.com>
To: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org,
       netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 18:20:18 -0800
Message-ID: <1262830818.1872.52.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8a27f7c90ffcb791eed7574922b51fb60b08fc89
changed the output style of %pi4 to use fixed
width leading zero IP addresses "001.002.003.004".

It's useful when printing multiple lines of
addresses, but was a change in output style for
some existing uses.

Using %pI4 restores the previous output style.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index 4d1a41b..4169e20 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -334,7 +334,7 @@ static bool xt_osf_match_packet(const struct sk_buff *skb,
 			if (info->flags & XT_OSF_LOG)
 				nf_log_packet(p->family, p->hooknum, skb,
 					p->in, p->out, NULL,
-					"%s [%s:%s] : %pi4:%d -> %pi4:%d hops=%d\n",
+					"%s [%s:%s] : %pI4:%d -> %pI4:%d hops=%d\n",
 					f->genre, f->version, f->subtype,
 					&ip->saddr, ntohs(tcp->source),
 					&ip->daddr, ntohs(tcp->dest),
@@ -349,7 +349,7 @@ static bool xt_osf_match_packet(const struct sk_buff *skb,
 
 	if (!fcount && (info->flags & XT_OSF_LOG))
 		nf_log_packet(p->family, p->hooknum, skb, p->in, p->out, NULL,
-			"Remote OS is not known: %pi4:%u -> %pi4:%u\n",
+			"Remote OS is not known: %pI4:%u -> %pI4:%u\n",
 				&ip->saddr, ntohs(tcp->source),
 				&ip->daddr, ntohs(tcp->dest));
 


