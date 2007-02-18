Return-Path: <linux-kernel-owner+w=401wt.eu-S2993101AbXBRDEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993101AbXBRDEE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 22:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993123AbXBRDEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 22:04:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993101AbXBRDED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 22:04:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
In-Reply-To: Alan Stern's message of  Friday, 9 February 2007 23:32:17 -0500 <Pine.LNX.4.44L0.0702092316550.3251-100000@netrider.rowland.org>
X-Zippy-Says: I didn't order any WOO-WOO...  Maybe a YUBBA..  But no WOO-WOO!
Message-Id: <20070218030359.D941F1800E4@magilla.sf.frob.com>
Date: Sat, 17 Feb 2007 19:03:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> How do you suggest this be handled?  Maybe we should just keep track of a
> maximum user priority level for each slot, allowing it to go up but not
> down until all user processes have given up the slot.  (I.e., in the
> example above the later kwatch requests would still fail because we would
> continue to remember the high user priority level so long as the first
> process maintained its allocation.)  That would be overly pessimistic, but
> it would at least be safe.

I think that is certainly fine to start with.  Like I said before, we can
start conservative and then worry about more complexity as the concrete
needs arise.  I don't think it will really be any trouble to change some of
these low-level interfaces later to accomodate more sophisticated callers
and implementations.  

When the issue does arise, scanning all the necessary tasks may not really
need to be so costly.  That is, if rather than scanning all tasks in the
system, it's a list of debugreg allocations.  The callers doing fancy
allocation can be responsible for passing in storage for a struct
containing the list structure.  That would naturally embed in struct
kwatch.  Having the debugreg allocation routines pass in such a structure
would also be useful for another kind of flexibility I'd like to have
eventually.  That is, "local" allocations that are local to a group of
tasks rather than just one.  For example, a debugger most often actually
wants to share watchpoints among all the threads sharing an address space.
If identical settings are in fact shared, the storage requirements for
using watchpoints in many-threaded processes scale that much better.

I think we have a while before we have to actually figure any of that out
in detail.  The simple starting point covers all our immediate concrete
concerns.


Thanks,
Roland

