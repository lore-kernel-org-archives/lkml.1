Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZCEEy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZCEEy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 23:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZCEEyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 23:54:47 -0500
Received: from tau.jukie.net ([216.239.93.128]:45950 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZCEEyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 23:54:46 -0500
Date: Wed, 4 Mar 2009 23:54:42 -0500
From: Bart Trojanowski <bart@jukie.net>
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, greearb@candelatech.com, shemminger@vyatta.com,
       dada1@cosmosbay.com, frank.blaschka@de.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.29-rc* QinQ vlan trunking regression
Message-ID: <20090305045442.GF5959@jukie.net>
References: <49AE509B.3000305@trash.net> <20090304.025914.149394356.davem@davemloft.net> <49AE69DD.80802@trash.net> <20090304.195328.106253933.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304.195328.106253933.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

* David Miller <davem@davemloft.net> [090304 22:53]:
> vlan: Fix vlan-in-vlan crashes.
> 
> As analyzed by Patrick McHardy, vlan needs to reset it's
> netdev_ops pointer in it's ->init() function but this
> leaves the compat method pointers stale.
> 
> Add a netdev_resync_ops() and call it from the vlan code.
<snip>
>  include/linux/netdevice.h |    1 +
>  net/8021q/vlan_dev.c      |    1 +
>  net/core/dev.c            |   54 +++++++++++++++++++++++++++-----------------
>  3 files changed, 35 insertions(+), 21 deletions(-)

I tried this patch onto v2.6.29-rc7-3-g559595a, but I still get a crash.
I assume that this worked for you, so I am not putting much faith in my
results at this late hour.  I'll confirm tomorrow morning that it's not
something else.

Cheers,
-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
