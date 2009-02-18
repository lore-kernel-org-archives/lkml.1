Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZBRSp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZBRSp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZBRSpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:45:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:3059 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbZBRSpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:45:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,230,1233561600"; 
   d="scan'208";a="111959359"
Subject: Re: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single
	ipi fallback for smp_call_function_many())
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Oleg Nesterov <oleg@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
In-Reply-To: <20090218135945.GC23125@wotan.suse.de>
References: <20090216213205.GA9098@redhat.com>
	 <1234820704.30178.396.camel@laptop> <20090216220214.GA10093@redhat.com>
	 <1234823097.30178.406.camel@laptop> <20090216231946.GA12009@redhat.com>
	 <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de>
	 <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de>
	 <1234923702.29823.7.camel@vayu>  <20090218135945.GC23125@wotan.suse.de>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 18 Feb 2009 10:43:40 -0800
Message-Id: <1234982620.29823.22.camel@vayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 05:59 -0800, Nick Piggin wrote:
> You're saying the problem is in generic_exec_single because I've
> removed the smp_mb that inadvertently also serialises memory with
> the x2apic on x86?

yes.

> 
> Indeed that could cause problems on some architectures which I
> had hoped to avoid. So the patch is probably better off to first
> add the smp_mb() to arch_send_call_function_xxx arch code, unless
> it is immediately obvious or confirmed by arch maintainer that
> such barrier is not required.

For x2apic specific operations we should add the smp_mb() sequence. But
we need to make sure that we don't end up doing it twice (once in
generic code and another in arch code) for all the ipi paths.

thanks,
suresh

