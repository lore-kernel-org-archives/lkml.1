Return-Path: <linux-kernel-owner+w=401wt.eu-S1751440AbXLRUJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbXLRUJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 15:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXLRUJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 15:09:28 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41786 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007AbXLRUJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 15:09:27 -0500
From: akepner@sgi.com
Date: Tue, 18 Dec 2007 12:07:59 -0800
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, grundler@parisc-linux.org,
       jbarnes@virtuousgeek.org, jes@sgi.com, randy.dunlap@oracle.com,
       rdreier@cisco.com, James.Bottomley@steeleye.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma: passing "attributes" to dma_map_* routines
Message-ID: <20071218200759.GE412@sgi.com>
References: <20071218001758.GO21916@sgi.com> <4767FA62.9060002@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4767FA62.9060002@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 05:50:42PM +0100, Stefan Richter wrote:

> Do I understand correctly?:  A device and the CPUs communicate via two
> separate memory areas:  A data buffer and a status FIFO.  The NUMA
> interconnect may reorder accesses of the device to the areas.  (Write
> accesses?  Read accesses?  Both?)

Yes, I think you understand. Reorderings are possible on reads and
writes. Things get synced up by either an interrupt or a write to
a memory region with a "barrier attribute". Memory allocated with
dma_alloc_coherent() gets the barrier attribute. The idea here is
to allow memory allocated with plain old malloc() or whatever to
get the same attribute.

> 
> To ensure synchronization between device and CPUs, you want to mark a
> memory area which is to be dma-mapped with a flag which says:  "Writes
> to the memory region will cause in-flight DMA to be flushed".  Whose
> writes?  A write access from the device or a write access from a CPU?

A write from the device, e.g., when the device writes to indicate
"data DMA is complete".

-- 
Arthur

