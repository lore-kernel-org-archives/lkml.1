Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbZFNRvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbZFNRvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 13:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZFNRvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 13:51:05 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:44636 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbZFNRvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 13:51:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RvQLMzd53dIlNLlDlQ9CltPfcXhi+CVuJiN1FhwIyWGCZXahu/6gACOFEORJii6gwY
         vrM0ErjS8FzWGlIU8RZcefOmQ89TcYYUh+Z3hJitNjr7zmAR/W9Op3MOmfLJ3hcu5PRp
         TwHbg1EuUY1XpbKqsn2tBMYf7UwroIVPsNSpI=
MIME-Version: 1.0
In-Reply-To: <4A32D1AF.7060107@am.sony.com>
References: <4A32D1AF.7060107@am.sony.com>
Date: Sun, 14 Jun 2009 19:51:04 +0200
Message-ID: <63386a3d0906141051v50cc441fj27f0132fa5c77b80@mail.gmail.com>
Subject: Re: [PATCH] ftrace,arm: add notrace to ARM sched_clock routines - 
	resend
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>, Paul Mundt <lethal@linux-sh.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/13 Tim Bird <tim.bird@am.sony.com>:

> Add notrace attribute to sched_clock, to avoid
> recursion with ftrace function tracing.
>
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> ---
>  arch/arm/mach-mmp/time.c       |    2 +-
>  arch/arm/mach-pxa/time.c       |    2 +-
>  arch/arm/mach-realview/core.c  |    2 +-
>  arch/arm/mach-sa1100/generic.c |    2 +-
>  arch/arm/mach-versatile/core.c |    2 +-
>  arch/arm/plat-omap/common.c    |    4 ++--
>  6 files changed, 7 insertions(+), 7 deletions(-)

And now that Paul Mundt is making it possible to use the default
sched_clock() with the generic clocksource and the OMAP hack
will likely go away, should the default implementation in
kernel/sched_clock.c also be tagged as
unsigned long long notrace __attribute__((weak)) sched_clock(void)
or something?

Should it be tagged notrace even if it's the old jiffybased one even?

Linus Walleij
