Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0BMEjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 23:39:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab0BMEjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 23:39:54 -0500
Date: Fri, 12 Feb 2010 20:39:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 22/28] printk,kdb: capture printk() when in kdb shell
Message-Id: <20100212203922.d8fef332.akpm@linux-foundation.org>
In-Reply-To: <4B75E236.7060108@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
	<1266014143-29444-23-git-send-email-jason.wessel@windriver.com>
	<20100212145440.7f0c68d0.akpm@linux-foundation.org>
	<4B75E236.7060108@windriver.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 17:20:22 -0600 Jason Wessel <jason.wessel@windriver.com> wrote:

> Andrew Morton wrote:
> > On Fri, 12 Feb 2010 16:35:37 -0600 Jason Wessel <jason.wessel@windriver.com> wrote:
> >
> >   
> >> @@ -609,6 +610,14 @@ asmlinkage int printk(const char *fmt, ...)
> >>  	va_list args;
> >>  	int r;
> >>  
> >> +#ifdef CONFIG_KGDB_KDB
> >> +	if (unlikely(kdb_trap_printk)) {
> >> +		va_start(args, fmt);
> >> +		r = vkdb_printf(fmt, args);
> >> +		va_end(args);
> >> +		return r;
> >> +	}
> >> +#endif
> >>  	va_start(args, fmt);
> >>  	r = vprintk(fmt, args);
> >>  	va_end(args);
> >>     
> >
> > this?
> >
> > --- a/kernel/printk.c~a
> > +++ a/kernel/printk.c
> > @@ -594,7 +594,11 @@ asmlinkage int printk(const char *fmt, .
> >  	int r;
> >  
> >  	va_start(args, fmt);
> > +#ifdef CONFIG_KGDB_KDB
> > +	r = vkdb_printf(fmt, args);
> > +#else
> >  	r = vprintk(fmt, args);
> > +#endif
> >  	va_end(args);
> >  
> >  	return r;
> > _
> >   
> 
> If you feel that would be cleaner, I can make that change, but I would
> also have to call vprintk() from vkdb_printf when ever kdb_trap_printk
> is not set.  Do I understand your recommendation correctly?
> 

err, no, I must have been in a drunken stupor.  Was trying to find
a way to avoid the code duplication.


