Return-Path: <linux-kernel-owner+w=401wt.eu-S936637AbXLRAb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936637AbXLRAb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935631AbXLRAbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:31:04 -0500
Received: from relay2.sgi.com ([192.48.171.30]:35642 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933110AbXLRAbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:31:03 -0500
X-Greylist: delayed 696 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2007 19:31:02 EST
From: akepner@sgi.com
Date: Mon, 17 Dec 2007 16:17:58 -0800
To: Andrew Morton <akpm@linux-foundation.org>, grundler@parisc-linux.org,
       jbarnes@virtuousgeek.org, jes@sgi.com, randy.dunlap@oracle.com,
       rdreier@cisco.com, James.Bottomley@steeleye.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] dma: passing "attributes" to dma_map_* routines
Message-ID: <20071218001758.GO21916@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Waaay back in October I sent some patches for passing additional 
attributes to the dma_map_* routines:

http://marc.info/?l=linux-kernel&m=119137949604365&w=2

This is somthing needed for ia64 Altix NUMA machines (as described 
in that thread).

Several folks objected to the approach I used - it was a bit of a 
hack - and so these patches were dropped. 

This time I'd like to get something resembling concensus before 
spending much time on this. 

Can you please comment on the options listed here, or suggest 
alternatives?

We could:

1) add an additional parameter to the dma_map_* routines, somthing 
   like:

     dma_map_single(struct device *dev, void *cpu_addr, size_t size,
                    enum dma_data_direction direction, u32 flags)
     ....

2) change the "direction" argument to be a field of bits:

     dma_map_single(struct device *dev, void *cpu_addr, size_t size,
                    u32 flags)
     ....

     where flags encodes the direction and optionally other attributes.

3) add new functions to the dma interface, e.g.:

     dma_map_single_attrs(struct device *dev, void *cpu_addr, size_t size,
                          enum dma_data_direction direction, u32 attrs)
     .....

1) and 2) are going to require many minor changes, and 3) is going 
to pollute the dma interface a bit. 

Other ideas?

-- 
Arthur

