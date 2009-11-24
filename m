Return-Path: <linux-kernel-owner+w=401wt.eu-S933932AbZKXS63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932AbZKXS63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933133AbZKXS63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:58:29 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:57258 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790AbZKXS62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:58:28 -0500
Message-ID: <4B0C2CCA.6030006@gmail.com>
Date: Tue, 24 Nov 2009 19:58:18 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: peter.p.waskiewicz.jr@intel.com, peterz@infradead.org,
       arjan@linux.intel.com, yong.zhang0@gmail.com,
       linux-kernel@vger.kernel.org, arjan@linux.jf.intel.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter irqbalance
 hints
References: <20091124.093956.247147202.davem@davemloft.net>	<1259085412.2631.48.camel@ppwaskie-mobl2>	<4B0C2547.8030408@gmail.com> <20091124.105442.06273019.davem@davemloft.net>
In-Reply-To: <20091124.105442.06273019.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 24 Nov 2009 19:58:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Tue, 24 Nov 2009 19:26:15 +0100
> 
>> It seems complex to me, maybe optimal thing would be to use a NUMA policy to
>> spread vmalloc() allocations to all nodes to get a good bandwidth...
> 
> vmalloc() and sk_buff's don't currently mix and I really don't see us
> every allowing them to :-)

I think Peter was referring to tx/rx rings buffers, not sk_buffs.

They (ring buffers) are allocated with vmalloc() at driver init time.

And Tom pointed out that our rx sk_buff allocation should be using the node
of requester, no need to hardcode node number per rx queue (or per device as of today)


