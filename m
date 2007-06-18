Return-Path: <linux-kernel-owner+w=401wt.eu-S1761834AbXFRK6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761834AbXFRK6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760106AbXFRK6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:58:30 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44067 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbXFRK63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:58:29 -0400
Message-ID: <46766552.3080803@bull.net>
Date: Mon, 18 Jun 2007 12:58:26 +0200
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       Ulrich Drepper <drepper@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] Futex: Revert the non-functional REQUEUE_PI
References: <1182107470.8176.455.camel@chaos>
In-Reply-To: <1182107470.8176.455.camel@chaos>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 18/06/2007 13:02:19,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 18/06/2007 13:02:21,
	Serialize complete at 18/06/2007 13:02:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote :
> Patch d0aa7a70bf03b9de9e995ab272293be1f7937822 titled 
> 
> "futex_requeue_pi optimization"
> 
> introduced user space visible changes to the futex syscall.
> 
> The patch is non-functional and there is no way to fix it proper before
> the 2.6.22 release. 
> 
> The breakage report ( http://lkml.org/lkml/2007/5/12/17 ) went
> unanswered,

Sorry, but I passed lot of time on this last year without any answers or 
comments from the community when I have sent my patches.
Now I'm working on something else and I can't spent more time on this for now... 
Futexes are so complex that it is always difficult to investigate a problem in 
only one or two hours...

> and unfortunately it turned out that the concept is not
> feasible at all. 

Without robust futex, the concept works well, and the performance gain has been 
proven.

It violates the rtmutex semantics badly by introducing
> a virtual owner, which hacks around the coupling of the user-space
> pi_futex and the kernel internal rt_mutex representation.

What you call a hack, is for me a design point. And if this is a hack, then I 
think that we can say that futexes are based on a series of hacks...
But, okay, this is not very constructive, so...

Ulrich Drepper wrote :
 >
 > Indeed.  A lot more discussion is needed to handle this correctly.  No
 > committed code in glibc so far uses the function so removal is no problem.

Once again, it's a pity that people didn't spent time to comment on this when I 
was working on this.
Now, the work will probably just be lost...

-- 
Pierre
