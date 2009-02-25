Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbZBYEoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbZBYEoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbZBYEoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:44:00 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55170 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbZBYEoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:44:00 -0500
Date: Tue, 24 Feb 2009 20:43:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, vegard.nossum@gmail.com, mingo@elte.hu,
       stable@kernel.org, akpm@linux-foundation.org, penberg@cs.helsinki.fi
Subject: Re: [PATCH] v3 Teach RCU that idle task is not quiscent state at
	boot
Message-ID: <20090225044356.GD7241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090223161611.GA9563@linux.vnet.ibm.com> <20090223204332.GA19861@linux.vnet.ibm.com> <20090225002937.GA23733@linux.vnet.ibm.com> <20090225041259.GA14149@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225041259.GA14149@wotan.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 05:12:59AM +0100, Nick Piggin wrote:
> Looks OK to me. It's a bit "theoretically" displeasing that
> you still treat synchronize_rcu as a gp even after we spawn
> some kernel threads.
> 
> ... but it probably isn't worth trying to rearrange the boot
> code just to make this look better. I can't see any actual
> problems that could arise, as the threads should not have
> had a chance to run yet.

And if rcuclassic or rcutree on a UP system, even if threads have had
a chance to run, it is OK to treat synchronize_rcu() as a grace period,
since it has the opportunity to block.

> I wonder if you couldn't put in a WARN_ON(nr_context_switches() > 0)
> in rcu_idle_now_means_idle() just in case?

Makes a lot of sense -- updated and am firing off the tests!

							Thanx, Paul

> On Tue, Feb 24, 2009 at 04:29:37PM -0800, Paul E. McKenney wrote:
> > This patch fixes a bug located by Vegard Nossum with the aid of
> > kmemcheck, updated based on review comments from Nick Piggin,
> > Ingo Molnar, and Andrew Morton.
