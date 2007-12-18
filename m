Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbXLRQvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbXLRQvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 11:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbXLRQvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 11:51:18 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:45603 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbXLRQvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 11:51:17 -0500
Message-ID: <4767FA62.9060002@s5r6.in-berlin.de>
Date: Tue, 18 Dec 2007 17:50:42 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: akepner@sgi.com
CC: Andrew Morton <akpm@linux-foundation.org>, grundler@parisc-linux.org,
       jbarnes@virtuousgeek.org, jes@sgi.com, randy.dunlap@oracle.com,
       rdreier@cisco.com, James.Bottomley@steeleye.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma: passing "attributes" to dma_map_* routines
References: <20071218001758.GO21916@sgi.com>
In-Reply-To: <20071218001758.GO21916@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akepner@sgi.com wrote:
> Waaay back in October I sent some patches for passing additional 
> attributes to the dma_map_* routines:
> 
> http://marc.info/?l=linux-kernel&m=119137949604365&w=2

Do I understand correctly?:  A device and the CPUs communicate via two
separate memory areas:  A data buffer and a status FIFO.  The NUMA
interconnect may reorder accesses of the device to the areas.  (Write
accesses?  Read accesses?  Both?)

To ensure synchronization between device and CPUs, you want to mark a
memory area which is to be dma-mapped with a flag which says:  "Writes
to the memory region will cause in-flight DMA to be flushed".  Whose
writes?  A write access from the device or a write access from a CPU?
-- 
Stefan Richter
-=====-=-=== ==-- =--=-
http://arcgraph.de/sr/
