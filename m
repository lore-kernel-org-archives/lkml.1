Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbZDSKu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbZDSKu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 06:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZDSKuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 06:50:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46034 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZDSKuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 06:50:11 -0400
Subject: Re: [PATCH] Allow preemption during lazy mmu updates
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <49EAF9D6.1010600@redhat.com>
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>
	 <20090408145440.GN12931@elte.hu> <1239203512.4557.2575.camel@laptop>
	 <49EAF9D6.1010600@redhat.com>
Content-Type: text/plain
Date: Sun, 19 Apr 2009 12:47:25 +0200
Message-Id: <1240138045.8618.1083.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-19 at 13:15 +0300, Avi Kivity wrote:
> Peter Zijlstra wrote:
> > On Wed, 2009-04-08 at 16:54 +0200, Ingo Molnar wrote:
> >   
> >>>  kernel/sched.c                     |    2 -
> >>>       
> >> Needs the ack of ... oh, never mind - this one is fine i guess ;-)
> >>     
> >
> > Ah, about that. This new preemption hook has slightly different
> > requirements than the current preempt-notifiers have (hence the new
> > hook), I was wondering if KVM (afaik currently the only preempt-notifier
> > consumer) could live with these requirements.
> >
> > That is, could these be merged?
> >   
> 
> What are the slight differences in requirements?
> 
> KVM wants to run in non-preemptible, interrupts-enabled context.

The fire_sched_out bit is a little earlier, but I don't think that is a
particularly worrysome, but the most important difference was that
fire_sched_in in far too late. arch_end_context_switch() is done right
in the middle of switch_to() because it needs the TS bit or somesuch.

I'll let Jeremy explain details, as I've long since forgotten them :-)

