Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbXKHBSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbXKHBSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 20:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757285AbXKHBSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 20:18:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51930 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757223AbXKHBSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 20:18:35 -0500
Date: Wed, 7 Nov 2007 17:17:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Schwab <schwab@suse.de>
Cc: lkml@davidb.org, linux-kernel@vger.kernel.org, drepper@redhat.com,
       mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Message-Id: <20071107171742.ee4a1401.akpm@linux-foundation.org>
In-Reply-To: <je640dsgj3.fsf@sykes.suse.de>
References: <20071107224722.GA20204@old.davidb.org>
	<20071107152833.6f302c2a.akpm@linux-foundation.org>
	<20071107161853.044b6e8f.akpm@linux-foundation.org>
	<je640dsgj3.fsf@sykes.suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 08 Nov 2007 01:54:40 +0100 Andreas Schwab <schwab@suse.de> wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > diff -puN kernel/compat.c~a kernel/compat.c
> > --- a/kernel/compat.c~a
> > +++ a/kernel/compat.c
> > @@ -162,7 +162,8 @@ asmlinkage long compat_sys_times(struct 
> >  		if (copy_to_user(tbuf, &tmp, sizeof(tmp)))
> >  			return -EFAULT;
> >  	}
> > -	return compat_jiffies_to_clock_t(jiffies);
> > +	return compat_jiffies_to_clock_t((jiffies + INITIAL_JIFFIES) &
> > +						LONG_MAX);
> 
> Are you sure you want LONG_MAX here, not 0x7fffffff?
> 

I'm not sure of anything - I'm just trolling ;)

That's 0x7fffffffffffffff for architectures which implement this function. 
I think that lines up correctly with jiffies and the return value from
compat_sys_times().

Perhaps formally it should be USERSPACE_CLOCK_T_MAX, but we don't have that.
