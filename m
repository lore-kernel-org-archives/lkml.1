Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbYJCOGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbYJCOGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYJCOGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:06:36 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52543 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYJCOGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:06:35 -0400
Date: Fri, 3 Oct 2008 08:06:19 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove completion from struct klist_node
Message-ID: <20081003140618.GQ13822@parisc-linux.org>
References: <20081002214308.GP13822@parisc-linux.org> <20081002221745.GC10485@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002221745.GC10485@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 03:17:45PM -0700, Greg KH wrote:
> > +struct klist_waiter {
> > +	struct klist_waiter *next;
> > +	struct klist_node *node;
> > +	struct task_struct *process;
> > +	int woken;
> > +};
> 
> Why not use the built-in list.h functions here?

I'm somewhat averse to using data structures when they do more than I
need them to.  list_heads are great for when you need to remove an entry
from the middle of a list, but there are no advantages to using a
doubly-linked list here -- we always walk it from the start to the end,
and a singly linked list is fine for this purpose.  Maybe we need a set
of 'slist' macros so we can use singly-linked-lists without thinking
terribly hard, but I'd hate to see this patch get stuck behind
infrastructure improvements.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
