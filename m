Return-Path: <linux-kernel-owner+w=401wt.eu-S1764287AbXGFVIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764287AbXGFVIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761037AbXGFVIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:08:12 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53019 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760067AbXGFVIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:08:11 -0400
Date: Fri, 6 Jul 2007 23:08:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Bodo Eggert <7eggert@gmx.de>, Andi Kleen <andi@firstfloor.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070706210840.GP3492@stusta.de>
References: <8CTJM-4Z1-27@gated-at.bofh.it> <8CU38-5E1-23@gated-at.bofh.it> <8DjNU-4bL-47@gated-at.bofh.it> <8DkTC-5Vy-11@gated-at.bofh.it> <E1I6TAl-0002iC-W7@be1.lrz> <20070705154644.GA22597@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070705154644.GA22597@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 11:46:44AM -0400, Mathieu Desnoyers wrote:
> * Bodo Eggert (7eggert@gmx.de) wrote:
> > Andi Kleen <andi@firstfloor.org> wrote:
> > > Alexey Dobriyan <adobriyan@gmail.com> writes:
> > >> On Tue, Jul 03, 2007 at 12:40:56PM -0400, Mathieu Desnoyers wrote:
> > 
> > >> > Use immediate values with lower d-cache hit in optimized version as a
> > >> > condition for scheduler profiling call.
> > >> 
> > >> I think it's better to put profile.c under CONFIG_PROFILING as
> > >> _expected_, so CONFIG_PROFILING=n users won't get any overhead, immediate or
> > >> not. That's what I'm going to do after test-booting bunch of kernels.
> > > 
> > > No, it's better to handle this efficiently at runtime e.g. for
> > > distribution kernels. Mathieu's patch is good
> > 
> > IMO you should combine them. For distibutions, it may be good to include
> > profiling support unconditionally, but how many of the vanilla kernel users
> > are going to use profiling at all?
> 
> For CONFIG_PROFILING, I think of it more like a chicken and egg problem:
> as long as it won't be easy to enable when needed in distributions
> kernels, few profiling applications will use it. So if you ban it from
> distros kernel with a CONFIG option under the pretext that no profiling
> application use it, you run straight into a conceptual deadlock. :)
> 
> Another simliar example would be CONFIG_TIMER_STATS, used by powertop,
> which users will use to tune their laptops (I got 45 minutes more
> battery time on mine thanks to this wonderful tool). Compiling-in, but
> dynamically turning it on/off makes sense for a lot of kernel
> "profiling/stats extraction" mechanisms like those.
> 
> But I suspect they will be used by distros only when their presence when
> disabled will be unnoticeable or when a major portion of their users
> will yell loudly enough telling that they want this and this features,
> leaving the more specialized minority of distro users without these
> features that they need to fine-tune their applications or their kernel.

There's a surprisingly simple solution solving the problems you describe:

For userspace libraries, the common approach is to get them stripped and
have versions with all debugging symbols in some -dbg package. So if you 
want to debug an application using such a library, you simply install 
this -dbg package.

Just let distributions make the same for the kernel - add a -dbg flavour 
with many debugging options enabled. It might perhaps run 5% or 20% 
slower than the regular kernel, but you don't need profiling or powertop 
during normal operation - these are _debug_ tools.

This way, there's no runtime penalty and therefore no trickery
required for getting the overhead of _debug code_ lower.

> Mathieu

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

