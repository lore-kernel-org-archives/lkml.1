Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbYB1Pd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbYB1Pd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757770AbYB1PdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:33:20 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:46351 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757809AbYB1PdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:33:19 -0500
Date: Thu, 28 Feb 2008 18:36:55 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Consolidate send_sigqueue and send_group_sigqueue
Message-ID: <20080228153655.GC11484@tv-sign.ru>
References: <47BEC663.7050904@openvz.org> <20080222144155.GA4349@tv-sign.ru> <alpine.LFD.1.00.0802280546360.7583@apollo.tec.linutronix.de> <20080228061723.GB108@tv-sign.ru> <20080228113633.7431C2700FD@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228113633.7431C2700FD@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Roland McGrath wrote:
>
> That code dates from the original introduction of those two functions.
> I can't see any reason why those ever had swapped order of the two checks.
> I think it must have just been sloppy coding in the original work.
> 
> I'm not clear on how the already-queued case could ever happen.  Do we
> really need that check at all?  It shouldn't be possible for the timer to
> be firing when it's already queued, because it won't have been reloaded.
> It only reloads via do_schedule_next_timer after it's dequeued, or because
> a 1 return value said it never was queued.

This is true for the posix timers, but posix cpu timers case is different.
Note the run_posix_cpu_timers()->cpu_timer_fire().

Oleg.

