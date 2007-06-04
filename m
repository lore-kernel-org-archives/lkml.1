Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbXFDXyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbXFDXyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 19:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758733AbXFDXys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 19:54:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:43047 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757962AbXFDXyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 19:54:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="93466731"
Date: Mon, 4 Jun 2007 16:51:05 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, akpm@osdl.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routines for handling pre-allocated pool of objects
Message-ID: <20070604235105.GA13390@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070604210242.079459000@askeshav-devel.jf.intel.com> <20070604210644.156875000@askeshav-devel.jf.intel.com> <20070604225714.GM20299@havoc.gtf.org> <20070604230649.GB9948@linux-os.sc.intel.com> <20070604234354.GC31462@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604234354.GC31462@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 07:43:54PM -0400, Jeff Garzik wrote:
> On Mon, Jun 04, 2007 at 04:06:49PM -0700, Keshavamurthy, Anil S wrote:
> > On Mon, Jun 04, 2007 at 06:57:14PM -0400, Jeff Garzik wrote:
> > > you should add logic to free resources here (or queue_work to free the
> > > resources), if the pool grows beyond a certain size.
> 
> > Can be added as an add on, testing showed that pool 
> > grows to a certain size and will not grow beyond that 
> > as we tend to reuse the elements.
> 
> Yes, but is it possible?  If no, what part of the code guarantees the
> pool is limited?
> 
> We should not merge code that allows the pool to grow without bound.
> In-house testing certainly never covers all the cases seen in the
> field, so I wouldn't make too many assumptions based on that.  Some
> vendor will inevitably build a $BigNum system where the IOMMU is very
> heavily used.

No problem, I can add the code to free the pool element if
the curr_count ever goes greater than (min_count + 2 * grow_count)
then bring the curr_count to min_count + grow_count by freeing 
some pool objects.

A patch which will apply to this current patch will follow soon.

Thanks Jeff for making your case stronger :)

-Anil


> 
> 	Jeff
> 
