Return-Path: <linux-kernel-owner+w=401wt.eu-S936217AbXJQCXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936217AbXJQCXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761601AbXJQCXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:23:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:39765 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761223AbXJQCXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:23:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,286,1188802800"; 
   d="scan'208";a="299912210"
Date: Tue, 16 Oct 2007 19:23:03 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ken Chen <kenchen@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: fix improper load balance across sched domain
Message-ID: <20071017022303.GA27457@linux-os.sc.intel.com>
References: <b040c32a0710161207s4d6d4d4cq1fa7f0dd1a7f017d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0710161207s4d6d4d4cq1fa7f0dd1a7f017d@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 12:07:06PM -0700, Ken Chen wrote:
> We recently discovered a nasty performance bug in the kernel CPU load
> balancer where we were hit by 50% performance regression.
> 
> When tasks are assigned to a subset of CPUs that span across
> sched_domains (either ccNUMA node or the new multi-core domain) via
> cpu affinity, kernel fails to perform proper load balance at
> these domains, due to several logic in find_busiest_group() miss
> identified busiest sched group within a given domain. This leads to
> inadequate load balance and causes 50% performance hit.
> 
> To give you a concrete example, on a dual-core, 2 socket numa system,
> there are 4 logical cpu, organized as:

oops, this issue can easily happen when cores are not sharing caches. I
think this is what happening on your setup, right?

thanks,
suresh
