Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbYDQBWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbYDQBWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760142AbYDQBIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:08:40 -0400
Received: from sous-sol.org ([216.99.217.87]:58940 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758892AbYDQBIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:08:36 -0400
Message-Id: <20080417010341.518702106@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:53 -0700
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
       "David S. Miller" <davem@davemloft.net>
Subject: INET: inet_frag_evictor() must run with BH disabled
Content-Disposition: inline; filename=inet-inet_frag_evictor-must-run-with-bh-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David S. Miller <davem@davemloft.net>

Part of upstream commit: e8e16b706e8406f1ab3bccab16932ebc513896d8

Based upon a lockdep trace from Dave Jones.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -147,7 +147,9 @@ static __inline__ void fq_kill(struct nf
 
 static void nf_ct_frag6_evictor(void)
 {
+	local_bh_disable();
 	inet_frag_evictor(&nf_frags);
+	local_bh_enable();
 }
 
 static void nf_ct_frag6_expire(unsigned long data)

-- 
