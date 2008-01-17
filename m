Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbYAQU3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbYAQU3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYAQU3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:29:07 -0500
Received: from hu-out-0506.google.com ([72.14.214.238]:18333 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYAQU3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:29:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FEwq4fZ2nIjLokFyFfrJ+YnCs8+unL/F15N3cwU+L+A/LiKEpxoQX6nfdUP4iN48CB2NXQGLm7RR4NCBgfzBd6FKPgsAVtMaY/2cryotZtdNkQ701+uEDbX9jQjEyvCLxrnvSZhuyNdALr/jSwuaGxrnttR2TaC83htoz2Gzbm0=
Date: Thu, 17 Jan 2008 21:31:55 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dave Young <hidave.darkstar@gmail.com>, Greg KH <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080117203155.GA2791@ami.dom.local>
References: <20080117194728.GA2598@ami.dom.local> <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 02:57:36PM -0500, Alan Stern wrote:
> On Thu, 17 Jan 2008, Jarek Poplawski wrote:
> 
> > On Thu, Jan 17, 2008 at 10:16:30AM -0500, Alan Stern wrote:
> > > On Thu, 17 Jan 2008, Dave Young wrote:
> > > 
> > > > > Your meaning isn't clear.  Do you mean that your patch doesn't generate
> > > > > any lockdep warnings at all?  Or do you mean that it generates a single
> > > > > lockdep warning at boot time and then no more warnings afterward?
> > > > 
> > > > I means the latter one.
> > > 
> > > That's very bad.
> > > 
> > > For each type of violation, lockdep only gives one error message.  So
> > > the fact that you get one message at boot time and then no more doesn't
> > > mean the code is almost right -- it probably means the code has lots of
> > > errors and you're seeing only the first one.
> > 
> > I hope it's better than this: lockdep really stops checking after first
> > warning, but I've understood from David's description that after fixing
> > this one place lockdep seems to be pleased.
> 
> That isn't what Dave said above; he said that lockdep produces a single
> warning at bootup.  If he did mention anything about one place being
> fixed up or lockdep being pleased, it was a while back and I've lost 
> track of it.
> 
> If I recall correctly the nature of the warning was that a method
> routine for one class (called with the class's mutex held) was creating
> a second class and locking that class's mutex.  In principle this is
> perfectly legal and should be allowed for arbitrary depths of nesting,
> even though it is the sort of thing lockdep is currently unable to
> handle.

You are definitely right! After first reading Dave's description I got
it the same way, but after re-reading I probably was misled with this
"thus"! Only now I've had a look at this warning and there is really
mutex_lock_nested(). Sorry Alan!

David, I don't think a patch which causes such a warning can be merged
even to -mm, because, as I wrote earlier it would automatically turn
off lockdep for everybody. So, every such warning needs to be fixed or,
if it's impossible because of some lockdep deficiency, it should be
considered if it's better to wait for lockdep changes, or do the change
with lockdep turned off locally for each lock (IMHO, it's better,
because with sems there is no such control as well, and some other
aspects could be tested in the meantime).

> > On the other hand, according to Greg the code is OK, so if there are any
> > such warnings they simply have to be false! (...Unless you trust lockdep
> > more?!)
> 
> It's not a matter of trust or of false warnings.  People shouldn't 
> tolerate any lockdep warnings at all; otherwise they will start to 
> ignore the valid ones.
> 
> Alan Stern
> 
> P.S.: Just because Greg says the code is okay doesn't mean it will 
> please lockdep -- it doesn't even mean the code really is okay!  I've 
> known Greg to make an occasional mistake.

Alan, you are 200% right! I apologize for my bad jokes too!

Regards,
Jarek P.
