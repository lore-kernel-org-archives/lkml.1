Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbYKBEkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbYKBEkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 00:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYKBEke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 00:40:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46541
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750794AbYKBEkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 00:40:33 -0400
Date: Sat, 01 Nov 2008 21:40:08 -0700 (PDT)
Message-Id: <20081101.214008.201420949.davem@davemloft.net>
To: fubar@us.ibm.com
Cc: shemminger@vyatta.com, dada1@cosmosbay.com, zbr@ioremap.net,
       ilpo.jarvinen@helsinki.fi, rjw@sisk.pl, mingo@elte.hu,
       s0mbre@tservice.net.ru, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, efault@gmx.de,
       akpm@linux-foundation.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: David Miller <davem@davemloft.net>
In-Reply-To: <22495.1225498593@death.nxdomain.ibm.com>
References: <20081031.165144.86556444.davem@davemloft.net>
	<20081031165620.7322b0e5@extreme>
	<22495.1225498593@death.nxdomain.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Vosburgh <fubar@us.ibm.com>
Date: Fri, 31 Oct 2008 17:16:33 -0700

> 	I suspect it could also be tucked away in skb_bond_should_drop,
> which is called both by the standard input path and the VLAN accelerated
> path to see if the packet should be tossed (e.g., it arrived on an
> inactive bonding slave).
> 
> 	Since last_rx is part of struct net_device, I don't think any
> additional bonding internals knowledge would be needed.  It could be
> arranged to only update last_rx for devices that are actually bonding
> slaves.
> 
> 	Just off the top of my head (haven't tested this), something
> like this:
 ...
> 
> 	That doesn't move the storage out of struct net_device, but it
> does stop the updates for devices that aren't bonding slaves.  It could
> probably be refined further to only update when the ARP monitor is
> running (the gizmo that uses last_rx).

I like this very much.

Jay can you give this a quick test by just trying this patch
and removing the ->last_rx setting in the driver you use for
your test?

Once you do that, I'll apply this to net-next-2.6 and do the
leg work to zap all of the ->last_rx updates from the entire tree.

Thanks!
