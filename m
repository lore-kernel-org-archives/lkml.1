Return-Path: <linux-kernel-owner+w=401wt.eu-S933448AbYBHSpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbYBHSpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757961AbYBHSpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:45:06 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:61948 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317AbYBHSpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:45:04 -0500
Date: Fri, 8 Feb 2008 19:45:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>, Adam Belay <abelay@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Simplify cpu_idle_wait
Message-ID: <20080208184501.GA6847@basil.nowhere.org>
References: <1199759244.26343.35.camel@localhost.localdomain> <B5B0CFF685D7DF46A05CF1678CFB42ED20E00653@orsmsx423.amr.corp.intel.com> <20080208010550.GA8090@linux-os.sc.intel.com> <200802081128.48621.ak@suse.de> <20080208172430.GA8302@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208172430.GA8302@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 08 Feb 2008 18:38:41.0205 (UTC) FILETIME=[D3845650:01C86A81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 09:24:30AM -0800, Venki Pallipadi wrote:
> On Fri, Feb 08, 2008 at 11:28:48AM +0100, Andi Kleen wrote:
> > 
> > > -	set_cpus_allowed(current, tmp);
> > > +	smp_mb();
> > > +	/* kick all the CPUs so that they exit out of pm_idle */
> > > +	smp_call_function(do_nothing, NULL, 0, 0);
> > 
> > I think the last argument (wait) needs to be 1 to make sure it is 
> > synchronous (for 32/64) Otherwise the patch looks great.
> 
> Yes. Below is the updated patch

Acked-by: Andi Kleen <ak@suse.de>

-Andi

