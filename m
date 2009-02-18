Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZBRCRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZBRCRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 21:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZBRCQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 21:16:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:57576 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbZBRCQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 21:16:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,225,1233561600"; 
   d="scan'208";a="111693707"
Subject: Re: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove	single
	ipi fallback for smp_call_function_many())
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
In-Reply-To: <20090217155147.GE6761@linux.vnet.ibm.com>
References: <1234818201.30178.386.camel@laptop>
	 <20090216213205.GA9098@redhat.com> <1234820704.30178.396.camel@laptop>
	 <20090216220214.GA10093@redhat.com> <1234823097.30178.406.camel@laptop>
	 <20090216231946.GA12009@redhat.com> <1234862974.4744.31.camel@laptop>
	 <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop>
	 <20090217112657.GE26402@wotan.suse.de>
	 <20090217155147.GE6761@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 17 Feb 2009 18:15:31 -0800
Message-Id: <1234923331.29823.2.camel@vayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 07:51 -0800, Paul E. McKenney wrote:
> On Tue, Feb 17, 2009 at 12:26:57PM +0100, Nick Piggin wrote:
> > +	spin_lock(&q->lock);
> > +	list_replace_init(&q->list, &list);
> > +	spin_unlock(&q->lock);
> 
> OK, I'll bite...
> 
> How do we avoid deadlock in the case where a pair of CPUs send to each
> other concurrently?

Sender takes the lock with interrupts-disabled. That should prevent any
deadlock, right?

