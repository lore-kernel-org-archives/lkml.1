Return-Path: <linux-kernel-owner+w=401wt.eu-S1161179AbXDLLZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161179AbXDLLZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 07:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161184AbXDLLZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 07:25:49 -0400
Received: from thunk.org ([69.25.196.29]:54587 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161179AbXDLLZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 07:25:48 -0400
Date: Thu, 12 Apr 2007 07:25:45 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pedro <linux_user@izecksohn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer
Message-ID: <20070412112545.GA28148@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pedro <linux_user@izecksohn.com>, linux-kernel@vger.kernel.org
References: <200704110223.31291.linux_user@izecksohn.com> <200704111927.00609.linux_user@izecksohn.com> <20070411233921.7a5c3cff@the-village.bc.nu> <200704120219.03171.linux_user@izecksohn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704120219.03171.linux_user@izecksohn.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 02:19:02AM -0300, Pedro wrote:
> > OOM isn't an application matter. The kernel has to choose between
> > allowing overcommit on the basis it might run out of memory and have to
> > kill stuff, or that it won't in which case an applicatio which correctly
> > handles malloc() and similar failures will not be killed (unless it is
> > out of space on a stack grow which is a C language flaw as you can't
> > catch that event in C)
> >
> > It's configured by /proc/sys/vm/overcommit_memory
> >
> > 0 - try and spot obviously dumb allocations
> > 1 - anything goes
> > 2 - strictly control resource commit
> 
>   I deduce that a fail-safe application must scanf overcommit_memory, warn 
> the user and waitpid.

If a fail-safe applicaion is running on a system which is that close
to the edge in terms of available physical memory and swap, it's not
likely going to be in deep trouble anyway.  Even if you disable the
OOM killer, now random malloc()'s will start returning NULL because
your system doesn't have enough memory.  Do you have intelligent error
handling and recovery mechanisms for every single malloc() failure?
Also, the machine will likely be thrashing so badly that any service
level performance guarantees that the application might have will
probably be totally trashed.

						- Ted

