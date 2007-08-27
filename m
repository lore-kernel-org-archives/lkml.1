Return-Path: <linux-kernel-owner+w=401wt.eu-S932496AbXH0TbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbXH0TbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbXH0TbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:31:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:62810 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726AbXH0TbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:31:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,313,1183359600"; 
   d="scan'208";a="268614744"
Date: Mon, 27 Aug 2007 12:31:03 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] sched: fix broken smt/mc optimizations with CFS
Message-ID: <20070827193103.GF1894@linux-os.sc.intel.com>
References: <20070816010150.GG10033@linux-os.sc.intel.com> <20070823115416.GA31027@elte.hu> <20070823121341.GA5775@elte.hu> <20070827191905.GE1894@linux-os.sc.intel.com> <20070827192324.GA29441@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827192324.GA29441@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 09:23:24PM +0200, Ingo Molnar wrote:
> 
> * Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> 
> > > -	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task/2) {
> > > +	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task) {
> > 
> > Ingo, this is still broken. This condition is always false for nice-0 
> > tasks..
> 
> yes - negative reniced tasks are not spread out via this - and positive 
> reniced tasks are spread out more easily.

Or the opposite?

Essentially I observed that nice 0 tasks still endup on two cores of same
package, with out getting spread out to two different packages. This behavior
is same with out this fix and this fix doesn't help in any way.

thanks,
suresh
