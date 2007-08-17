Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbXHQUAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbXHQUAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbXHQUA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:00:27 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33489 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbXHQUA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:00:26 -0400
Date: Fri, 17 Aug 2007 13:00:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bunk@kernel.org, josh@kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] Make rcutorture RNG use temporal entropy
Message-ID: <20070817200022.GH8464@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070816024904.GA5312@linux.vnet.ibm.com> <20070817115356.cb201e42.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070817115356.cb201e42.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 11:53:56AM -0700, Andrew Morton wrote:
> On Wed, 15 Aug 2007 19:49:04 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Repost of http://lkml.org/lkml/2007/8/10/472 made available by request.
> > 
> > The locking used by get_random_bytes() can conflict with the
> > preempt_disable() and synchronize_sched() form of RCU.  This patch changes
> > rcutorture's RNG to gather entropy from the new cpu_clock() interface
> > (relying on interrupts, preemption, daemons, and rcutorture's reader
> > thread's rock-bottom scheduling priority to provide useful entropy),
> > and also adds and EXPORT_SYMBOL_GPL() to make that interface available
> > to GPLed kernel modules such as rcutorture.
> > 
> > Passes several hours of rcutorture.
> 
> Please explain what "conflict with" means so that I can work out if
> this is a needed-in-2.6.23 change, thanks.

Not needed in 2.6.23.  This change falls into the "preparation for -rt"
category.  Also in the "don't unnecessarily eat entropy, leave some for
the people needing crypographically secure randomness" category.

						Thanx, Paul
