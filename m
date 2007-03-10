Return-Path: <linux-kernel-owner+w=401wt.eu-S1751559AbXCJGU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbXCJGU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbXCJGTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:19:37 -0500
Received: from mail.suse.de ([195.135.220.2]:41001 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbXCJGTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:19:13 -0500
Date: Fri, 9 Mar 2007 22:17:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, netfilter-devel@lists.netfilter.org,
       Patrick McHardy <kaber@trash.net>, davem@davemloft.net,
       Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [patch 08/20] ip6_route_me_harder should take into account mark
Message-ID: <20070310061734.GI31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ip6_route_me_harder-should-take-into-account-mark.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

[NETFILTER]: ip6_route_me_harder should take into account mark

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/netfilter.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -15,6 +15,7 @@ int ip6_route_me_harder(struct sk_buff *
 	struct dst_entry *dst;
 	struct flowi fl = {
 		.oif = skb->sk ? skb->sk->sk_bound_dev_if : 0,
+		.mark = skb->mark,
 		.nl_u =
 		{ .ip6_u =
 		  { .daddr = iph->daddr,

-- 
