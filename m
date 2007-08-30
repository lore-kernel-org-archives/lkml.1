Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbXH3KJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbXH3KJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 06:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbXH3KJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 06:09:18 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47248 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbXH3KJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 06:09:17 -0400
Date: Thu, 30 Aug 2007 14:09:39 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH 2.6.21] Return available first timeslice to the creator, not parent
Message-ID: <20070830100939.GA372@tv-sign.ru>
References: <m3fy21qx4p.fsf@dhcp-lab-143.englab.brq.redhat.com> <1188465056.6112.30.camel@twins> <20070830094931.GB316@tv-sign.ru> <1188467816.6112.36.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188467816.6112.36.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30, Peter Zijlstra wrote:
>
> On Thu, 2007-08-30 at 13:49 +0400, Oleg Nesterov wrote:
> > 
> > sched_exit() was removed in 2.6.23-rc.
> > 
> > If you are going to re-introduce this logic, please don't do sched_exit()
> > from release_task(). It was done this way just because we can't access
> > ->parent after release_task(). But release_task() is called either too
> > early, or too late for timeslice accounting, depending on ->exit_signal == -1.
> > 
> > I'd suggest to do this in do_exit(), before the last schedule(). Without
> > write_unlock_irq() the code above needs a couple of rcu_read_lock()'s.
> > 
> > I am not sure Ingo will like this change though...
> 
> This is not intended as re-introduction of the feature, this stems from
> fixing this issue in older (read distro) kernels.

Ah, good, sorry for noise then.

In that case I don't think it makes sense to move sched_exit() to do_exit(),
of course. This doesn't look suitable for the -stable tree.

Oleg.

