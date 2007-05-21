Return-Path: <linux-kernel-owner+w=401wt.eu-S1765212AbXEUTpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765212AbXEUTpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765505AbXEUT2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:28:06 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52576 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765741AbXEUT2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:28:04 -0400
Message-Id: <20070521191746.464211000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:01 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de, YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [patch 49/69] IPV6 ROUTE: Assign rt6i_idev for ip6_{prohibit,blk_hole}_entry.
Content-Disposition: inline; filename=ipv6-route-assign-rt6i_idev-for-ip6_-prohibit-blk_hole-_entry.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

I think this is less critical, but is also suitable for -stable
release.

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/ipv6/addrconf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2.6.21.1.orig/net/ipv6/addrconf.c
+++ linux-2.6.21.1/net/ipv6/addrconf.c
@@ -4062,6 +4062,10 @@ int __init addrconf_init(void)
 		return err;
 
 	ip6_null_entry.rt6i_idev = in6_dev_get(&loopback_dev);
+#ifdef CONFIG_IPV6_MULTIPLE_TABLES
+	ip6_prohibit_entry.rt6i_idev = in6_dev_get(&loopback_dev);
+	ip6_blk_hole_entry.rt6i_idev = in6_dev_get(&loopback_dev);
+#endif
 
 	register_netdevice_notifier(&ipv6_dev_notf);
 

-- 
