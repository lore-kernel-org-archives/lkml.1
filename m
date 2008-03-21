Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbYCUXrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbYCUXrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYCUXpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:45:36 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60178 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbYCUXpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:45:25 -0400
Message-Id: <20080321224333.926498253@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:42:58 -0700
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
       "Jorge Boncompte [DTI2]" <jorge@dti2.net>,
       Patrick McHardy <kaber@trash.net>, David S Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 08/76] NET: Messed multicast lists after dev_mc_sync/unsync
Content-Disposition: inline; filename=net-messed-multicast-lists-after-dev_mc_sync-unsync.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jorge Boncompte [DTI2] <jorge@dti2.net>

Upstream commit: 12aa343add3eced38a44bdb612b35fdf634d918c

Commit a0a400d79e3dd7843e7e81baa3ef2957bdc292d0 ("[NET]: dev_mcast:
add multicast list synchronization helpers") from you introduced a new
field "da_synced" to struct dev_addr_list that is not properly
initialized to 0. So when any of the current users (8021q, macvlan,
mac80211) calls dev_mc_sync/unsync they mess the address list for both
devices.

The attached patch fixed it for me and avoid future problems.

Signed-off-by: Jorge Boncompte [DTI2] <jorge@dti2.net>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2906,7 +2906,7 @@ int __dev_addr_add(struct dev_addr_list 
 		}
 	}
 
-	da = kmalloc(sizeof(*da), GFP_ATOMIC);
+	da = kzalloc(sizeof(*da), GFP_ATOMIC);
 	if (da == NULL)
 		return -ENOMEM;
 	memcpy(da->da_addr, addr, alen);

-- 
