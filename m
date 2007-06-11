Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbXFKVnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbXFKVnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbXFKVnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:43:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:19481 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbXFKVnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:43:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="95558936"
Date: Mon, 11 Jun 2007 02:46:39 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Message-ID: <20070611094638.GA18008@araj-amd64.jf.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <200706090056.49279.ak@suse.de> <Pine.LNX.4.64.0706081558090.4373@schroedinger.engr.sgi.com> <200706091147.24705.ak@suse.de> <20070611204442.GA4074@linux-os.sc.intel.com> <20070611141449.bfbc4769.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611141449.bfbc4769.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 02:14:49PM -0700, Andrew Morton wrote:
> > 
> > Again, if dma_map_{single|sg} API's fails due to 
> > failure to allocate memory, the only thing that can
> > be done is to panic as this is what few of the other 
> > IOMMU implementation is doing today. 
> 
> If the only option is to panic then something's busted.  If it's network IO
> then there should be a way of dropping the frame.  If it's disk IO then we
> should report the failure and cause an IO error.

Just looking at the code.. appears that quite a few popular ones (or should say most) dont even look at the dma_addr_t returned to check for failure.

Thats going to be another major cleanup work.
