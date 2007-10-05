Return-Path: <linux-kernel-owner+w=401wt.eu-S1764494AbXJEVbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764494AbXJEVbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763107AbXJEVb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:31:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46310
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbXJEVbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:31:25 -0400
Date: Fri, 05 Oct 2007 14:31:24 -0700 (PDT)
Message-Id: <20071005.143124.74549703.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: cebbert@redhat.com, willy@linux.intel.com, clameter@sgi.com,
       nickpiggin@yahoo.com.au, hch@lst.de, mel@skynet.ie,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dgc@sgi.com, jens.axboe@oracle.com, suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
From: David Miller <davem@davemloft.net>
In-Reply-To: <1191616320.5838.26.camel@lappy>
References: <20071004.135537.39158051.davem@davemloft.net>
	<470554D9.2050505@redhat.com>
	<1191616320.5838.26.camel@lappy>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 05 Oct 2007 22:32:00 +0200

> Focus on the slab allocator usage, instrument it, record a trace,
> generate a statistical model that matches, and write a small
> programm/kernel module that has the same allocation pattern. Then verify
> this statistical workload still shows the same performance difference.
> 
> Easy: no
> Doable: yes

The other important bit is likely to generate a lot of DMA traffic
such that the L2 cache bandwidth is getting used on the bus
side by the PCI controller doing invalidations of both dirty
and clean L2 cache lines as devices DMA to/from them.

This will also be exercising the memory controller, further contending
with the cpu when SLAB touches cold data structures.
