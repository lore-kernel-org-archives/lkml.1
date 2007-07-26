Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbXGZBMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbXGZBMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 21:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbXGZBLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 21:11:50 -0400
Received: from [12.38.223.190] ([12.38.223.190]:1158 "EHLO
	mail.sw.starentnetworks.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752281AbXGZBLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 21:11:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18087.62656.490978.692574@zeus.sw.starentnetworks.com>
Date: Wed, 25 Jul 2007 21:11:28 -0400
From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       lksctp-developers@lists.sourceforge.net, sakkiped@starentnetworks.com
Subject: Re: [PATCH] IPv6: ipv6_addr_type() doesn't know about RFC4193 addresses
In-Reply-To: <20070725.171203.102545287.davem@davemloft.net>
References: <18087.57717.495366.413571@zeus.sw.starentnetworks.com>
	<20070725.171203.102545287.davem@davemloft.net>
X-Mailer: VM 7.17 under 21.4 (patch 17) "Jumbo Shrimp" XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
> Contrarily, there may be ipv6_addr_type() call sites that really
> do want to reject rfc4193 addresses.

A quick look through the callers and only these functions should be
effected, they check either RESERVED or UNICAST from ipv6_addr_type():

net/ipv6/addrconf.c:                ipv6_dev_get_saddr()
net/ipv6/exthdrs.c:                 ipv6_dest_hao()   
net/ipv6/ip6_tunnel.c:              ip6_tnl_set_cap()
net/ipv6/netfilter/ip6t_REJECT.c:   send_reset()
net/ipv6/route.c:                   ip6_route_add()
net/ipv6/route.c:                   ip6_pkt_drop()
net/sctp/ipv6.c:                    sctp_v6_available()
net/sctp/ipv6.c:                    sctp_v6_addr_valid()

-- 
Dave Johnson
Starent Networks

