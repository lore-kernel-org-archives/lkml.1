Return-Path: <linux-kernel-owner+w=401wt.eu-S935016AbYEBNJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935016AbYEBNJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759564AbYEBNJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:09:27 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:32981 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbYEBNJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:09:26 -0400
Date: Fri, 2 May 2008 06:09:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Keith Owens <kaos@ocs.com.au>
Cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
Message-ID: <20080502130922.GC15522@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080502122955.GB15522@linux.vnet.ibm.com> <27854.1209732644@ocs10w>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27854.1209732644@ocs10w>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 10:50:44PM +1000, Keith Owens wrote:
> "Paul E. McKenney" (on Fri, 2 May 2008 05:29:55 -0700) wrote:
> >OK -- for some reason, I was thinking that it was illegal to
> >invoke smp_call_function() with irqs disabled...
> >
> >Ah, I see it -- smp_call_function_mask() says:
> >
> > * You must not call this function with disabled interrupts or from a
> > * hardware interrupt handler or from a bottom half handler.
> >
> >So we have no problem with smp_call_function, then.
> >
> >OK, so smp_call_function() -can- be invoked with irqs disabled?
> >Hmmm...  I will give this some thought.
> 
> Doing any smp_call_function with interrupts disabled is a potential
> deadlock.  See http://lkml.org/lkml/2004/5/2/116.

OK, cool, thank you for the confirmation!

Therefore, when you call smp_call_function(), you may get calls from
other CPUs showing up, and therefore my polling approach does not
introduce any new strands of spaghetti.  ;-)

						Thanx, Paul
