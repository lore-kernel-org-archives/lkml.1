Return-Path: <linux-kernel-owner+w=401wt.eu-S933119AbYBVTYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119AbYBVTYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761468AbYBVTVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:21:33 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3019 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760267AbYBVTVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:21:31 -0500
Date: Fri, 22 Feb 2008 20:09:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com
Subject: Re: [PATCH [RT] 02/14] spinlock: make preemptible-waiter feature a specific config option
Message-ID: <20080222190950.GC6060@ucw.cz>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net> <20080221152635.4804.52393.stgit@novell1.haskins.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221152635.4804.52393.stgit@novell1.haskins.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> We introduce a configuration variable for the feature to make it easier for
> various architectures and/or configs to enable or disable it based on their
> requirements.  
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  kernel/Kconfig.preempt |    9 +++++++++
>  kernel/spinlock.c      |    7 +++----
>  lib/Kconfig.debug      |    1 +
>  3 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
> index 41a0d88..5b45213 100644
> --- a/kernel/Kconfig.preempt
> +++ b/kernel/Kconfig.preempt
> @@ -86,6 +86,15 @@ config PREEMPT
>  	default y
>  	depends on PREEMPT_DESKTOP || PREEMPT_RT
>  
> +config DISABLE_PREEMPT_SPINLOCK_WAITERS
> +        bool
> +	default n
> +
> +config PREEMPT_SPINLOCK_WAITERS
> +        bool
> +	default y
> +	depends on PREEMPT && SMP && !DISABLE_PREEMPT_SPINLOCK_WAITERS

tabs vs. spaces problems?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
