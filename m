Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbYJVVHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbYJVVHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYJVVHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:07:20 -0400
Received: from kroah.org ([198.145.64.141]:49509 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751290AbYJVVHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:07:18 -0400
Date: Wed, 22 Oct 2008 14:03:52 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add c2 port support.
Message-ID: <20081022210352.GA29754@kroah.com>
References: <1224683240-15439-1-git-send-email-giometti@linux.it> <1224683240-15439-2-git-send-email-giometti@linux.it> <20081022174004.GB10587@kroah.com> <20081022111145.e5f3c632.akpm@linux-foundation.org> <20081022195245.GS4390@tekkaman> <20081022130150.00836eba.akpm@linux-foundation.org> <20081022204800.GT4390@tekkaman> <20081022135810.37c564f8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022135810.37c564f8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 01:58:10PM -0700, Andrew Morton wrote:
> On Wed, 22 Oct 2008 22:48:01 +0200
> Rodolfo Giometti <giometti@enneenne.com> wrote:
> 
> > > > > What I haven't yet got my head around is this:
> > > > > 
> > > > >   Currently this code supports only flash programming through sysfs
> > > > >   interface but extensions shoud be easy to add.
> > > > > 
> > > > > is that really what we want to use sysfs for?  As the prime interface
> > > > > to a device driver (or is it a bus driver?) Didn't we used to use
> > > > > device nodes for that sort of thing?
> > > > 
> > > > I decided to use this interface since the C2 ports are simple and very
> > > > easy to manage with such files abstraction.
> > > 
> > > well..  what _is_ the implemented interface?  What alternatives were
> > > considered and why were they judged inappropriate?  What interfaces do
> > > any similar in-tree drivers use?
> > 
> > Well... main reasons in using sysfs support are:
> > 
> > * no more char devices and new ioctls to define,
> > 
> 
> Why is that good?  We have hundreds and hundreds of drivers which use a
> device node interface and they work OK.
> 
> sysfs was never intended for use as the sole interface between device
> drivers and userspace.  Using it that way is somewhat unconventional. 
> At the very least I do think it needs more justification and
> explanation than we're being provded here.

For firmware download to devices, using sysfs is the "normal" interface
these days, that is what the firmware class is for.

Which reminds me, Rodolfo, why didn't you just use that interface for
your firmware downloading instead of rolling your own here?

> Device nodes and ioctls and such do have a number of problems, and
> perhaps we should sit down and invent a new way of wiring drivers up to
> userspace.  But whether that would end up being identical to the
> present sysfs code is not obvious.
> 
> > * the microcontrollers on-board flash can be easily programmed by
> > using only the "echo" and "cat" commands, so no more tools are needed
> > and even simply busybox can be used.
> 
> A system which is using busybox might want to set CONFIG_SYSFS=n for
> memory savings.  Now what?

My daughter's phone (the #1 selling handset last year in the US) has
sysfs enabled, I think this argument can be put to rest as not a valid
one.

thanks,

greg k-h
