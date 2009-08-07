Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbZHGVaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbZHGVaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 17:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbZHGVaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 17:30:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38275 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753299AbZHGVap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 17:30:45 -0400
Date: Fri, 7 Aug 2009 17:30:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Clark Williams <williams@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "greg@kroah.com" <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RT] Lockdep warning on boot with 2.6.31-rc5-rt1.1
In-Reply-To: <1249663785.32113.754.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0908071725510.8084-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Aug 2009, Peter Zijlstra wrote:

> On Fri, 2009-08-07 at 12:45 -0400, Alan Stern wrote:
> > On Fri, 7 Aug 2009, Peter Zijlstra wrote:
> 
> > > The other proposal was creating a fixed list of classes and register
> > > each device at a class corresponding to its depth in the tree. I can't
> > > remember what was wrong with that, but I seem to have been persuaded
> > > that that was hard too.
> > 
> > It probably would work for the most part.  However a possible scenario
> > involves first locking a parent and then locking all its children.  (I
> > don't know if this ever happens anywhere, but it might.)  This can't
> > cause a deadlock but it would run into trouble with depth-based
> > classes.
> 
> If you know which parent is locked, we can solve that with
> mutex_lock_nest_lock() [ doesn't currently exist, but is analogous to
> spin_lock_nest_lock() ] and together with
> http://lkml.org/lkml/2009/7/23/222 that would allow you to lock up to
> 2048 children.

Not only do I know not which parent is locked, I don't even know if 
this ever happens anywhere at all!  My point was purely theoretical.

> Would something like that work?

Perhaps -- I don't understand what spin_lock_nest_lock() is supposed to
do.

Alan Stern

