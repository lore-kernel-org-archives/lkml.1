Return-Path: <linux-kernel-owner+w=401wt.eu-S933238AbXBXAIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbXBXAIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933267AbXBXAIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:08:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933238AbXBXAIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:08:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
In-Reply-To: Alan Stern's message of  Friday, 23 February 2007 11:55:01 -0500 <Pine.LNX.4.44L0.0702231137190.6241-100000@netrider.rowland.org>
X-Windows: a mistake carried out to perfection.
Message-Id: <20070224000851.C9884180076@magilla.sf.frob.com>
Date: Fri, 23 Feb 2007 16:08:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the best approach will be not to reset dr7 at all.  Then there 
> won't be any need to worry about restoring it.  Leaving a userspace 
> watchpoint enabled while running in the kernel ought not to matter; a 
> system call shouldn't touch any address in userspace more than once or 
> twice.

Hmm.  That sounds reasonable.  But I wonder why the old code clears %dr7.
It's been that way for a long time (since 2.4 at least).

> My idea was to put 4 hwbkpt structures in thread_struct, so they would
> always be available for use by ptrace.  However it turned out not to be
> feasible to replace the debugreg array with something more sophisticated,
> because of conflicting declarations and problems with the ordering of
> #includes.  So instead I have been forced to replace debugreg[] with a
> pointer to a structure which can be allocated as needed.

I think that's preferable anyway.  Most tasks most of the time will never
need that storage, so why not make thread_struct a little smaller?
(There is also the potential for sharing, which I mentioned earlier.)

> This raises the possibility that a PTRACE syscall might fail because the 
> allocation fails.  Hopefully that won't be an issue?

It's not a new issue, anyway, after utrace.  The utrace-based ptrace can
fail for PTRACE_ATTACH because of OOM too, which wasn't possible before.
I think it's survivable.


Thanks,
Roland
