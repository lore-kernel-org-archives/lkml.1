Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYIJLi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYIJLi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYIJLiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:38:51 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:48715 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbYIJLiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:38:51 -0400
Date: Wed, 10 Sep 2008 15:44:01 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frank Mayhar <fmayhar@google.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5] Fix itimer/many thread hang.
Message-ID: <20080910114401.GA220@tv-sign.ru>
References: <1220906643.31846.21.camel@bobble.smo.corp.google.com> <20080909070329.GD2086@elte.hu> <20080909160152.GA714@tv-sign.ru> <20080910040404.245301541FE@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910040404.245301541FE@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Roland McGrath wrote:
>
> > As for this particular function, it seems to me that ->signal == NULL
> > is not possible, no?
> 
> The concern is to make sure that the timer tick path is always safe for a
> tick that hits during release_task(current) in exit_notify().  A timer tick
> there can come with current->signal == NULL.  We just need to make sure one
> way or another that this is safe.

run_posix_cpu_timers() must check ->signal != NULL anyway. (The same for
other functions like account_group_user_time() which are called by the
timer tick).

Apart from the timer tick, "current" should not use this function after
exit_notify().

And, if tsk != current, ->signal must be pinned, this means it can't be NULL.


Perhaps I missed something, but imho this check is confusing and misleading.
However, this is just a minor detail even if I am right.

Oleg.

