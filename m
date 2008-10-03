Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYJCXqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYJCXqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 19:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYJCXp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 19:45:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbYJCXp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 19:45:58 -0400
Date: Fri, 3 Oct 2008 13:41:24 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove completion from struct klist_node
Message-ID: <20081003204124.GA3269@kroah.com>
References: <20081002214308.GP13822@parisc-linux.org> <20081002221745.GC10485@kroah.com> <20081003140618.GQ13822@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003140618.GQ13822@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 08:06:19AM -0600, Matthew Wilcox wrote:
> On Thu, Oct 02, 2008 at 03:17:45PM -0700, Greg KH wrote:
> > > +struct klist_waiter {
> > > +	struct klist_waiter *next;
> > > +	struct klist_node *node;
> > > +	struct task_struct *process;
> > > +	int woken;
> > > +};
> > 
> > Why not use the built-in list.h functions here?
> 
> I'm somewhat averse to using data structures when they do more than I
> need them to.

But part of the point is that if you use them, no one has to audit your
logic to make sure you got it all correct.

> list_heads are great for when you need to remove an entry
> from the middle of a list, but there are no advantages to using a
> doubly-linked list here -- we always walk it from the start to the end,
> and a singly linked list is fine for this purpose.  Maybe we need a set
> of 'slist' macros so we can use singly-linked-lists without thinking
> terribly hard, but I'd hate to see this patch get stuck behind
> infrastructure improvements.

Is size an issue here?  I don't think so and I'd prefer it to be changed
to use the standard list implementation and not roll your own.  You
never know who will cut-and-paste you code these days :)

Care to respin this?

thanks,

greg k-h
