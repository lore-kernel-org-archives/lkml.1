Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZHYE37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZHYE37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 00:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZHYE36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 00:29:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZHYE35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 00:29:57 -0400
Date: Tue, 25 Aug 2009 06:29:56 +0200
From: Nick Piggin <npiggin@suse.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/pat] generic-ipi: Allow cpus not yet online to call smp_call_function with irqs disabled
Message-ID: <20090825042956.GU25721@wotan.suse.de>
References: <tip-269c861baa2fe7c114c3bc7831292758d29eb336@git.kernel.org> <20090824054026.GR25721@wotan.suse.de> <1251144943.2636.16.camel@sbs-t61>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251144943.2636.16.camel@sbs-t61>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 01:15:43PM -0700, Suresh B wrote:
> On Sun, 2009-08-23 at 22:40 -0700, Nick Piggin wrote:
> > On Fri, Aug 21, 2009 at 11:51:50PM +0000, Suresh B wrote:
> > > Commit-ID:  269c861baa2fe7c114c3bc7831292758d29eb336
> > > Gitweb:     http://git.kernel.org/tip/269c861baa2fe7c114c3bc7831292758d29eb336
> > > Author:     Suresh Siddha <suresh.b.siddha@intel.com>
> > > AuthorDate: Wed, 19 Aug 2009 18:05:35 -0700
> > > Committer:  H. Peter Anvin <hpa@zytor.com>
> > > CommitDate: Fri, 21 Aug 2009 16:25:43 -0700
> > > 
> > > generic-ipi: Allow cpus not yet online to call smp_call_function with irqs disabled
> > > 
> > > Because of deadlock possiblities smp_call_function() is not allowed to
> > > be called with interrupts disabled. Add an exception for the cpu not
> > > yet online, as no one else can send smp call function interrupt to this
> > > cpu that is not yet online and as such deadlock condition is not possible.
> > > 
> > > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > > Acked-by: Nick Piggin <npiggin@suse.de>
> > > Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> > 
> > I don't know if we should allow the use of smp_call_function here --
> > only call_function_single. CPU hotplug code is required to set up
> > some call_function data and if the cpu is offline then it might not
> > be set up correctly.
> 
> We are doing the required allocations in CPU_UP_PREPARE. So we should be
> okay for any smp_call_function usage.
 
OK

> > Also, I would say that we should just restrict this to wait==1 case
> > because in that case the stack can trivially be used for data. In
> > the wait==0 case, it is more complex. In the current implementation
> > it should be OK (it uses per-cpu data), but we've used kmalloc
> > there in the past, which probably wouldn't work either.
> 
> In future if we add any kmalloc, we already have checks in kmalloc()
> that can be easily caught. I would like to make this change as generic
> as possible.

Why? You think there will be much demand for it?

