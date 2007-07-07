Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbXGGRXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbXGGRXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 13:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbXGGRXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 13:23:45 -0400
Received: from 1wt.eu ([62.212.114.60]:3300 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbXGGRXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 13:23:45 -0400
Date: Sat, 7 Jul 2007 19:20:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@stusta.de>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Dave Jones <davej@redhat.com>,
       Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070707172011.GB943@1wt.eu>
References: <20070703181151.GB5800@martell.zuzino.mipt.ru> <20070703185748.GA4047@Krystal> <20070705132120.8edbc1f3.akpm@linux-foundation.org> <p73vecx21um.fsf@bingen.suse.de> <468EBEB2.4070605@redhat.com> <20070706232843.GT3492@stusta.de> <20070706233827.GC13125@redhat.com> <20070707001008.GV3492@stusta.de> <y0mvecwusj3.fsf@ton.toronto.redhat.com> <20070707170157.GH3492@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070707170157.GH3492@stusta.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 07:01:57PM +0200, Adrian Bunk wrote:
> On Sat, Jul 07, 2007 at 11:45:20AM -0400, Frank Ch. Eigler wrote:
> > Adrian Bunk <bunk@stusta.de> writes:
> > 
> > > [...]
> > > profiling = debugging of performance problems
> > 
> > Indeed.
> > 
> > > My words were perhaps a bit sloppy, but profiling isn't part of
> > > normal operation and if people use a separate kernel for such
> > > purposes we don't need infrastructure for reducing performance
> > > penalties of enabled debug options.
> > 
> > Things are not so simple.  One might not know that one has a
> > performance problem until one tries some analysis tools.  Rebooting
> > into different kernels just to investigate does not work generally:
> > the erroneous phenomenon may have been short lived; the debug kernel,
> > being "only" for debugging, may not be well tested => sufficiently
> > trustworthy.
> 
> I'm not getting this:
> 
> You'll only start looking into an analysis tool if you have a 
> performance problem, IOW if you are not satisfied with the performance.
> 
> And the debug code will not have been tested on this machine no matter 
> whether it's enabled through a compile option or at runtime.

At least all the rest of the code will be untouched and you will not have
to reboot the machine. If you reboot to another kernel, nothing ensures
that you will have the same code sequences (in fact, gcc will reorder
some parts of code such as loops just because of an additional 'if').
So you know that the non-debug code you run will remain untouched. *This*
is important, because the debug code is not there to debug itself, but
to debug the rest.

> > Your question asking for an actual performance impact of dormant hooks
> > is OTOH entirely legitimate.  It clearly depends on the placement of
> > those hooks and thus their encounter rate, more so than their
> > underlying technology (markers with whatever optimizations).  If the
> > cost is small enough, you will likely find that people will be willing
> > to pay a small fraction of average performance, in order to eke out
> > large gains when finding occasional e.g. algorithmic bugs.
> 
> If you might be able to get a big part of tracing and other debug code 
> enabled with a performance penalty of a few percent of _kernel_ 
> performance, then you might get much debugging aid without any effective 
> impact on application performance.

it largely depends on the application. Applications which require a lot
of system calls will be more sensible to kernel debugging. Common sense
also implies that such applications will be the ones for which kernel
debugging will be relevant.

> You always have to decide between some debug code and some small bit of 
> performance. There's a reason why options to disable things like BUG() 
> or printk() are in the kernel config menus hidden behind CONFIG_EMBEDDED
> although they obviously have some performance impact.

It is not for the CPU performance they can be disabled, but for the code
size which is a real problem on embedded system. While you often have
mem/cpu_mhz ratios around 1GB/1GHz on servers and desktops, you more often
have ratios like 16MB/500MHz which is 1:32 of the former. That's why you
optimize for size at the expense of speed on such systems.

> 
> > - FChE
> 
> cu
> Adrian

Regards,
Willy

