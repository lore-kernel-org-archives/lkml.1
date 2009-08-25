Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZHYR5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZHYR5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 13:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbZHYR5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 13:57:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:7095 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457AbZHYR5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 13:57:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,273,1249282800"; 
   d="scan'208";a="487263192"
Subject: Re: [tip:x86/pat] generic-ipi: Allow cpus not yet online to call
 smp_call_function with irqs disabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <20090825042956.GU25721@wotan.suse.de>
References: <tip-269c861baa2fe7c114c3bc7831292758d29eb336@git.kernel.org>
	 <20090824054026.GR25721@wotan.suse.de> <1251144943.2636.16.camel@sbs-t61>
	 <20090825042956.GU25721@wotan.suse.de>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 25 Aug 2009 10:56:53 -0700
Message-Id: <1251223013.2612.11.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 21:29 -0700, Nick Piggin wrote:
> On Mon, Aug 24, 2009 at 01:15:43PM -0700, Suresh B wrote:
> > On Sun, 2009-08-23 at 22:40 -0700, Nick Piggin wrote:
> > > Also, I would say that we should just restrict this to wait==1 case
> > > because in that case the stack can trivially be used for data. In
> > > the wait==0 case, it is more complex. In the current implementation
> > > it should be OK (it uses per-cpu data), but we've used kmalloc
> > > there in the past, which probably wouldn't work either.
> > 
> > In future if we add any kmalloc, we already have checks in kmalloc()
> > that can be easily caught. I would like to make this change as generic
> > as possible.
> 
> Why? You think there will be much demand for it?

In the current mtrr case, we currently use wait==0

Also unless there are issues, I would like to keep it open. So that it
will encourage more usages and expose any other bugs that we perhaps
overlooked.

With all the recent generic-ipi changes, even for online cpu's, we
should be able to allow smp_call_function() with interrupts disabled for
wait==0 case, right?

thanks,
suresh

