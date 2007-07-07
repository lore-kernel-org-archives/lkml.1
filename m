Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbXGGRBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbXGGRBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 13:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbXGGRB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 13:01:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53663 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752547AbXGGRB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 13:01:27 -0400
Date: Sat, 7 Jul 2007 19:01:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070707170157.GH3492@stusta.de>
References: <20070703164516.377240547@polymtl.ca> <20070703181151.GB5800@martell.zuzino.mipt.ru> <20070703185748.GA4047@Krystal> <20070705132120.8edbc1f3.akpm@linux-foundation.org> <p73vecx21um.fsf@bingen.suse.de> <468EBEB2.4070605@redhat.com> <20070706232843.GT3492@stusta.de> <20070706233827.GC13125@redhat.com> <20070707001008.GV3492@stusta.de> <y0mvecwusj3.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <y0mvecwusj3.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 11:45:20AM -0400, Frank Ch. Eigler wrote:
> Adrian Bunk <bunk@stusta.de> writes:
> 
> > [...]
> > profiling = debugging of performance problems
> 
> Indeed.
> 
> > My words were perhaps a bit sloppy, but profiling isn't part of
> > normal operation and if people use a separate kernel for such
> > purposes we don't need infrastructure for reducing performance
> > penalties of enabled debug options.
> 
> Things are not so simple.  One might not know that one has a
> performance problem until one tries some analysis tools.  Rebooting
> into different kernels just to investigate does not work generally:
> the erroneous phenomenon may have been short lived; the debug kernel,
> being "only" for debugging, may not be well tested => sufficiently
> trustworthy.

I'm not getting this:

You'll only start looking into an analysis tool if you have a 
performance problem, IOW if you are not satisfied with the performance.

And the debug code will not have been tested on this machine no matter 
whether it's enabled through a compile option or at runtime.

> Your question asking for an actual performance impact of dormant hooks
> is OTOH entirely legitimate.  It clearly depends on the placement of
> those hooks and thus their encounter rate, more so than their
> underlying technology (markers with whatever optimizations).  If the
> cost is small enough, you will likely find that people will be willing
> to pay a small fraction of average performance, in order to eke out
> large gains when finding occasional e.g. algorithmic bugs.

If you might be able to get a big part of tracing and other debug code 
enabled with a performance penalty of a few percent of _kernel_ 
performance, then you might get much debugging aid without any effective 
impact on application performance.

You always have to decide between some debug code and some small bit of 
performance. There's a reason why options to disable things like BUG() 
or printk() are in the kernel config menus hidden behind CONFIG_EMBEDDED
although they obviously have some performance impact.

> - FChE

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

