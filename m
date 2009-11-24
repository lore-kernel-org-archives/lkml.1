Return-Path: <linux-kernel-owner+w=401wt.eu-S933741AbZKXR4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbZKXR4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933693AbZKXR4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:56:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:22992 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933680AbZKXR4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:56:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,280,1257148800"; 
   d="scan'208";a="215276541"
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter
 irqbalance hints
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "yong.zhang0@gmail.com" <yong.zhang0@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <20091124.093956.247147202.davem@davemloft.net>
References: <1258995923.4531.715.camel@laptop>
	 <4B0B782A.4030901@linux.intel.com>	<1259051986.4531.1057.camel@laptop>
	 <20091124.093956.247147202.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 24 Nov 2009 09:56:52 -0800
Message-Id: <1259085412.2631.48.camel@ppwaskie-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 09:39 -0800, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Tue, 24 Nov 2009 09:39:46 +0100
> 
> > On Mon, 2009-11-23 at 22:07 -0800, Arjan van de Ven wrote:
> >> the problem is that there is no way currently that the driver can communicate
> >> "I allocated all my metadata on THIS numa node". irqbalance and sysadmins need
> >> that to not make really stupid decisions.....
> > 
> > And what exactly is struct device::numa_node good for then?
> 
> device->numa_node just says where the device is.
> 
> For better performance, it can make sense to, for example, allocate the ring
> buffers for different device queues on other NUMA nodes.
> 
> That's the kind of thing PJ is trying to make available.

Yes, that's exactly what I'm trying to do.  Even further, we want to
allocate the ring SW struct itself and descriptor structures on other
NUMA nodes, and make sure the interrupt lines up with those allocations.

Cheers,
-PJ

