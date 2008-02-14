Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbYBNCcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbYBNCcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 21:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYBNCcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 21:32:09 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:8685 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752178AbYBNCcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 21:32:08 -0500
Date: Thu, 14 Feb 2008 11:29:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rth <rth@twiddle.net>,
       "bryan.wu" <bryan.wu@analog.com>, David Howells <dhowells@redhat.com>,
       William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       gerg@uclinux.org, Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xtime_lock vs update_process_times
Message-ID: <20080214022954.GA12388@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	rth <rth@twiddle.net>, "bryan.wu" <bryan.wu@analog.com>,
	David Howells <dhowells@redhat.com>,
	William Lee Irwin III <wli@holomorphy.com>,
	Ingo Molnar <mingo@elte.hu>, gerg@uclinux.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1202934796.20209.11.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202934796.20209.11.camel@lappy>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 09:33:16PM +0100, Peter Zijlstra wrote:
> Subject: xtime_lock vs update_process_times
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> ( repost from: http://lkml.org/lkml/2008/1/28/101 )
> 
> Commit: d3d74453c34f8fd87674a8cf5b8a327c68f22e99
> Subject: hrtimer: fixup the HRTIMER_CB_IRQSAFE_NO_SOFTIRQ fallback
> 
> Broke several archs, since only Russel bothered to merge the fix,
> and Greg to ACK his arch, I'm sending this for merger.
> 
> I have confirmation that the Alpha bit results in a booting kernel.
> That leaves: blackfin, frv, sh and sparc untested.
> 
> The deadlock in question was found by Russell:
> 
>   IRQ handle 
>     -> timer_tick() - xtime seqlock held for write
>       -> update_process_times() 
>         -> run_local_timers()
>           -> hrtimer_run_queues()
>             -> hrtimer_get_softirq_time() - tries to get a read lock
> 
> Now, Thomas assures me the fix is trivial, only do_timer() needs to be
> done under the xtime_lock, and update_process_times() can savely be removed
> from under it.
> 
The SH bits also work fine. I've already merged that part in to my tree.
Thanks, Peter.
