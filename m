Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0CDRy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:54:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:51651 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab0CDRy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:54:26 -0500
Subject: Re: [PATCH 09/14] perf, x86: use LBR for PEBS IP+1 fixup
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
In-Reply-To: <4B8FDE16.3050403@redhat.com>
References: <20100304140046.596569763@chello.nl>
	 <20100304140100.619375431@chello.nl>  <4B8FDE16.3050403@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 18:54:22 +0100
Message-ID: <1267725262.25158.206.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 11:21 -0500, Masami Hiramatsu wrote:
> Peter Zijlstra wrote:

> > +#define perf_misc_flags(regs)				\
> > +({	int misc = 0;					\
> > +	if (user_mode(regs))				\
> > +		misc |= PERF_RECORD_MISC_USER;		\
> > +	else						\
> > +		misc |= PERF_RECORD_MISC_KERNEL;	\
> > +	if (regs->flags & PERF_EFLAGS_EXACT)		\
> > +		misc |= PERF_RECORD_MISC_EXACT;		\
> > +	misc; })
> > +
> > +#define perf_instruction_pointer(regs)	((regs)->ip)
> 
> Hmm, why don't you use instruction_pointer() defined in asm/ptrace.h?
> And I couldn't find any user of this macro in this patch...

perf_instruction_pointer() is used in kernel/perf_event.c, and yeah I
could have used instruction_pointer() but that's yet another wrapper.

Anyway, Yanmin is poking at doing kvm-guest profiling and will likely
rewrite all of the perf_misc() and perf_instruction_pointer() stuff
soon.

