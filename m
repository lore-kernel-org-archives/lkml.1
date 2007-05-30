Return-Path: <linux-kernel-owner+w=401wt.eu-S1751794AbXE3DPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbXE3DPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 23:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbXE3DPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 23:15:24 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbXE3DPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 23:15:23 -0400
Date: Tue, 29 May 2007 20:14:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/5] lockdep: sanitise CONFIG_PROVE_LOCKING
Message-Id: <20070529201450.52c3d50b.akpm@linux-foundation.org>
In-Reply-To: <20070529141617.GB12812@elte.hu>
References: <20070529125248.877196281@chello.nl>
	<20070529130106.864404378@chello.nl>
	<20070529132158.GA2192@infradead.org>
	<20070529141617.GB12812@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 16:16:17 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Tue, May 29, 2007 at 02:52:50PM +0200, Peter Zijlstra wrote:
> > > Ensure that all of the lock dependency tracking code is under
> > > CONFIG_PROVE_LOCKING. This allows us to use the held lock tracking code
> > > for other purposes.
> > 
> > There's an awfull lot of ifdefs introduced in this patch, I wonder 
> > whether it might be better to split up lockdep.c at those boundaries.
> 
> it adds 6 new #ifdefs. There's 35 #ifdefs in page_alloc.c, 44 in 
> sysctl.c and 64 in sched.c. I'd not call it 'an awful lot', although 
> certainly it could be reduced. Splitting lockdep.c up would uglify it 
> well beyond the impact of the 6 #ifdefs, given the amount of glue 
> needed.
> 

I'm not sure that we need to split lockdep.c, but it's a bit disappointing
that the patch didn't (couldn't?) move CONFIG_PROVE_LOCKING-only code and
data close together so that it can all fall within a single (or at least
fewer) ifdefs.

(Who came up with the (mis)name CONFIG_PROVE_LOCKING, btw?  Should have
been CONFIG_MIGHT_DISPROVE_LOCKING).

