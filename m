Return-Path: <linux-kernel-owner+w=401wt.eu-S1765349AbYDVNlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765349AbYDVNlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762734AbYDVNlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:41:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765005AbYDVNlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:41:10 -0400
Date: Tue, 22 Apr 2008 06:40:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: paulmck@linux.vnet.ibm.com, hch@lst.de, davem@davemloft.net,
       peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0.01/1] hlist_for_each_entry_xxx: kill the "pos"
 argument
Message-Id: <20080422064030.82b37fd9.akpm@linux-foundation.org>
In-Reply-To: <20080422090921.GA130@tv-sign.ru>
References: <20080421151443.GA29670@tv-sign.ru>
	<20080422013302.GJ9153@linux.vnet.ibm.com>
	<20080422090921.GA130@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 Apr 2008 13:09:21 +0400 Oleg Nesterov <oleg@tv-sign.ru> wrote:
> On 04/21, Paul E. McKenney wrote:
> >
> > On Mon, Apr 21, 2008 at 07:14:43PM +0400, Oleg Nesterov wrote:
> > > (The actual patch is huge, 116K, I'll send it offline. This email contains
> > >  the chunk for list.h only).
> > > 
> > > COMPILE TESTED ONLY (make allyesconfig).
> > > 
> > > All hlist_for_each_entry_xxx() macros require the "pos" argument, which is not
> > > actually needed and can be removed. See the changes in include/linux/list.h
> > > (note that hlist_for_each_entry_safe() now does prefetch() too).
> > 
> > Might it be better to do this in two
> > phases to allow these patches to be applied incrementally?
> > 
> > 1.	Change all to "obsolete" __hlist_for_each_entry_xxx().
> > 
> > 2.	Incrementally change to hlist_for_each_entry_xxx(), removing
> > 	the extra variable where possible.
> 
> Yes sure. Actually this was my initial plan.
> 
> Andrew, which way do you prefer?

Neither ;)

The smoothest transition would come by adding new macros with new names,
then migrating all callers over then removing the old macros.

Preferably after leaving the old, unused macros in place for a kernel
cycle, but there's not much value in that unless we can make them emil
warnings when used, which isn't completely trivial.

Plus there is no sensible new name which we can use.  Maybe you can think
of one, in which case that'd be a nice way to go.

> and should I wait for -rc1?

I wouldn't consider a change like this before -rc1.
