Return-Path: <linux-kernel-owner+w=401wt.eu-S936284AbZLQEJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936284AbZLQEJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935738AbZLQEIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:08:48 -0500
Received: from kroah.org ([198.145.64.141]:56079 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936176AbZLQEFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:54 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:01 2009
Message-Id: <20091217035701.412090427@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Deon van der Merwe <dvdm@truteq.co.za>, Julian Anastasov <ja@ssi.bg>,
       Simon Horman <horms@verge.net.au>, Patrick McHardy <kaber@trash.net>
Subject: [142/151] ipvs: zero usvc and udest
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Simon Horman <horms@verge.net.au>

commit 258c889362aa95d0ab534b38ce8c15d3009705b1 upstream.

Make sure that any otherwise uninitialised fields of usvc are zero.

This has been obvserved to cause a problem whereby the port of
fwmark services may end up as a non-zero value which causes
scheduling of a destination server to fail for persisitent services.

As observed by Deon van der Merwe <dvdm@truteq.co.za>.
This fix suggested by Julian Anastasov <ja@ssi.bg>.

For good measure also zero udest.

Cc: Deon van der Merwe <dvdm@truteq.co.za>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/ipvs/ip_vs_ctl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2714,6 +2714,8 @@ static int ip_vs_genl_parse_service(stru
 	if (!(nla_af && (nla_fwmark || (nla_port && nla_protocol && nla_addr))))
 		return -EINVAL;
 
+	memset(usvc, 0, sizeof(*usvc));
+
 	usvc->af = nla_get_u16(nla_af);
 #ifdef CONFIG_IP_VS_IPV6
 	if (usvc->af != AF_INET && usvc->af != AF_INET6)
@@ -2901,6 +2903,8 @@ static int ip_vs_genl_parse_dest(struct 
 	if (!(nla_addr && nla_port))
 		return -EINVAL;
 
+	memset(udest, 0, sizeof(*udest));
+
 	nla_memcpy(&udest->addr, nla_addr, sizeof(udest->addr));
 	udest->port = nla_get_u16(nla_port);
 


