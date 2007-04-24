Return-Path: <linux-kernel-owner+w=401wt.eu-S1422907AbXDXRv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422907AbXDXRv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422909AbXDXRv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:51:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:23366 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422907AbXDXRv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:51:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="78447120:sNHT37348245"
Date: Tue, 24 Apr 2007 10:50:01 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070424175001.GF5475@linux-os.sc.intel.com>
References: <Pine.LNX.4.64.0704201223280.21417@schroedinger.engr.sgi.com> <20070420192906.GB2986@holomorphy.com> <Pine.LNX.4.64.0704201231250.21514@schroedinger.engr.sgi.com> <20070420193856.GC2986@holomorphy.com> <Pine.LNX.4.64.0704201243280.21514@schroedinger.engr.sgi.com> <20070420200322.GD2986@holomorphy.com> <20070420201101.GC5475@linux-os.sc.intel.com> <Pine.LNX.4.64.0704241039110.8341@schroedinger.engr.sgi.com> <20070424174226.GE5475@linux-os.sc.intel.com> <Pine.LNX.4.64.0704241045160.8418@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704241045160.8418@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 10:47:45AM -0700, Christoph Lameter wrote:
> On Tue, 24 Apr 2007, Siddha, Suresh B wrote:
> > Anyhow, this is a straight forward optimization and needs to be done. Do you
> > have any specific concerns?
> 
> Yes there should not be contention on per cpu data in principle. The 
> point of per cpu data is for the cpu to have access to contention free 
> cachelines.
> 
> If the data is contented then it should be moved out of per cpu data and properly 
> placed to minimize contention. Otherwise we will get into cacheline 
> aliases (__read_mostly in per cpu??) etc etc in the per cpu areas.

yes, we were planning to move this to a different percpu section, where
all the elements in this new section will be cacheline aligned(both
at the start, aswell as end)

thanks,
suresh
