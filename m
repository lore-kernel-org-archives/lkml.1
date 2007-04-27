Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbXD0QSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbXD0QSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbXD0QSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:18:49 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41006 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053AbXD0QSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:18:48 -0400
Date: Fri, 27 Apr 2007 18:19:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] Introduce freezer flags
Message-ID: <20070427161940.GB1046@uranus.ravnborg.org>
References: <200704271737.31192.rjw@sisk.pl> <200704271740.17972.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704271740.17972.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 05:40:16PM +0200, Rafael J. Wysocki wrote:

> --- linux-2.6.21-rc7-mm2.orig/kernel/fork.c
> +++ linux-2.6.21-rc7-mm2/kernel/fork.c
> @@ -921,11 +921,14 @@ static inline void copy_flags(unsigned l
>  {
>  	unsigned long new_flags = p->flags;
>  
> -	new_flags &= ~(PF_SUPERPRIV | PF_NOFREEZE);
> +	new_flags &= ~PF_SUPERPRIV;
>  	new_flags |= PF_FORKNOEXEC;
>  	if (!(clone_flags & CLONE_PTRACE))
>  		p->ptrace = 0;
>  	p->flags = new_flags;
> +#ifdef CONFIG_FREEZER
> +	p->freezer_flags = 0;
> +#endif
>  }
Could we have a dedicated clear_freeze_flag() so we could drop the ifdef?

> +		clear_freeze_flag(p);

Or maybe we have it already?


	Sam
