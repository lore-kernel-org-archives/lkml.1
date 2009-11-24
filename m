Return-Path: <linux-kernel-owner+w=401wt.eu-S933352AbZKXUqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352AbZKXUqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933178AbZKXUqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:46:43 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:53924 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280AbZKXUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:46:42 -0500
Message-ID: <4B0C4624.9080607@gmail.com>
Date: Tue, 24 Nov 2009 21:46:28 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: David Miller <davem@davemloft.net>, peter.p.waskiewicz.jr@intel.com,
       peterz@infradead.org, arjan@linux.intel.com, yong.zhang0@gmail.com,
       linux-kernel@vger.kernel.org, arjan@linux.jf.intel.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter irqbalance
 hints
References: <20091124.093956.247147202.davem@davemloft.net>	<1259085412.2631.48.camel@ppwaskie-mobl2> <4B0C2547.8030408@gmail.com>	<20091124.105442.06273019.davem@davemloft.net>	<4B0C2CCA.6030006@gmail.com> <87iqczwtia.fsf@basil.nowhere.org>
In-Reply-To: <87iqczwtia.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 24 Nov 2009 21:46:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> They are typically allocated with dma_alloc_coherent(), which does
> allocate a continuous area.  In theory you could do interleaving
> with IOMMus, but just putting it on the same node as the device
> is probably better.

There are two parts, biggest one allocated with vmalloc()
(to hold struct ixgbe_rx_buffer array, 32 bytes or more per entry),
only used by driver (not adapter)

and one allocated with pci_alloc_consistent() 
(to hold ixgbe_adv_tx_desc array, 16 bytes per entry)

vmalloc() one could be spreaded on many nodes.
I am not speaking about the pci_alloc_consistent() one :)


