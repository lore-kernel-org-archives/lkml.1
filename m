Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbXCEQQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbXCEQQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbXCEQQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:16:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41576 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752784AbXCEQQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:16:53 -0500
Date: Mon, 5 Mar 2007 11:16:48 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Christoph Hellwig <hch@infradead.org>
cc: Roland McGrath <roland@redhat.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070305133639.GA6490@infradead.org>
Message-ID: <Pine.LNX.4.44L0.0703051113350.3401-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007, Christoph Hellwig wrote:

> On Sun, Mar 04, 2007 at 11:01:36PM -0800, Roland McGrath wrote:
> > > 	The parts relating to kernel breakpoints could be made conditional
> > > 	on a Kconfig option.  The amount of code space saved would be
> > > 	relatively small; I'm not sure that it would be worthwhile.
> > 
> > In a utrace merge, the user parts can be made conditional on CONFIG_UTRACE.
> > Then with both turned off, the code goes away completely.  It's unlikely it
> > will ever be turned off, but it is a clean way to go about things in case
> > someone wants the smallest possible config for a limited-use installation.
> 
> Making this unconditional is pointless and just makes things harder to
> read, so please don't do it.  (The same is true for utrace, but Roland
> has unfortunately still not replied to my mail mentioning it :P)

Sorry, I don't understand what you're saying.  I would think that making
it _conditional_ would make things harder to read, because of all the
extra "#ifdef" and "#endif" lines plus the need to keep two different
versions of the code in mind.

Did you mean to say "conditional" instead of "unconditional"?

Incidentally, I do believe that for certain applications (embedded
devices, for instance) it makes sense to avoid including all this code.  
The cleanest way to do that would be to make both PTRACE and UTRACE
configurable.


> > > +	void		(*installed)(struct hwbkpt *);
> > > +	void		(*uninstalled)(struct hwbkpt *);
> > 
> > Save space in the struct by having just one function for both installed
> > and uninstalled, taking an argument.  Probably a caller should be able to
> > pass a null function here to say that the registration call should fail if
> > it can't be installed due to higher-priority or no-callback registrations
> > existing, and that its registration cannot be ejected by another (i.e., an
> > ill-behaved user).
> 
> Please not.  That might save a few bytes, but it makes the interface a
> lot harder to understand for users.  We really discourage over-loaded
> interfaces in Linux.

I agree with Christoph.  Plenty of other interfaces in the kernel do the 
same thing.


> > > +struct thread_hwbkpt {		/* HW breakpoint info for a thread */
> 
> Can this and all the file names please get an actually readable name?
> E.g. hw_breakpoint.  We're not IBM managers that needs to save every
> cent on superflous sillables :)

I'll be happy to rename the structures and the files if Roland doesn't 
mind.

Alan Stern

