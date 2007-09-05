Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbXIEFnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbXIEFnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 01:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbXIEFn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 01:43:28 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:21438 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbXIEFn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 01:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=Uvmo0an+WVVu0Ompxrj90NvRTbbr56Wdi+ego5c5WdudNd77rw3uqLuLKtnyiEl0gq2Vxx+t8qA+oqGRypiOJ3MhWFDQEnz01g/VZPYKZ2P2SBOhAopGUYowg9mHvIb2nRhsOmif6bHy9DEeHAVdUkN79P6GzMJnwHZxh6NCOb8=
Message-ID: <46DE4248.6070604@gmail.com>
Date: Wed, 05 Sep 2007 13:44:40 +0800
From: Micah Gruber <micah.gruber@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] Remove unneeded pointer iph from ipcomp6_input() in net/ipv6/ipcomp6.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch removes the unneeded pointer iph, which is never used.

Signed-off-by: Micah Gruber < micah.gruber@gmail.com>
---

--- a/net/ipv6/ipcomp6.c	2007-09-04 23:18:43.000000000 +0800
+++ b/net/ipv6/ipcomp6.c	2007-09-05 00:48:05.000000000 +0800
@@ -65,7 +65,6 @@
 static int ipcomp6_input(struct xfrm_state *x, struct sk_buff *skb)
 {
 	int err = -ENOMEM;
-	struct ipv6hdr *iph;
 	struct ipv6_comp_hdr *ipch;
 	int plen, dlen;
 	struct ipcomp_data *ipcd = x->data;
@@ -79,7 +78,6 @@
 	skb->ip_summed = CHECKSUM_NONE;
 
 	/* Remove ipcomp header and decompress original payload */
-	iph = ipv6_hdr(skb);
 	ipch = (void *)skb->data;
 	skb->transport_header = skb->network_header + sizeof(*ipch);
 	__skb_pull(skb, sizeof(*ipch));


