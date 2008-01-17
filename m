Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYAQT5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYAQT5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbYAQT5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:57:38 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58033 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752061AbYAQT5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:57:37 -0500
Date: Thu, 17 Jan 2008 14:57:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jarek Poplawski <jarkao2@gmail.com>
cc: Dave Young <hidave.darkstar@gmail.com>, Greg KH <gregkh@suse.de>,
       <stefanr@s5r6.in-berlin.de>, David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
 class
In-Reply-To: <20080117194728.GA2598@ami.dom.local>
Message-ID: <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008, Jarek Poplawski wrote:

> On Thu, Jan 17, 2008 at 10:16:30AM -0500, Alan Stern wrote:
> > On Thu, 17 Jan 2008, Dave Young wrote:
> > 
> > > > Your meaning isn't clear.  Do you mean that your patch doesn't generate
> > > > any lockdep warnings at all?  Or do you mean that it generates a single
> > > > lockdep warning at boot time and then no more warnings afterward?
> > > 
> > > I means the latter one.
> > 
> > That's very bad.
> > 
> > For each type of violation, lockdep only gives one error message.  So
> > the fact that you get one message at boot time and then no more doesn't
> > mean the code is almost right -- it probably means the code has lots of
> > errors and you're seeing only the first one.
> 
> I hope it's better than this: lockdep really stops checking after first
> warning, but I've understood from David's description that after fixing
> this one place lockdep seems to be pleased.

That isn't what Dave said above; he said that lockdep produces a single
warning at bootup.  If he did mention anything about one place being
fixed up or lockdep being pleased, it was a while back and I've lost 
track of it.

If I recall correctly the nature of the warning was that a method
routine for one class (called with the class's mutex held) was creating
a second class and locking that class's mutex.  In principle this is
perfectly legal and should be allowed for arbitrary depths of nesting,
even though it is the sort of thing lockdep is currently unable to
handle.

> On the other hand, according to Greg the code is OK, so if there are any
> such warnings they simply have to be false! (...Unless you trust lockdep
> more?!)

It's not a matter of trust or of false warnings.  People shouldn't 
tolerate any lockdep warnings at all; otherwise they will start to 
ignore the valid ones.

Alan Stern

P.S.: Just because Greg says the code is okay doesn't mean it will 
please lockdep -- it doesn't even mean the code really is okay!  I've 
known Greg to make an occasional mistake.

