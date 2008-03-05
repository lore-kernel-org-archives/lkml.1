Return-Path: <linux-kernel-owner+w=401wt.eu-S934789AbYCFOqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789AbYCFOqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 09:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbYCFOqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 09:46:13 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2001 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759545AbYCFOqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 09:46:11 -0500
Date: Wed, 5 Mar 2008 20:47:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
Message-ID: <20080305194705.GA4386@ucw.cz>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080303230336.042604000@linux-os.sc.intel.com> <20080304012012.GB22431@infradead.org> <20080304014306.GC28006@linux-os.sc.intel.com> <20080304103220.GA17621@elte.hu> <20080304175528.GD28006@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304175528.GD28006@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-03-04 09:55:28, Suresh Siddha wrote:
> On Tue, Mar 04, 2008 at 11:32:20AM +0100, Ingo Molnar wrote:
> > 
> > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > 
> > > On Mon, Mar 03, 2008 at 08:20:12PM -0500, Christoph Hellwig wrote:
> > > > On Mon, Mar 03, 2008 at 03:02:46PM -0800, Suresh Siddha wrote:
> > > > > +	/*
> > > > > +	 * Memory allocation at the first usage of the FPU and other state.
> > > > > +	 */
> > > > > +	if (!tsk->thread.xstate)
> > > > > +		tsk->thread.xstate = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
> > > >
> > > >  Also don't we need some kind of error handling here?
> > > 
> > > Currently it uses SLAB_PANIC.
> > 
> > but SLAB_PANIC only covers kmem_cache_create() failures. 
> > 
> > kmem_cache_alloc() can fail (return NULL) and not handling it is a bug.
> 
> oops. you are correct. Will send a sigsegv in the failure case then. Thanks.

You are introducing possibility of hard to debug error, where previous
code just worked... Does not look like good idea to me.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
