Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYH2IPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYH2IPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYH2IPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:15:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755453AbYH2IPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:15:31 -0400
Date: Fri, 29 Aug 2008 01:14:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       jurriaan <thunder7@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc4: lots of 'in_atomic():1, irqs_disabled():0' with 
 software-raid1
Message-Id: <20080829011423.6b027350.akpm@linux-foundation.org>
In-Reply-To: <18615.42728.498883.440973@notabene.brown>
References: <20080827170538.GA24393@amd64.of.nowhere>
	<200808272347.43577.rjw@sisk.pl>
	<20080828073324.GR20055@kernel.dk>
	<20080828004532.45d8b8c9.akpm@linux-foundation.org>
	<20080828074830.GV20055@kernel.dk>
	<18614.24929.952454.829021@notabene.brown>
	<20080828020018.a8ea85f0.akpm@linux-foundation.org>
	<18615.42728.498883.440973@notabene.brown>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 17:36:08 +1000 Neil Brown <neilb@suse.de> wrote:

> On Thursday August 28, akpm@linux-foundation.org wrote:
> > 
> > I'm curious about how this happened.
> > 
> > afaict from reading the code, this:
> > 
> > 	rcu_read_lock();
> > 	might_sleep();
> > 	rcu_read_unlock();
> > 
> > will warn if CONFIG_PREEMPT_RCU=n but won't warn if
> > CONFIG_PREEMPT_RCU=y.  If correct, that's a nasty trap.
> > 
> > Is that what you did?
> 
> Uhm..
> $ grep PREEMPT /home/src/md-x86-64/.config
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> $ grep DEBUG_SPIN /home/src/md-x86-64/.config
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
> $ grep RCU /home/src/md-x86-64/.config
> CONFIG_CLASSIC_RCU=y
> # CONFIG_RCU_TORTURE_TEST is not set
> 
> This definitely doesn't report an error if I put "might_sleep" inside 
> rcu_read_lock.  I tried to figure out why but got lost.

CONFIG_DEBUG_SPINLOCK_SLEEP doesn't do much useful without
CONFIG_PREEMPT=y.  Perhaps we could improve the Kconfig situation
there.

The most fine Documentation/SubmitChecklist instructeth:

12: Has been tested with CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT,
    CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES,
    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_SPINLOCK_SLEEP all simultaneously
    enabled.

(which might need updating for new goodies - it was written a while ago).

