Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbYGKODW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbYGKODW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYGKODK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:03:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbYGKODJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:03:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix netfilter xt_time's time_mt()'s use of do_div()
To: jengelh@computergmbh.de, akpm@linux-foundation.org
Cc: dhowells@redhat.com, kaber@trash.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2008 15:02:06 +0100
Message-ID: <20080711140206.982.19421.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix netfilter xt_time's time_mt()'s use of do_div() on an s64 by using
div_s64() instead.

This was introduced by patch ee4411a1b1e0b679c99686629b5eab5a072ce49f.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/netfilter/xt_time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index ed76baa..9f32859 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -173,7 +173,7 @@ time_mt(const struct sk_buff *skb, const struct net_device *in,
 		__net_timestamp((struct sk_buff *)skb);
 
 	stamp = ktime_to_ns(skb->tstamp);
-	do_div(stamp, NSEC_PER_SEC);
+	stamp = div_s64(stamp, NSEC_PER_SEC);
 
 	if (info->flags & XT_TIME_LOCAL_TZ)
 		/* Adjust for local timezone */

