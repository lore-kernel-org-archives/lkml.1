Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbZKTOUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbZKTOUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZKTOUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:20:23 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:58958 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbZKTOUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 09:20:20 -0500
Date: Fri, 20 Nov 2009 15:19:59 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, feng.tang@intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] hrtimer: Fix /proc/timer_list regression
Message-ID: <20091120141959.GA6781@osiris.boeblingen.de.ibm.com>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
 <tip-8629ea2eaba8ca0de2e38ce1b4a825e16255976e@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-8629ea2eaba8ca0de2e38ce1b4a825e16255976e@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 10:30:39AM +0000, tip-bot for Feng Tang wrote:
> Commit-ID:  8629ea2eaba8ca0de2e38ce1b4a825e16255976e
> Gitweb:     http://git.kernel.org/tip/8629ea2eaba8ca0de2e38ce1b4a825e16255976e
> Author:     Feng Tang <feng.tang@intel.com>
> AuthorDate: Thu, 3 Sep 2009 16:32:53 +0800
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Fri, 20 Nov 2009 11:25:48 +0100
> 
> hrtimer: Fix /proc/timer_list regression
> 
> commit 507e1231 (timer stats: Optimize by adding quick check to avoid
> function calls) introduced a regression in /proc/timer_list.
> 
> /proc/timer_list shows now
>  #0: <c27d46b0>, tick_sched_timer, S:01, <(null)>, /-1
> instead of
>  #0: <c27d46b0>, tick_sched_timer, S:01, hrtimer_start, swapper/0

For a 'real' fix I see three possible ways if timer_stats are disabled:

Print something like:

#0: <c27d46b0>, tick_sched_timer, S:01, unknown, unknown/-1

That way the format would be still the same and it should be quite obvious
that timer_stats are disabled and should be enabled.

Alternatively leave start_site, taskname and pid away if the correspending
timer has a NULL start_site. That would be the same like for the !TIMER_STATS
case:

#0: <c27d46b0>, tick_sched_timer, S:01

or (worst choice) revert the whole optimization and live with extra cpu cost.
