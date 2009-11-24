Return-Path: <linux-kernel-owner+w=401wt.eu-S933850AbZKXS03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850AbZKXS03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933754AbZKXS02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:26:28 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:58086 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933743AbZKXS02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:26:28 -0500
Message-ID: <4B0C2547.8030408@gmail.com>
Date: Tue, 24 Nov 2009 19:26:15 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
CC: David Miller <davem@davemloft.net>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "yong.zhang0@gmail.com" <yong.zhang0@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter irqbalance
 hints
References: <1258995923.4531.715.camel@laptop>	 <4B0B782A.4030901@linux.intel.com>	<1259051986.4531.1057.camel@laptop>	 <20091124.093956.247147202.davem@davemloft.net> <1259085412.2631.48.camel@ppwaskie-mobl2>
In-Reply-To: <1259085412.2631.48.camel@ppwaskie-mobl2>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 24 Nov 2009 19:26:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter P Waskiewicz Jr a écrit :
 That's the kind of thing PJ is trying to make available.
> 
> Yes, that's exactly what I'm trying to do.  Even further, we want to
> allocate the ring SW struct itself and descriptor structures on other
> NUMA nodes, and make sure the interrupt lines up with those allocations.
> 

Say you allocate ring buffers on NUMA node of the CPU handling interrupt
on a particular queue.

If irqbalance or an admin changes /proc/irq/{number}/smp_affinities,
do you want to realloc ring buffer to another NUMA node ?

It seems complex to me, maybe optimal thing would be to use a NUMA policy to
spread vmalloc() allocations to all nodes to get a good bandwidth...

