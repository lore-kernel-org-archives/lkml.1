Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbZFNVbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbZFNVbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 17:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbZFNVbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 17:31:35 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52594 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328AbZFNVbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 17:31:34 -0400
Date: Mon, 15 Jun 2009 06:30:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ftrace,arm: add notrace to ARM sched_clock routines - resend
Message-ID: <20090614213049.GA15366@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Tim Bird <tim.bird@am.sony.com>,
	linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Russell King <rmk@arm.linux.org.uk>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	Tony Lindgren <tony@atomide.com>
References: <4A32D1AF.7060107@am.sony.com> <63386a3d0906141051v50cc441fj27f0132fa5c77b80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d0906141051v50cc441fj27f0132fa5c77b80@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 07:51:04PM +0200, Linus Walleij wrote:
> 2009/6/13 Tim Bird <tim.bird@am.sony.com>:
> 
> > Add notrace attribute to sched_clock, to avoid
> > recursion with ftrace function tracing.
> >
> > Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> > ---
> >  arch/arm/mach-mmp/time.c       |    2 +-
> >  arch/arm/mach-pxa/time.c       |    2 +-
> >  arch/arm/mach-realview/core.c  |    2 +-
> >  arch/arm/mach-sa1100/generic.c |    2 +-
> >  arch/arm/mach-versatile/core.c |    2 +-
> >  arch/arm/plat-omap/common.c    |    4 ++--
> >  6 files changed, 7 insertions(+), 7 deletions(-)
> 
> And now that Paul Mundt is making it possible to use the default
> sched_clock() with the generic clocksource and the OMAP hack
> will likely go away, should the default implementation in
> kernel/sched_clock.c also be tagged as
> unsigned long long notrace __attribute__((weak)) sched_clock(void)
> or something?
> 
> Should it be tagged notrace even if it's the old jiffybased one even?
> 
Thanks for pointing that out. Yes, the new generic version will need the
notrace attribute as well, I will include this in the next iteration.
