Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYBAORe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYBAORe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 09:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbYBAOR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 09:17:27 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:48151 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbYBAOR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 09:17:26 -0500
Date: Fri, 1 Feb 2008 17:20:17 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@sw.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] hrtimer_nanosleep: use -EINTR, not -ERESTARTNOHAND
Message-ID: <20080201142017.GA25774@tv-sign.ru>
References: <20080201133755.GA25620@tv-sign.ru> <alpine.LFD.1.00.0802011438020.9204@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802011438020.9204@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, Thomas Gleixner wrote:
>
> On Fri, 1 Feb 2008, Oleg Nesterov wrote:
> 
> > hrtimer_nanosleep:
> > 
> > 	/* Absolute timers do not update the rmtp value and restart: */
> > 	return -ERESTARTNOHAND;
> > 
> > This is not right, -ERESTARTNOHAND means we will do restart if there is no
> > in fact pending signal, and worse, this restart will use the same unchanged
> > "__user *rmtp" parameter.
> 
> -ERESTARTNOHAND is safe here. We want to restart the timer.

Ah. I was greatly confused by the comment, it says "do not ... restart",
now I understand what this _actually_ means.

And yes, I was wrong. If restart is wanted, it is safe to use the original
*rqtp, the timer is HRTIMER_MODE_ABS.

Thanks Thomas!

Andrew, please ignore this patch.

Oleg.

