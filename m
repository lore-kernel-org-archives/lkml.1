Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbYJVU7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbYJVU7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYJVU7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:59:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707AbYJVU7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:59:15 -0400
Date: Wed, 22 Oct 2008 13:58:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add c2 port support.
Message-Id: <20081022135810.37c564f8.akpm@linux-foundation.org>
In-Reply-To: <20081022204800.GT4390@tekkaman>
References: <1224683240-15439-1-git-send-email-giometti@linux.it>
	<1224683240-15439-2-git-send-email-giometti@linux.it>
	<20081022174004.GB10587@kroah.com>
	<20081022111145.e5f3c632.akpm@linux-foundation.org>
	<20081022195245.GS4390@tekkaman>
	<20081022130150.00836eba.akpm@linux-foundation.org>
	<20081022204800.GT4390@tekkaman>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 22:48:01 +0200
Rodolfo Giometti <giometti@enneenne.com> wrote:

> > > > What I haven't yet got my head around is this:
> > > > 
> > > >   Currently this code supports only flash programming through sysfs
> > > >   interface but extensions shoud be easy to add.
> > > > 
> > > > is that really what we want to use sysfs for?  As the prime interface
> > > > to a device driver (or is it a bus driver?) Didn't we used to use
> > > > device nodes for that sort of thing?
> > > 
> > > I decided to use this interface since the C2 ports are simple and very
> > > easy to manage with such files abstraction.
> > 
> > well..  what _is_ the implemented interface?  What alternatives were
> > considered and why were they judged inappropriate?  What interfaces do
> > any similar in-tree drivers use?
> 
> Well... main reasons in using sysfs support are:
> 
> * no more char devices and new ioctls to define,
> 

Why is that good?  We have hundreds and hundreds of drivers which use a
device node interface and they work OK.

sysfs was never intended for use as the sole interface between device
drivers and userspace.  Using it that way is somewhat unconventional. 
At the very least I do think it needs more justification and
explanation than we're being provded here.

Device nodes and ioctls and such do have a number of problems, and
perhaps we should sit down and invent a new way of wiring drivers up to
userspace.  But whether that would end up being identical to the
present sysfs code is not obvious.

> * the microcontrollers on-board flash can be easily programmed by
> using only the "echo" and "cat" commands, so no more tools are needed
> and even simply busybox can be used.

A system which is using busybox might want to set CONFIG_SYSFS=n for
memory savings.  Now what?

