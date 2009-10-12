Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbZJLSlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbZJLSlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610AbZJLSlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:41:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47745 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612AbZJLSlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:41:07 -0400
Date: Mon, 12 Oct 2009 20:40:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       David Howells <dhowells@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [RFC][PATCH] kmap_atomic_push
Message-ID: <20091012184028.GA20412@basil.fritz.box>
References: <1255016123.17055.17.camel@laptop> <87ws30fppe.fsf@basil.nowhere.org> <alpine.LFD.2.01.0910121124590.3438@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910121124590.3438@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 11:30:07AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 12 Oct 2009, Andi Kleen wrote:
> 
> > Peter Zijlstra <peterz@infradead.org> writes:
> > > -
> > > -static inline void debug_kmap_atomic(enum km_type type)
> > > +static inline int kmap_atomic_push_idx(void)
> > >  {
> > > +	int idx = __get_cpu_var(__kmap_atomic_depth)++;
> > 
> > The counter needs to be of local atomic type. Otherwise kmap_atomic cannot
> > be done from interrupts/nmis, which is unfortunately occasionally needed.
> 
> I thought so too on lookin gat it initially, but it's not actually true.
> 
> It's both IRQ and NMI safe as-is, for a very simple reason: any interrupts 

Good point, thanks.

I was thinking of CPU migration in interrupt cases, but even there
it should be ok in mainline.

I suppose it's not true for the preempt-rt folks (who can migrate
CPUs at any time), so it might be still more friendly to handle it for them 
though.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
