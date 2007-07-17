Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbXGQTcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbXGQTcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbXGQTcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:32:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:8644 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbXGQTco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:32:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,547,1175497200"; 
   d="scan'208";a="251614468"
Date: Tue, 17 Jul 2007 12:27:18 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, travis@sgi.com,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: x86: Convert cpu_core_map to be a per cpu variable
Message-ID: <20070717192718.GF3318@linux-os.sc.intel.com>
References: <Pine.LNX.4.64.0707122354340.17278@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707122354340.17278@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 11:58:06PM -0700, Christoph Lameter wrote:
> cpu_core_map is currently an array defined using NR_CPUS. This means that
> we overallocate since we will rarely really use the maximum 
> number of configured cpus. This may become a problem when we need to 
> increase the NR_CPUs on x86_64 for our new product line.
> 
> If we put the cpu_core_map into the per cpu area then it will be allocated
> for each processor as it comes online.
> 
> However, this means that the core map cannot be accessed until the per cpu 
> area has been allocated. Xen does a weird thing here looping over all 
> processors and zeroing the masks that are not yet allocated and that will 
> be zeroed when they are allocated. I commented the code out. Maybe there 
> is another purpose? Jeremy?

Is there a reason why cpu_sibling_map[] is left out in these changes?

thanks,
suresh
