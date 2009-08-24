Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZHXWoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZHXWoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZHXWoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:44:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50907 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbZHXWoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:44:08 -0400
Date: Mon, 24 Aug 2009 18:44:00 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, lethal@linux-sh.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, jistone@redhat.com, tglx@linutronix.de,
       hpa@zytor.com
Subject: Re: [PATCH 2/4] Add NR_syscalls for x86_64
In-Reply-To: <20090824221447.GA5124@nowhere>
Message-ID: <alpine.DEB.2.00.0908241843450.32241@gandalf.stny.rr.com>
References: <cover.1251146512.git.jbaron@redhat.com> <233dfaa6fadd5aa2fa7ac8511ed9ab98a5f2619c.1251146513.git.jbaron@redhat.com> <20090824221447.GA5124@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 25 Aug 2009, Frederic Weisbecker wrote:

> On Mon, Aug 24, 2009 at 05:40:18PM -0400, Jason Baron wrote:
> > Add a dynamic definition of NR_syscalls for x86_64. This is used in the 
> > syscall events tracing code.
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > ---
> >  include/linux/ftrace.h |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > index dc3b132..3bd94ee 100644
> > --- a/include/linux/ftrace.h
> > +++ b/include/linux/ftrace.h
> > @@ -14,6 +14,11 @@
> >  
> >  #include <asm/ftrace.h>
> >  
> > +#ifdef CONFIG_X86_64
> > +#include <asm/asm-offsets.h>
> > +#define NR_syscalls (__NR_syscall_max + 1)
> > +#endif
> > +
> 
> 
> I'd rather see this in arch/x86/include/unistd_64.h, since
> NR_syscalls seems to be the defined in unistd.h in all archs.
> 
> That also makes a unified way to retrieve this number for
> other users.
> 

Yes, NR_syscalls should be included there.

-- Steve

