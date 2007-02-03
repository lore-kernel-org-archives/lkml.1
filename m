Return-Path: <linux-kernel-owner+w=401wt.eu-S1946257AbXBCCxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946257AbXBCCxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946238AbXBCCgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:36:38 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52670 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946236AbXBCCfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:35:48 -0500
Message-Id: <20070203024045.463533000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:24 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>, netfilter-devel@lists.netfilter.org,
       davem@davemloft.net
Subject: [patch 20/59] NETFILTER: ctnetlink: fix leak in ctnetlink_create_conntrack error path
Content-Disposition: inline; filename=ctnetlink-fix-leak-in-ctnetlink_create_conntrack-error-path.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Patrick McHardy <kaber@trash.net>

---

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 +-
 net/netfilter/nf_conntrack_netlink.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.19.2.orig/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ linux-2.6.19.2/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -955,7 +955,7 @@ ctnetlink_create_conntrack(struct nfattr
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
 		if (err < 0)
-			return err;
+			goto err;
 	}
 
 #if defined(CONFIG_IP_NF_CONNTRACK_MARK)
--- linux-2.6.19.2.orig/net/netfilter/nf_conntrack_netlink.c
+++ linux-2.6.19.2/net/netfilter/nf_conntrack_netlink.c
@@ -972,7 +972,7 @@ ctnetlink_create_conntrack(struct nfattr
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
 		if (err < 0)
-			return err;
+			goto err;
 	}
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)

--
