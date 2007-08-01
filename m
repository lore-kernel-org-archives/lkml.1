Return-Path: <linux-kernel-owner+w=401wt.eu-S1764045AbXHAAA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764045AbXHAAA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbXHAAAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:00:47 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:34114 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758554AbXHAAAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:00:46 -0400
Date: Tue, 31 Jul 2007 20:00:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: john stultz <johnstul@us.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>
Subject: Re: [RESEND] [BUG] futex_unlock_pi() hurts my brain and may cause
 application deadlock
In-Reply-To: <1185926019.8850.198.camel@localhost>
Message-ID: <Pine.LNX.4.58.0707311957530.7904@gandalf.stny.rr.com>
References: <1180572567.6126.44.camel@localhost.localdomain>
 <1185926019.8850.198.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



--
On Tue, 31 Jul 2007, john stultz wrote:

> On Wed, 2007-05-30 at 17:49 -0700, john stultz wrote:
>
> Hey Ingo,
> 	I sent this fix for this back in the 2.6.21-rt9 era, and I thought to
> picked it up, but I think it arrived amid some futex churn and
> apparently has been dropped or was just lost.
>
> Some of our testers have been reporting futex deadlocks and this fix
> resolves it, so I believe it to still be needed.

Heh, I remember this bug.  Wasn't there another patch that modified this.
I almost definitly remember this getting into the patch queue, but it must
have been dropped later.

John, thanks for looking into this deeper!

Acked-by: Steven Rostedt <rostedt@goodmis.org>

>
> thanks
> -john
>
> Avoid futex_unlock_pi returning -EFAULT (which results in deadlock), by
> clearing uval before jumping to retry_locked.
>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> Index: 2.6-rt/kernel/futex.c
> ===================================================================
> --- 2.6-rt.orig/kernel/futex.c	2007-07-31 16:48:41.000000000 -0700
> +++ 2.6-rt/kernel/futex.c	2007-07-31 16:48:48.000000000 -0700
> @@ -1673,6 +1673,7 @@ pi_faulted:
>  					 attempt);
>  		if (ret)
>  			goto out;
> +		uval = 0;
>  		goto retry_unlocked;
>  	}
>
>
>
>
>
