Return-Path: <linux-kernel-owner+w=401wt.eu-S932889AbZLNXOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889AbZLNXOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbZLNXOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:14:12 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48644 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757876AbZLNXOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:14:06 -0500
Date: Mon, 14 Dec 2009 18:14:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Warn people about flush_scheduled_work()
In-Reply-To: <4B26BE67.5060107@kernel.org>
Message-ID: <Pine.LNX.4.44L0.0912141809390.2690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009, Tejun Heo wrote:

> Hello, Alan Stern.
> 
> On 12/15/2009 06:33 AM, Alan Stern wrote:
> > You've spent some time working on the workqueue implementation, right?  
> > I'd like to add comments or kerneldoc warning people about how 
> > dangerous it can be to use flush_scheduled_work() and related 
> > functions.  Something like this:
> > 
> > 	Think twice before calling this function!  It's very easy
> > 	to get into trouble if you don't take great care.  Either
> > 	of the following situations will lead to deadlock:
> > 
> > 		Your code is running in the context of a scheduled
> > 		work routine.
> >
> > 		Your code or its caller holds a lock needed by
> > 		one of the work items currently on the workqueue.
> >
> > 	Since you generally don't know who your caller is, what locks
> > 	it holds, or what locks are needed by the items on the 
> > 	workqueue, avoiding these situations is quite difficult.
> 
> I think both problems can be detected by lockdep, right?  So, they
> aren't that difficult to detect.

Maybe they can, now.  It used to be they couldn't.

However, lockdep doesn't help much -- it tells you the cause of the
deadlock but it doesn't prevent the deadlock from occurring.  The
programmer has to do this, by avoiding flush_scheduled_work().  I guess 
that could be added to the comment.

> > 	Consider using cancel_work_sync() or cancel_delayed_work_sync()
> > 	instead.  In most situations they will accomplish what you 
> > 	need.
> > 
> > Does this sound like a good idea?  Certainly flush_scheduled_work()  
> > is used in places where it shouldn't be.
> 
> Yeah, recommending more work-specific constructs definitely would be
> better.  It's bad that we can't recommend the use of flush_work() as
> it doesn't do cross-cpu flushing.  Maybe that needs explanation too.

I'll do my comments, and you can do yours.  :-)

Should these changes go through Andrew Morton?  Or can you take them?

Alan Stern

