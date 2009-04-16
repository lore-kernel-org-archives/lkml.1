Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZDPOIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZDPOIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZDPOIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:08:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41694 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZDPOIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:08:45 -0400
Date: Thu, 16 Apr 2009 10:08:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tracing: add #include <linux/delay.h> to fix build
 failure in test_work()
In-Reply-To: <20090416083934.GB9813@elte.hu>
Message-ID: <alpine.DEB.2.00.0904161008080.6495@gandalf.stny.rr.com>
References: <20090416021830.556671772@goodmis.org> <20090416021928.239106997@goodmis.org> <20090416083934.GB9813@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Apr 2009, Ingo Molnar wrote:
> 
> ------------------------>
> >From 63c14122a54c26122ccdbe596123f8e2b75c3116 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu, 16 Apr 2009 10:26:51 +0200
> Subject: [PATCH] tracing: add #include <linux/delay.h> to fix build failure in test_work()
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: 8bit
> 
> This build failure occured on a few rare configs:
> 
>  kernel/trace/trace_events.c: In function ?test_work?:
>  kernel/trace/trace_events.c:975: error: implicit declaration of function ?udelay?
>  kernel/trace/trace_events.c:980: error: implicit declaration of function ?msleep?
> 
> delay.h is included in way too many other headers, hiding cases
> where new usage is added without header inclusion.
> 
> Impact: build fix
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Thanks Ingo!

I don't see this change in tip, do you want me to apply it in my tree?

-- Steve

> ---
>  kernel/trace/trace_events.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 96934f0..791501d 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -15,6 +15,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/module.h>
>  #include <linux/ctype.h>
> +#include <linux/delay.h>
>  
>  #include "trace_output.h"
>  
> 
