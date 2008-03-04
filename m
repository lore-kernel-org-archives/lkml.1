Return-Path: <linux-kernel-owner+w=401wt.eu-S1763693AbYCDKcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763693AbYCDKcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 05:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbYCDKco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 05:32:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbYCDKco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:32:44 -0500
Date: Tue, 4 Mar 2008 11:32:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, hpa@zytor.com, tglx@linutronix.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
Message-ID: <20080304103220.GA17621@elte.hu>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080303230336.042604000@linux-os.sc.intel.com> <20080304012012.GB22431@infradead.org> <20080304014306.GC28006@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304014306.GC28006@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Mon, Mar 03, 2008 at 08:20:12PM -0500, Christoph Hellwig wrote:
> > On Mon, Mar 03, 2008 at 03:02:46PM -0800, Suresh Siddha wrote:
> > > +	/*
> > > +	 * Memory allocation at the first usage of the FPU and other state.
> > > +	 */
> > > +	if (!tsk->thread.xstate)
> > > +		tsk->thread.xstate = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
> >
> >  Also don't we need some kind of error handling here?
> 
> Currently it uses SLAB_PANIC.

but SLAB_PANIC only covers kmem_cache_create() failures. 

kmem_cache_alloc() can fail (return NULL) and not handling it is a bug.

	Ingo
