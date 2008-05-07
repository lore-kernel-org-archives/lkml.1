Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbYEGVZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbYEGVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYEGVZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:25:08 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:38748 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506AbYEGVZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:25:04 -0400
Date: Thu, 8 May 2008 00:23:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
Message-ID: <20080507212343.GB14951@cs181133002.pp.htv.fi>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 10:52:36PM +0200, Thomas Gleixner wrote:
> On Wed, 7 May 2008, Adrian Bunk wrote:
>...
> > > >  Did my cpuinfo lie upto this point or shouldn't the flag be cleared? The
> > > > commit message for that change is completely and totally unhelpful.
> > > 
> > > others like to to whitebox methods, ..., please try attach patch to
> > > see if duron support PAT.
> > 
> > 
> > There surely is documentation available covering this?
> 
> There is, but there is no known validation of working CPUs, erratas
> ...
> 
> We have a well identified set of CPUs which can handle PAT and we dont
> want to open up a can of worms by unconditionally enabling it on any
> piece of silicon which claims to support PAT. This was made clear from
> the first submission of PAT.

But the commit description is empty.

> Also there is no downside on these older systems. They are fine with
> MTRRs and have been for years. We can revisit that once PAT support
> has stabilized.

My comment was about:
"please try attach patch to see if duron support PAT."

That information is for sure available.

>...
> > And that your commit added the same clear/set code in three different 
> > places doesn't look good - this really deserved from the beginning being 
> > factored out into an own function to avoid future problems when CPUs get 
> > added (like what happens with your patch here - it touches only one 
> > place, and since the same context is present in two places in the same 
> > file "patch" might even choose freely where it gets applied...).
> 
> Did you even look into the code which does all this feature trickery
> based on CPU vendors, families and models ? This is something which
> can not be changed easily. It's on our todo list and you wouldnt have
> noticed if 32 and 64 bit would still live in different trees.
> 
> This feature and detection code is hard to clean up and definitely out
> of the scope of this patch.

Did you even look at the commit we are discussing?

It ***adds*** exactly the same code at three different places.

>...
> > And this patch (by the author of the code himself) is the first time 
> > where it breaks.
> 
> Very interesting analysis. What broke ? This CPU was never in the set
> of supported ones at all.

The patch in the email I answered to was broken since the author did 
fall into his own trap by patching only one copy of his duplicated code.

> Anyway, you are welcome to review x86 code - it can definitely use
> more eyeballs, but please try to inform yourself about the topic or
> ask polite questions before yelling at people who contribute in a
> very valuable way.

I already try this (as far as my limited knowledge allows it).

But if you want "more eyeballs" and then valid critic like Pavel's in 
this case gets ignored that's pointless.

And the many commits with no adequate description or no description at 
all that came through the x86 tree are a real PITA for everyone trying 
to follow the commits.

> Thanks,
> 
> 	tglx

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

