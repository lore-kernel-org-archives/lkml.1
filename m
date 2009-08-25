Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZHYNmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZHYNmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 09:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZHYNmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 09:42:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbZHYNmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:42:14 -0400
Date: Tue, 25 Aug 2009 09:40:05 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, lethal@linux-sh.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, jistone@redhat.com, tglx@linutronix.de,
       hpa@zytor.com
Subject: Re: [PATCH 2/4] Add NR_syscalls for x86_64
Message-ID: <20090825134005.GB2656@redhat.com>
References: <cover.1251146512.git.jbaron@redhat.com> <233dfaa6fadd5aa2fa7ac8511ed9ab98a5f2619c.1251146513.git.jbaron@redhat.com> <20090824221447.GA5124@nowhere> <alpine.DEB.2.00.0908241843450.32241@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908241843450.32241@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 06:44:00PM -0400, Steven Rostedt wrote:
> On Tue, 25 Aug 2009, Frederic Weisbecker wrote:
> 
> > On Mon, Aug 24, 2009 at 05:40:18PM -0400, Jason Baron wrote:
> > > Add a dynamic definition of NR_syscalls for x86_64. This is used in the 
> > > syscall events tracing code.
> > > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > 
> > > ---
> > >  include/linux/ftrace.h |    5 +++++
> > >  1 files changed, 5 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > > index dc3b132..3bd94ee 100644
> > > --- a/include/linux/ftrace.h
> > > +++ b/include/linux/ftrace.h
> > > @@ -14,6 +14,11 @@
> > >  
> > >  #include <asm/ftrace.h>
> > >  
> > > +#ifdef CONFIG_X86_64
> > > +#include <asm/asm-offsets.h>
> > > +#define NR_syscalls (__NR_syscall_max + 1)
> > > +#endif
> > > +
> > 
> > 
> > I'd rather see this in arch/x86/include/unistd_64.h, since
> > NR_syscalls seems to be the defined in unistd.h in all archs.
> > 
> > That also makes a unified way to retrieve this number for
> > other users.
> > 
> 
> Yes, NR_syscalls should be included there.
> 
> -- Steve

right, for x86_64, unistd.h is included to generate __NR_syscall_max
which is then used for NR_syscalls. So I did initially try it there, but
there were dependency problems. I'll see what I can come up with...

thanks,

-Jason
