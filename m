Return-Path: <linux-kernel-owner+w=401wt.eu-S1422785AbXCGRjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422785AbXCGRjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422843AbXCGRPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:15:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:43156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422785AbXCGRPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:03 -0500
Message-Id: <20070307171253.217963492@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, yoshfuji@linux-ipv6.org,
       netdev@vger.kernel.org, handat@pm.nttdata.co.jp
Subject: [patch 029/101] IPV6: HASHTABLES: Use appropriate seed for caluculating ehash index.
Content-Disposition: inline; filename=ipv6-hashtables-use-appropriate-seed-for-caluculating-ehash-index.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

Tetsuo Handa <handat@pm.nttdata.co.jp> told me that connect(2) with TCPv6
socket almost always took a few minutes to return when we did not have any
ports available in the range of net.ipv4.ip_local_port_range.

The reason was that we used incorrect seed for calculating index of
hash when we check established sockets in __inet6_check_established().

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/inet6_hashtables.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/net/ipv6/inet6_hashtables.c
+++ linux-2.6.20.1/net/ipv6/inet6_hashtables.c
@@ -172,7 +172,7 @@ static int __inet6_check_established(str
 	const struct in6_addr *saddr = &np->daddr;
 	const int dif = sk->sk_bound_dev_if;
 	const __portpair ports = INET_COMBINED_PORTS(inet->dport, lport);
-	const unsigned int hash = inet6_ehashfn(daddr, inet->num, saddr,
+	const unsigned int hash = inet6_ehashfn(daddr, lport, saddr,
 						inet->dport);
 	struct inet_ehash_bucket *head = inet_ehash_bucket(hinfo, hash);
 	struct sock *sk2;

--
