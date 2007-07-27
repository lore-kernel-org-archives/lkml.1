Return-Path: <linux-kernel-owner+w=401wt.eu-S1762408AbXG0C4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762408AbXG0C4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 22:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbXG0C4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 22:56:16 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:36718 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588AbXG0C4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 22:56:15 -0400
Subject: Re: [patch] sched: make cpu_clock() not use the rq clock
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070726090012.GA5287@elte.hu>
References: <20070726090012.GA5287@elte.hu>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 22:56:13 -0400
Message-Id: <1185504973.6609.25.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-26-07 at 11:00 +0200, Ingo Molnar wrote:
> Subject: sched: make cpu_clock() not use the rq clock
> From: Ingo Molnar <mingo@elte.hu>
> 
> it is enough to disable interrupts to get the precise rq-clock
> of the local CPU.

Hi Ingo,

Those new fast nanoseconds resolution clock APIs are nice but it seems
to me that their naming and _where_ they are implemented in the tree is
a little odd, IMO.

We have:

1. sched_clock() is in kernel/sched.c (weak implementation)
2. sched_clock() is in arch/i386/kernel/tsc.c (architecture override)
3. rq_clock() is in kernel/sched.c
4. cpu_clock() is in kernel/sched.c

I would suggest:

1. rename sched_clock() (remove sched_ as it's not sched specific
anymore) and place it in kernel/time/...
2. rename the architecture specific version of it too 

This first function is the basic fast ns clock

3. base your rq_clock() on cpu_clock() (#4) or use the later directly.

This is local to sched.c

4. move cpu_clock() in kernel/time/...

This the per-cpu monotonic version.


See my point? Base the scheduler clock from a general kernel API, not
the other way around.

Just a suggestion.


Best regards,

- Eric


