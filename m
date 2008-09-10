Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYIJMHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYIJMHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYIJMH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:07:29 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36666 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbYIJMH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:07:29 -0400
Date: Wed, 10 Sep 2008 16:12:51 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Frank Mayhar <fmayhar@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5] Fix itimer/many thread hang.
Message-ID: <20080910121251.GB220@tv-sign.ru>
References: <1220906643.31846.21.camel@bobble.smo.corp.google.com> <20080909070329.GD2086@elte.hu> <20080909160152.GA714@tv-sign.ru> <1220992172.23059.20.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220992172.23059.20.camel@bobble.smo.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Frank Mayhar wrote:
>
> On Tue, 2008-09-09 at 20:01 +0400, Oleg Nesterov wrote:
>
> > As for this particular function, it seems to me that ->signal == NULL
> > is not possible, no?
>
> That's not completely clear to me.  I'm allowing for the possibility
> that it might be called during, say, process teardown.  It's used in so
> many places that I'm uncomfortable leaving the == NULL check out.

Please see my reply to Roland.

> > Btw, this function has a lot of callers, perhaps it is better to
> > uninline it.
>
> If that's the consensus I'll do so.  I assumed that speed was more
> important than space in this case.  Am I mistaken?

Are you sure inline will be faster? It has a lot of calllers, think
about i-cache. And the function call is not that expensive.

But I am not expert.

> > So, the first CLONE_THREAD creates ->cputime.totals. After that
> > thread_group_cputime_account_xxx() start to use it even if the task
> > doesn't have the attached cpu timers.
> >
> > Stupid question: can't we allocate .totals in posix_cpu_timer_create() /
> > set_process_cpu_timer() ?
>
> That was the original plan but we (that is, Roland and I) decided to
> eliminate the separate storage for the dead-threads totals.  It's now
> all kept in the totals field, for the whole thread group.

I see, thanks.

Oleg.

