Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbXISJh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbXISJh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 05:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbXISJht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 05:37:49 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:34214 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbXISJhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 05:37:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=mwJSTxdSBkN/uKaeHCjalujeBFCovAo3t2KIEKtNOexVPUR4b6nHZqssHrNaxra6dzacByzYOZu863pX1ZnKDrc06U1UTnN7ly9KUctyZTQ3Gc7cMP3FLDEcgZarpWle1dCjv/O564JF3hpYlIOu1QPaJFoGqh3Yr+BdqUu/Yx8=
Date: Wed, 19 Sep 2007 17:36:48 +0800
From: lepton <ytht.net@gmail.com>
To: kaber@trash.net
Cc: lkm <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] 2.6.22.6 netfilter: sk_setup_caps in ip_make_route_harder
Message-ID: <20070919093648.GA7491@router.lepton.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  For local src packets, it is better to update sk_route_caps in
  ip_route_me_harder.

Signed-off-by: Lepton Wu <ytht.net@gmail.com>

diff -pru -X linux-2.6.22.6/Documentation/dontdiff linux-2.6.22.6/net/ipv4/netfilter.c linux-2.6.22.6-lepton/net/ipv4/netfilter.c
--- linux-2.6.22.6/net/ipv4/netfilter.c	2007-09-19 13:19:13.000000000 +0800
+++ linux-2.6.22.6-lepton/net/ipv4/netfilter.c	2007-09-19 17:10:36.000000000 +0800
@@ -37,6 +37,10 @@ int ip_route_me_harder(struct sk_buff **
 		/* Drop old route. */
 		dst_release((*pskb)->dst);
 		(*pskb)->dst = &rt->u.dst;
+		if((*pskb)->sk){
+			dst_hold((*pskb)->dst);
+			sk_setup_caps((*pskb)->sk, (*pskb)->dst);
+		}
 	} else {
 		/* non-local src, find valid iif to satisfy
 		 * rp-filter when calling ip_route_input. */
