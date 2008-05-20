Return-Path: <linux-kernel-owner+w=401wt.eu-S1765544AbYETKYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765544AbYETKYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764531AbYETKX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:23:59 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49222 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760817AbYETKX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:23:58 -0400
Date: Tue, 20 May 2008 13:21:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] build kernel/profile.o only when requested
Message-ID: <20080520102150.GJ17716@cs181133002.pp.htv.fi>
References: <20080519215306.GD17716@cs181133002.pp.htv.fi> <20080520020121.c443d562.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080520020121.c443d562.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 02:01:21AM -0700, Andrew Morton wrote:
> On Tue, 20 May 2008 00:53:06 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> 
> > Build kernel/profile.o only if CONFIG_PROFILING is enabled.
> > 
> > This makes CONFIG_PROFILING=n kernels smaller.
> > 
> > As a bonus, some profile_tick() calls and one branch from schedule() are 
> > now eliminated with CONFIG_PROFILING=n (but I doubt these are
> > measurable effects).
> > 
> > This patch changes the effects of CONFIG_PROFILING=n, but I don't think 
> > having more than two choices would be the better choice.
> > 
> > This patch also adds the name of the first parameter to the prototypes 
> > of profile_{hits,tick}() since I anyway had to add them for the dummy 
> > functions.
> > 
> 
> Little nits:
> 
> > index 05c1cc7..4081fa3 100644
> > --- a/include/linux/profile.h
> > +++ b/include/linux/profile.h
> > @@ -8,8 +8,6 @@
> >  
> >  #include <asm/errno.h>
> >  
> > -extern int prof_on __read_mostly;
> > -
> >  #define CPU_PROFILING	1
> >  #define SCHED_PROFILING	2
> >  #define SLEEP_PROFILING	3
> > @@ -19,14 +17,29 @@ struct proc_dir_entry;
> >  struct pt_regs;
> >  struct notifier_block;
> >  
> > +#if defined(CONFIG_PROFILING) && defined(CONFIG_PROC_FS)
> > +void create_prof_cpu_mask(struct proc_dir_entry *);
> 
> This omits the argument's name, whereas elsewhere you have taken care
> to introduce the name where it was missing.
> 
> > +#else
> > +#define create_prof_cpu_mask(x)			do { (void)(x); } while (0)
> 
> I think this could be a static inline, which is neater.
>...

In these two cases I only moved code.

And I actually moved the other code and git just decided to move the 
code that stayed instead since it creates less changed lines...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

