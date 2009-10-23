Return-Path: <linux-kernel-owner+w=401wt.eu-S1751186AbZJWEbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbZJWEbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 00:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZJWEbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 00:31:32 -0400
Received: from kroah.org ([198.145.64.141]:45478 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZJWEbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 00:31:31 -0400
Date: Thu, 22 Oct 2009 21:27:54 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] tracefs
Message-ID: <20091023042754.GB26358@kroah.com>
References: <20091023004937.GA24035@kroah.com> <1256260230.20866.816.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256260230.20866.816.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 09:10:30PM -0400, Steven Rostedt wrote:
> On Thu, 2009-10-22 at 17:49 -0700, Greg KH wrote:
> > Hi all,
> > 
> > At LinuxCon this year, Steven and I talked about moving the debugfs
> > usage in the tracing core to a stand-alone filesystem to give the
> > ability to start to lock down the api so that people an count on what is
> > going on in the tracing userspace interface.
> > 
> > So, on the flight to Tokyo for the kernel summit, I wrote up tracefs.
> > Here's the first very rough cut at it below.  I've run it here on my
> > laptop, and all seems well, but I do have a few questions:
> >   - I've made the mount point be /sys/kernel/trace/  Is that ok?  Should
> >     it be /sys/kernel/tracing/?  Or something else?  You get to pick the
> >     mount point now, so I don't want to hear any more grumblings about
> >     the location in the future :)
> 
> /trace
> 
>  (rostedt hides)

Yeah, I knew you were going to do that :)

> >   - the block tracing code was not changed, as it uses
> >     /sys/kernel/debug/block/ at the moment, not the
> >     /sys/kernel/debug/tracing/ directory.  To change the block tracing
> >     code, it would require us to change the userspace tools as well,
> >     which I don't know if we want to do.  Thanks to Jens for
> >     straightening this all out for me, originally I thought it was a bug
> >     in the block tracing code.
> 
> I thought we were suppose to port the block tracing over to tracepoints
> anyway, and remove the "block" tracer?

That's between you and Jens, but at the kernel summit, he said it was
not going to go away any year soon.

> >   - is this type of conversion to a custom virtual filesystem acceptable
> >     to the other tracing developers?  Any objection to not using debugfs
> >     calls anymore?  The operation is identical, but it keeps the rest of
> >     the kernel from intruding on your space now.
> 
> What I would like is to still use debugfs for new features until we
> understand them better. That location, files can disappear or have their
> formats completely changed. When things move to tracefs, then the API is
> a bit more rigid. Files can still change, but they must change in a way
> to be backward compatible. We need a nice way to document how a file can
> change, and stick to it.

That sounds like a very good idea.  I'll respin the patch to only merge
one tracer over at a time.

You are going to have a bit of a difficult time if you mix debugfs and
tracefs as people will not know where to look for the files.  But hey,
that's your problem to deal with :)

> [ Snip the s/debugfs/tracefs/ changes ]
> 
> Note, as mentioned above. I envision having a way to start out in
> debugfs and then slowly move things over to tracefs when they become
> standardize. Think of debugfs as linux-next ;-)
> 
> Although most of the files are pretty much stable, I don't want to do a
> cross the board change at the moment.

That sounds reasonable.  Thanks for the review, I'll respin this when I
get back home next week.

thanks,

greg k-h
