Return-Path: <linux-kernel-owner+w=401wt.eu-S1764269AbZAQAip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764269AbZAQAip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 19:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZAQAid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 19:38:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37114 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbZAQAic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 19:38:32 -0500
Date: Fri, 16 Jan 2009 19:38:30 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fwd: [LAU] [PATCH] [RT] tasklets: fix typo in
 tasklet_hi_action]
In-Reply-To: <1232147377.3081.8.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0901161938010.9232@gandalf.stny.rr.com>
References: <1232147377.3081.8.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Jan 2009, Fernando Lopez-Lezcano wrote:

> I don't know if you are aware of this patch (see below), it was
> apparently not xposted to lkml. If fixes the loooong standing midi
> problems in 2.6.26.x. I've tested (not very deeply) and it seems to work
> (and others have also reported success with it). It is not in rt13...

Ah, I think I do have it. It must have fell under the radar. Thanks!

-- Steve

> 
> -- Fernando
> 
> 
> -------- Forwarded Message --------
> From: Adam Sampson <ats@offog.org>
> To: linux-rt-users@vger.kernel.org
> Cc: linux-audio-user@lists.linuxaudio.org
> Subject: [LAU] [PATCH] [RT] tasklets: fix typo in tasklet_hi_action
> Date: Sun, 4 Jan 2009 15:20:58 +0000
> 
> [l-a-u CCed because we've been talking about this problem there
> recently, and that's what prodded me to do the bisection to track it
> down... fortunately the -rt8 to -rt9 interdiff was pretty small!]
> 
> Subject: [PATCH] [RT] tasklets: fix typo in tasklet_hi_action
> 
> Fix a typo in tasklet_hi_action -- using the wrong tasklet list when removing
> actions.
> 
> This appears to be what was causing the ALSA sequencer device not to work in
> 2.6.26 with the RT patch: the sequencer was flaky in -rt1 to -rt8, and just
> hung in -rt9 and later, after tasklets-fix-tasklet_hi_schedule.patch which
> fixed the same typo when adding to the list. I guess that's because before -rt9
> the actions were going onto the wrong list, whereas after -rt9 they were being
> lost entirely once the first one had been performed. It seems happy now,
> anyway.
> 
> Signed-off-by: Adam Sampson <ats@offog.org>
> 
> --- linux-2.6.26/kernel/softirq.c_orig	2009-01-04 14:41:06.000000000 +0000
> +++ linux-2.6.26/kernel/softirq.c	2009-01-04 14:41:49.000000000 +0000
> @@ -657,7 +657,7 @@
>  	local_irq_disable();
>  	list = __get_cpu_var(tasklet_hi_vec).head;
>  	__get_cpu_var(tasklet_hi_vec).head = NULL;
> -	__get_cpu_var(tasklet_hi_vec).tail = &__get_cpu_var(tasklet_vec).head;
> +	__get_cpu_var(tasklet_hi_vec).tail = &__get_cpu_var(tasklet_hi_vec).head;
>  	local_irq_enable();
>  
>  	__tasklet_action(a, list);
> 
> 
> 
> 
