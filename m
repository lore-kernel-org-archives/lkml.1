Return-Path: <linux-kernel-owner+w=401wt.eu-S1763606AbYDPWS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763606AbYDPWS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYDPWST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:18:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:1455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbYDPWSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:18:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,666,1199692800"; 
   d="scan'208";a="317925321"
Date: Wed, 16 Apr 2008 15:18:17 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080416221817.GE14062@linux-os.sc.intel.com>
References: <20080416202338.GA6007@elte.hu> <adar6d5ilit.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar6d5ilit.fsf@cisco.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 01:37:30PM -0700, Roland Dreier wrote:
>  >  - PAT support - first step towards phasing out MTRR's for cache 
>  >    attribute control
> 
> I just grabbed your tree and I see that there is no
> pgprot_writecombine() for x86.  I see that pci_mmap_page_range() handles
> write combining but there's no way for a PCI driver to allow userspace
> to mmap() part of a BAR with WC enabled.  Doing this gives a big
> performance boost for running low-latency apps on InfiniBand hardware
> driven by the mlx4 driver (look for the FIXME about it in
> drivers/infiniband/hw/mlx4/main.c).  Are there any plans to handle this
> somehow?

Yes. We are planning to fix this by tracking the attribute usage specified
in the pgprot field of remap_pfn_range(). Once the attribute is tracked
properly, we can add pgprot_writecombine() for WC case.

This should also help the other drivers like video fb etc which specify
the UC/WC attribute for user level mmap.

thanks,
suresh
