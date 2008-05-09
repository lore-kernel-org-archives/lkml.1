Return-Path: <linux-kernel-owner+w=401wt.eu-S1763972AbYEINzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763972AbYEINzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 09:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYEINzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 09:55:00 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34044 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753647AbYEINy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 09:54:59 -0400
Date: Fri, 9 May 2008 09:53:50 -0400
From: Theodore Tso <tytso@mit.edu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hugh@veritas.com>, Glauber Costa <gcosta@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: Possible regression?  2.6.26-rc1: T61s failure after
	suspend/resume
Message-ID: <20080509135350.GA9681@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Peter Zijlstra <peterz@infradead.org>,
	Hugh Dickins <hugh@veritas.com>, Glauber Costa <gcosta@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Venki Pallipadi <venkatesh.pallipadi@intel.com>
References: <E1JuCBA-0002NZ-4E@closure.thunk.org> <Pine.LNX.4.64.0805082148060.3994@blonde.site> <20080509025956.GC8871@mit.edu> <1210331774.13978.230.camel@twins> <Pine.LNX.4.64.0805091231430.18088@blonde.site> <1210333785.13978.247.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210333785.13978.247.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 01:49:45PM +0200, Peter Zijlstra wrote:
> > > But I'm failing to see how IRQs get enabled between
> > > sched_clock_idle_sleep_event() and sched_clock_idle_wakeup_event() in
> > > acpi_idle_enter_simple().
> > 
> > If this point in Ted's bisection was without your idle irq fixes
> > (that patch that added trace_hardirqs_on to __sti_mwait, amongst
> > other things), would that account for it?
> 
> Ah, that might, I'll do a checkout of his specific revision to verify.
> 

I wouldn't worry about it too much, it's not there in 2.6.26-rc1 as
far as I can tell.  And it may or may not have anything to do with the
fact that my system locked up about 60 seconds afterwards, before I
had a chance to login via X and do a suspend/resume cycle (since
that's the most reliable way to reproduce my regression).  I'm
travelling this week, but when I have time, I'll try disabling X,
doing a suspend/resume cycle, and then doing a kerenl build -j3 and
see if I can provoke your symptoms.

					- Ted
