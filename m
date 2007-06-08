Return-Path: <linux-kernel-owner+w=401wt.eu-S968240AbXFHHbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968240AbXFHHbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967186AbXFHHT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:19:29 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:57607 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967137AbXFHHT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:19:27 -0400
Message-Id: <20070608071558.884145000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:42 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       Yuji Sekiya <sekiya@wide.ad.jp>
Subject: [patch 31/32] IPV6 ROUTE: No longer handle ::/0 specially.
Content-Disposition: inline; filename=ipv6-route-no-longer-handle-0-specially.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

We do not need to handle ::/0 routes specially any longer.
This should fix BUG #8349.

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Acked-by: Yuji Sekiya <sekiya@wide.ad.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
[chrisw: backport to 2.6.20]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/ipv6/ip6_fib.c |    8 --------
 1 file changed, 8 deletions(-)

--- linux-2.6.20.13.orig/net/ipv6/ip6_fib.c
+++ linux-2.6.20.13/net/ipv6/ip6_fib.c
@@ -620,14 +620,6 @@ static int fib6_add_rt2node(struct fib6_
 
 	ins = &fn->leaf;
 
-	if (fn->fn_flags&RTN_TL_ROOT &&
-	    fn->leaf == &ip6_null_entry &&
-	    !(rt->rt6i_flags & (RTF_DEFAULT | RTF_ADDRCONF)) ){
-		fn->leaf = rt;
-		rt->u.next = NULL;
-		goto out;
-	}
-
 	for (iter = fn->leaf; iter; iter=iter->u.next) {
 		/*
 		 *	Search for duplicates

-- 
