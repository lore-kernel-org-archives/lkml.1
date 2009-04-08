Return-Path: <linux-kernel-owner+w=401wt.eu-S1765880AbZDHN4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765880AbZDHN4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759877AbZDHN4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:56:01 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38673 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbZDHN4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:56:00 -0400
Date: Wed, 8 Apr 2009 15:58:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Huang Weiyi <weiyi.huang@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] x86: remove dupilcated #include
Message-ID: <20090408135803.GA21624@uranus.ravnborg.org>
References: <1239009605-1796-1-git-send-email-weiyi.huang@gmail.com> <20090408122121.GB18581@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408122121.GB18581@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 02:21:21PM +0200, Ingo Molnar wrote:
> 
> * Huang Weiyi <weiyi.huang@gmail.com> wrote:
> 
> > Remove dupilcated #include in arch/x86/kernel/dumpstack.c.
> > 
> > Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> > ---
> >  arch/x86/kernel/dumpstack.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> > index 95ea5fa..6d7966d 100644
> > --- a/arch/x86/kernel/dumpstack.c
> > +++ b/arch/x86/kernel/dumpstack.c
> > @@ -15,7 +15,6 @@
> >  #include <linux/bug.h>
> >  #include <linux/nmi.h>
> >  #include <linux/sysfs.h>
> > -#include <linux/ftrace.h>
> >  
> >  #include <asm/stacktrace.h>
> 
> Many of those include lines are probably unnecessary. Instead of 
> these trivial patches causing churn, would you be interested in 
> doing a comprehensive search to eliminate all the unused ones?
> That would be a real step forward. (and this holds for your 
> other patches in this series too.)
> 
> The include files section of fault.c might be a good template to 
> use:
> 
> #include <linux/magic.h>		/* STACK_END_MAGIC		*/
> #include <linux/sched.h>		/* test_thread_flag(), ...	*/
> #include <linux/kdebug.h>		/* oops_begin/end, ...		*/
> #include <linux/module.h>		/* search_exception_table	*/
> #include <linux/bootmem.h>		/* max_low_pfn			*/
> #include <linux/kprobes.h>		/* __kprobes, ...		*/
> #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
> #include <linux/perf_counter.h>		/* perf_swcounter_*(), ...	*/
> 
> #include <asm/traps.h>			/* dotraplinkage, ...		*/
> #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
> #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
> 
> I was able to eliminate half of all include file lines there.

I assume you are aware that when you minimize the # of include file in
the various .c files, then you implicitly add dependency on the includes
the individual .h files have.

If we for example killed the include of <linux/list.h> from <linux/module.h>
with this approach we would likely see random build failures.

It is good to have it cleaned up but we should keep a critical eye on the
header files we use. Sometimes these are the right target
to clean up but as this is a bit more complicated or at least requires
more build testing to do right.

	Sam
