Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbYBYPxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbYBYPxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 10:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbYBYPxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 10:53:07 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:60236 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbYBYPxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:53:06 -0500
Date: Mon, 25 Feb 2008 16:53:01 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: revert load_balance_monitor()
Message-ID: <20080225155301.GA6787@osiris.boeblingen.de.ibm.com>
References: <1203942167.6242.142.camel@lappy> <1203949799.4688.9.camel@homer.simson.net> <20080225143518.GA29275@linux.vnet.ibm.com> <1203953282.6242.180.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203953282.6242.180.camel@lappy>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 04:28:02PM +0100, Peter Zijlstra wrote:
> On Mon, 2008-02-25 at 20:05 +0530, Dhaval Giani wrote:
> Subject: sched: fully revert load_balance_monitor()
> 
> The following commit causes a number of serious regressions:
> 
>   commit 6b2d7700266b9402e12824e11e0099ae6a4a6a79
>   Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>   Date:   Fri Jan 25 21:08:00 2008 +0100
>   sched: group scheduler, fix fairness of cpu bandwidth allocation for task groups
> 
> Namely:
>  - very frequent wakeups on SMP, reported by PowerTop users.
>  - cacheline trashing on (large) SMP
>  - some latencies larger than 500ms
> 
> While there is a mergeable patch to fix the latter, the former issues
> are IMHO not fixable in a manner suitable for .25 (we're at -rc3 now).
> Hence I propose to revert this patch and try again for .26.

I was just about to complain about the frequent wakeups caused by the
original patch.
It's responsible of 70% of wakeups on an otherwise idle system on s390.

Thanks :)
