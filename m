Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZCZK5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZCZK5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 06:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZCZK5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 06:57:15 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:40648 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbZCZK5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 06:57:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18891.24450.489196.961004@cargo.ozlabs.ibm.com>
Date: Thu, 26 Mar 2009 21:57:06 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH 2/3] perf_counter: executable mmap() information
In-Reply-To: <20090326100058.GD19826@elte.hu>
References: <20090325210419.408653980@chello.nl>
	<20090325210542.293237509@chello.nl>
	<18891.6159.109191.255560@drongo.ozlabs.ibm.com>
	<20090326100058.GD19826@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > Peter Zijlstra writes:
> > 
> > > --- linux-2.6.orig/include/linux/perf_counter.h
> > > +++ linux-2.6/include/linux/perf_counter.h
> > > @@ -137,7 +137,9 @@ struct perf_counter_hw_event {
> > >  				exclude_kernel :  1, /* ditto kernel          */
> > >  				exclude_hv     :  1, /* ditto hypervisor      */
> > >  				exclude_idle   :  1, /* don't count when idle */
> > > -				include_tid    :  1, /* include the tid */
> > > +				include_tid    :  1, /* include the tid       */
> > > +				mmap           :  1, /* include mmap data     */
> > > +				munmap         :  1, /* include munmap data   */
> > >  
> > >  				__reserved_1   : 54;
> > 
> > Nit: need to adjust the size of __reserved_1 here.  Or maybe just 
> > get rid of it?
> 
> it's nice to have a constant reminder about how many bits there are 
> left.

Fair enough, but as it stands, we've changed the ABI, so we need to
fix it.

Paul.
