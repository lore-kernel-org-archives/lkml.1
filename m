Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbXLTU63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbXLTU63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbXLTU54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:57:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:39146 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbXLTU5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:57:54 -0500
Subject: Re: [RFC] dma: passing "attributes" to dma_map_* routines
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: akepner@sgi.com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>, grundler@parisc-linux.org,
       jbarnes@virtuousgeek.org, jes@sgi.com, randy.dunlap@oracle.com,
       rdreier@cisco.com, James.Bottomley@steeleye.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071218200759.GE412@sgi.com>
References: <20071218001758.GO21916@sgi.com>
	 <4767FA62.9060002@s5r6.in-berlin.de>  <20071218200759.GE412@sgi.com>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 07:56:25 +1100
Message-Id: <1198184185.6779.16.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-18 at 12:07 -0800, akepner@sgi.com wrote:
> On Tue, Dec 18, 2007 at 05:50:42PM +0100, Stefan Richter wrote:
> 
> > Do I understand correctly?:  A device and the CPUs communicate via two
> > separate memory areas:  A data buffer and a status FIFO.  The NUMA
> > interconnect may reorder accesses of the device to the areas.  (Write
> > accesses?  Read accesses?  Both?)
> 
> Yes, I think you understand. Reorderings are possible on reads and
> writes. Things get synced up by either an interrupt or a write to
> a memory region with a "barrier attribute". Memory allocated with
> dma_alloc_coherent() gets the barrier attribute. The idea here is
> to allow memory allocated with plain old malloc() or whatever to
> get the same attribute.
> 
> > 
> > To ensure synchronization between device and CPUs, you want to mark a
> > memory area which is to be dma-mapped with a flag which says:  "Writes
> > to the memory region will cause in-flight DMA to be flushed".  Whose
> > writes?  A write access from the device or a write access from a CPU?
> 
> A write from the device, e.g., when the device writes to indicate
> "data DMA is complete".

Can't you just have a primitive to sync things up that you call
explicitely from your driver after fetching a new status entry ?

Ben.


