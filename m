Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbZDODYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbZDODYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZDODYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:24:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46963
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753491AbZDODYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:24:08 -0400
Date: Tue, 14 Apr 2009 20:23:59 -0700 (PDT)
Message-Id: <20090414.202359.07968871.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: dada1@cosmosbay.com, jeff.chua.linux@gmail.com, kaber@trash.net,
       paulmck@linux.vnet.ibm.com, paulus@samba.org, mingo@elte.hu,
       torvalds@linux-foundation.org, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v3)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090414141351.0f63ac98@nehalam>
References: <20090414111716.28585806@nehalam>
	<49E4E3E8.5090201@cosmosbay.com>
	<20090414141351.0f63ac98@nehalam>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Tue, 14 Apr 2009 14:13:51 -0700

> This is an alternative version of ip/ip6/arp tables locking using
> per-cpu locks.  This avoids the overhead of synchronize_net() during
> update but still removes the expensive rwlock in earlier versions.
> 
> The idea for this came from an earlier version done by Eric Dumazet.
> Locking is done per-cpu, the fast path locks on the current cpu
> and updates counters.  The slow case involves acquiring the locks on
> all cpu's.
> 
> The mutex that was added for 2.6.30 in xt_table is unnecessary since
> there already is a mutex for xt[af].mutex that is held.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Things seem to be winding down, good. :-)

I'll let Patrick McHardy merge this to me with his other pending
netfilter fixes.

Thanks!
