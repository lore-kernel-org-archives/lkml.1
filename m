Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbXJ0NXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbXJ0NXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 09:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbXJ0NW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 09:22:57 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:36695 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbXJ0NW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 09:22:56 -0400
Date: Sat, 27 Oct 2007 09:22:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jaswinder Singh <jaswinderlinux@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.23-rt3] NMI watchdog trace of deadlock
In-Reply-To: <3f9a31f40710270312o5a4eb79exa67ed63b4f084f9e@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0710270915460.6459@gandalf.stny.rr.com>
References: <1193245634.20679.8.camel@localhost.localdomain> 
 <1193462494.25330.7.camel@Homer.simpson.net>  <200710271915.42363.nickpiggin@yahoo.com.au>
  <20071027094407.GA12047@elte.hu> <3f9a31f40710270312o5a4eb79exa67ed63b4f084f9e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--

On Sat, 27 Oct 2007, Jaswinder Singh wrote:

> Hello Ingo,
>
> On 10/27/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > it's not atomic interrupt context but irq thread context - and -rt
> > remaps kmap_atomic() to kmap() internally.
> >
> > the problem seems to be what Mike's patch works around: fiddling with
> > irq flags in the ntfs code. That fiddling seems quite unnecessary at
> > first sight.
> >
>
> Is this a nice idea to go inside device drivers and filesystem and
> make changes in kernel source code to enable RT.

Actually the question is, is it a nice idea for drivers to disable
interrupts for no obvious reason. I'm sure you have a reason, but it's not
obvious to me why. What does it protect? Is it SMP safe?

When tuning a RT system for the customer, the first thing we recommend is
to check to make sure all the drivers in use do not disable interrupts.

>
> RT related change should be in header files, so that we don't need to
> make changes for drivers or filesystem source files.
>
> And when user will disable RT then these patches will again make problems.
>
> We need to find some better alternative.

We do have the local_irq_save_nort that Mike has posted.  This is a simple
wrapper around local_irq_save that enables it when RT is not configured,
and is a nop when RT is configured.

Thanks,

-- Steve

