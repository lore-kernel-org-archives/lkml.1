Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931Ab0ANWaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0ANWaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895Ab0ANWaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:30:08 -0500
Received: from kroah.org ([198.145.64.141]:60740 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab0ANW3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:29:05 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 51/52] ipv6: skb_dst() can be NULL in ipv6_hop_jumbo().
Date: Thu, 14 Jan 2010 14:27:30 -0800
Message-Id: <1263508051-7868-51-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-50-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
 <1263508051-7868-28-git-send-email-gregkh@suse.de>
 <1263508051-7868-29-git-send-email-gregkh@suse.de>
 <1263508051-7868-30-git-send-email-gregkh@suse.de>
 <1263508051-7868-31-git-send-email-gregkh@suse.de>
 <1263508051-7868-32-git-send-email-gregkh@suse.de>
 <1263508051-7868-33-git-send-email-gregkh@suse.de>
 <1263508051-7868-34-git-send-email-gregkh@suse.de>
 <1263508051-7868-35-git-send-email-gregkh@suse.de>
 <1263508051-7868-36-git-send-email-gregkh@suse.de>
 <1263508051-7868-37-git-send-email-gregkh@suse.de>
 <1263508051-7868-38-git-send-email-gregkh@suse.de>
 <1263508051-7868-39-git-send-email-gregkh@suse.de>
 <1263508051-7868-40-git-send-email-gregkh@suse.de>
 <1263508051-7868-41-git-send-email-gregkh@suse.de>
 <1263508051-7868-42-git-send-email-gregkh@suse.de>
 <1263508051-7868-43-git-send-email-gregkh@suse.de>
 <1263508051-7868-44-git-send-email-gregkh@suse.de>
 <1263508051-7868-45-git-send-email-gregkh@suse.de>
 <1263508051-7868-46-git-send-email-gregkh@suse.de>
 <1263508051-7868-47-git-send-email-gregkh@suse.de>
 <1263508051-7868-48-git-send-email-gregkh@suse.de>
 <1263508051-7868-49-git-send-email-gregkh@suse.de>
 <1263508051-7868-50-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

commit 2570a4f5428bcdb1077622342181755741e7fa60 upstream.

This fixes CERT-FI FICORA #341748

Discovered by Olli Jarva and Tuomo Untinen from the CROSS
project at Codenomicon Ltd.

Just like in CVE-2007-4567, we can't rely upon skb_dst() being
non-NULL at this point.  We fixed that in commit
e76b2b2567b83448c2ee85a896433b96150c92e6 ("[IPV6]: Do no rely on
skb->dst before it is assigned.")

However commit 483a47d2fe794328d29950fe00ce26dd405d9437 ("ipv6: added
net argument to IP6_INC_STATS_BH") put a new version of the same bug
into this function.

Complicating analysis further, this bug can only trigger when network
namespaces are enabled in the build.  When namespaces are turned off,
the dev_net() does not evaluate it's argument, so the dereference
would not occur.

So, for a long time, namespaces couldn't be turned on unless SYSFS was
disabled.  Therefore, this code has largely been disabled except by
people turning it on explicitly for namespace development.

With help from Eugene Teo <eugene@redhat.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/exthdrs.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index df159ff..4bac362 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -559,6 +559,11 @@ static inline struct inet6_dev *ipv6_skb_idev(struct sk_buff *skb)
 	return skb_dst(skb) ? ip6_dst_idev(skb_dst(skb)) : __in6_dev_get(skb->dev);
 }
 
+static inline struct net *ipv6_skb_net(struct sk_buff *skb)
+{
+	return skb_dst(skb) ? dev_net(skb_dst(skb)->dev) : dev_net(skb->dev);
+}
+
 /* Router Alert as of RFC 2711 */
 
 static int ipv6_hop_ra(struct sk_buff *skb, int optoff)
@@ -580,8 +585,8 @@ static int ipv6_hop_ra(struct sk_buff *skb, int optoff)
 static int ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
 {
 	const unsigned char *nh = skb_network_header(skb);
+	struct net *net = ipv6_skb_net(skb);
 	u32 pkt_len;
-	struct net *net = dev_net(skb_dst(skb)->dev);
 
 	if (nh[optoff + 1] != 4 || (optoff & 3) != 2) {
 		LIMIT_NETDEBUG(KERN_DEBUG "ipv6_hop_jumbo: wrong jumbo opt length/alignment %d\n",
-- 
1.6.6

