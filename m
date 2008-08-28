Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbYH1KlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbYH1KlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 06:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYH1KlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 06:41:08 -0400
Received: from www.tglx.de ([62.245.132.106]:40600 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbYH1KlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 06:41:07 -0400
Date: Thu, 28 Aug 2008 12:40:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Joe Korty <joe.korty@ccur.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] make poll_idle behave more like the other idle methods
In-Reply-To: <20080828090036.GC19422@elte.hu>
Message-ID: <alpine.LFD.1.10.0808281215190.3243@apollo.tec.linutronix.de>
References: <20080827143506.GA23166@tsunami.ccur.com> <20080828090036.GC19422@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Ingo Molnar wrote:
> * Joe Korty <joe.korty@ccur.com> wrote:
> 
> > Make poll_idle() behave more like the other idle methods.
> > 
> > Currently, poll_idle() returns immediately.  The other
> > idle methods all wait indefinately for some condition
> > to come true before returning.  poll_idle should emulate
> > these other methods and also wait for a return condition,
> > in this case, for need_resched() to become 'true'.
> > 
> > Without this delay the idle loop spends all of its time
> > in the outer loop that calls poll_idle.  This outer loop,
> > these days, does real work, some of it under rcu locks.
> > That work should only be done when idle is entered and
> > when idle exits, not continuously while idle is spinning.
> 
> i'm wondering, what's the motivation, have you actually seen
> anything bad/undesired happen due to that?

Hmm, two observations:

1) I think Joe is right that idle_poll should behave like any other
idle function.

2) I wonder whether the work you observe is something we should
investigate. The only code which does work in the idle loop is
rcu_check_callbacks(). What kind of work load scenario do you have
which makes the rcu_check_callbacks() called ?

Thanks,

	tglx
