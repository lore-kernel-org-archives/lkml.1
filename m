Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbYGaTR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYGaTR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbYGaTRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:17:48 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51513 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbYGaTRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:17:47 -0400
Date: Thu, 31 Jul 2008 22:16:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080731191650.GA23516@cs181140183.pp.htv.fi>
References: <20080731092703.661994657@free-electrons.com> <20080731093220.969460336@free-electrons.com> <20080731135319.GA20212@cs181140183.pp.htv.fi> <20080731162007.285938e0@surf> <20080731153757.GB20212@cs181140183.pp.htv.fi> <20080731182616.4c20f0db@surf> <20080731164918.GE20212@cs181140183.pp.htv.fi> <4891F724.3030406@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4891F724.3030406@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 10:32:20AM -0700, Tim Bird wrote:
> Adrian Bunk wrote:
> > And for embedded systems with which applications is it 100% safe to 
> > disable this option?
> 
> Sony's digital cameras.
> 
> This option *is* disabled in the kernel for (most) Sony digital cameras.
> Those digital cameras have the kernel, busybox, a custom C library,
> and one proprietary application.   The application does not use
> flock() (or AIO, or ethtool or multi-cast)
> 
> These cameras were heavily tested, and are shipping now.  I can't
> make any guarantees for other developers, but those of us who
> are careful about our application development would like the option
> to eliminate completely unused features from the kernel.  (And
> the C library, but that's a different issue.)
> 
> > And don't answer "doesn't use flock()", I want a real-life example of a 
> > device where you could guarantee a developer that disabling this option 
> > in his product would be safe.
> 
> I'm not sure why a guarantee is required that other developers
> use this option safely.  Maybe this is a point of disconnect between
> embedded folks and non-embedded folks.  We're accustomed to making
> tradeoff decisions that only affect our product, and which
> we take full responsibility for testing.

Thanks. That's quite different from Thomas' "In practice, I only tested
a CONFIG_FILE_LOCKING=n kernel with a basic Busybox under Qemu." and
addresses my concerns.

In case I didn't express myself clearly:
I was not interested in guarantees for random developers but in seeing 
some reasonable use case for a real device.

> If warnings or support avoidance for the general population using
> such config options is the issue, I think that David Woodhouse's
> suggestion that such things could taint the kernel is an interesting
> idea. Maybe have we could have an "unsafe-config" taint flag?

A CONFIG_EMBEDDED=y flag?

> I should add that I am sympathetic with the larger issue you raise
> about nibbling at the bottom with patches that only address a
> few KB of the problem, while the size continues to build (to an
> even greater degree) with each release.  My response is that I agree
> with you on the nibbling bit, but probably just at a different
> level of KB savings.
> 
> That is, I presume you'd be OK with something that saved 100K or
> even 20K, but balk at bit at these patches, which save 10k or less.
> My threshold is lower (probably down to about 5K, so these are
> pretty close to the bubble), but even I wouldn't recommend
> applying anything much below that.  We've already started
> considering to drop some linux-tiny patches that just don't save
> enough to warrant continued maintenance.

It's not only about limits, I also have a general dislike for the
"add more config options" approach.

I get your point why it brings advantages in some cases, but if you are 
looking for a cheerleader it won't be me.  ;-)

>  -- Tim

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

