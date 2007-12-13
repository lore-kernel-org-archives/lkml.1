Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbXLMGth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbXLMGth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760146AbXLMGil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:38:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56696 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760126AbXLMGik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:38:40 -0500
Date: Wed, 12 Dec 2007 22:35:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       davem@davemloft.net, Patrick McHardy <kaber@trash.net>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 34/36] NETFILTER: xt_TCPMSS: remove network triggerable
	WARN_ON
Message-ID: <20071213063534.GI25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="netfilter-xt_tcpmss-remove-network-triggerable-warn_on.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: xt_TCPMSS: remove network triggerable WARN_ON

[ Upstream commit: 9dc0564e862b1b9a4677dec2c736b12169e03e99 ]

ipv6_skip_exthdr() returns -1 for invalid packets. don't WARN_ON
that.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/xt_TCPMSS.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -178,10 +178,8 @@ xt_tcpmss_target6(struct sk_buff **pskb,
 
 	nexthdr = ipv6h->nexthdr;
 	tcphoff = ipv6_skip_exthdr(*pskb, sizeof(*ipv6h), &nexthdr);
-	if (tcphoff < 0) {
-		WARN_ON(1);
+	if (tcphoff < 0)
 		return NF_DROP;
-	}
 	ret = tcpmss_mangle_packet(pskb, targinfo, tcphoff,
 				   sizeof(*ipv6h) + sizeof(struct tcphdr));
 	if (ret < 0)

-- 
