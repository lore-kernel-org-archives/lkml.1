Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYBYOff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYBYOff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 09:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYBYOf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 09:35:28 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:44864 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYBYOf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:35:27 -0500
Date: Mon, 25 Feb 2008 20:05:18 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: revert load_balance_monitor()
Message-ID: <20080225143518.GA29275@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1203942167.6242.142.camel@lappy> <1203949799.4688.9.camel@homer.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203949799.4688.9.camel@homer.simson.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 03:29:59PM +0100, Mike Galbraith wrote:
> 
> On Mon, 2008-02-25 at 13:22 +0100, Peter Zijlstra wrote:
> > Subject: sched: revert load_balance_monitor()
> > 
> > The following commit causes a number of serious regressions:
> > 
> >   commit 6b2d7700266b9402e12824e11e0099ae6a4a6a79
> >   Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> >   Date:   Fri Jan 25 21:08:00 2008 +0100
> >   sched: group scheduler, fix fairness of cpu bandwidth allocation for task groups
> > 
> > Namely:
> >  - very frequent wakeups on SMP, reported by PowerTop users.
> >  - cacheline trashing on (large) SMP
> >  - some latencies larger than 500ms
> > 
> > While there is a mergeable patch to fix the latter, the former issues
> > are IMHO not fixable in a manner suitable for .25 (we're at -rc3 now).
> > Hence I propose to revert this patch and try again for .26.
> > 
> > ( minimal revert - leaves most of the code present, just removes the activation
> >   and sysctl interface ).
> 
> top - 14:05:56 up 3 min, 16 users,  load average: 4.31, 2.14, 0.85
> Tasks: 218 total,   5 running, 213 sleeping,   0 stopped,   0 zombie
> Cpu(s): 35.5%us, 64.5%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
>  5294 mikeg     20   0  1464  364  304 R   99  0.0   1:00.08 0 chew-max
>  5278 root      20   0  1464  364  304 R   32  0.0   0:27.86 1 chew-max
>  5279 root      20   0  1464  360  304 R   32  0.0   0:35.53 1 chew-max
>  5290 root      20   0  1464  364  304 R   31  0.0   0:29.00 1 chew-max
> 
> The minimal revert seems to leave group fairness in a worse state than
> what the original patch meant to fix.  Maybe a full revert would be
> better?
> 

This is funny. The thread should not start. Did the full revert that I
sent you sometime back work better?

Thanks,
-- 
regards,
Dhaval
