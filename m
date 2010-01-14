Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014Ab0ANXIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0ANXIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281Ab0ANXIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:08:07 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:41545 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0ANXIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:08:05 -0500
Subject: Re: [RFC] [PATCH 5/7] X86 Support for Uprobes
From: Jim Keniston <jkenisto@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263467631.4244.294.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122558.22050.431.sendpatchset@srikar.in.ibm.com>
	 <1263467631.4244.294.camel@laptop>
Content-Type: text/plain
Date: Thu, 14 Jan 2010 15:07:35 -0800
Message-Id: <1263510455.4875.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 12:13 +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-11 at 17:55 +0530, Srikar Dronamraju wrote:
> > [PATCH] x86 support for Uprobes
> 
> So uhm,.. HAVE_UPROBE is basically HAVE_UBP?

Certainly ALMOST all the architecture-specific stuff we've factored out
of the old uprobes resides in ubp.  Because of how it exploits utrace,
uprobes also needs to know what signals to expect from breakpoint traps
and single-step traps.  (E.g., the "breakpoint signal" in s390 is
SIGILL.)

I have no objection to moving BREAKPOINT_SIGNAL and SSTEP_SIGNAL
to .../asm/ubp.h, even though ubp doesn't actually use them.  But until
we port ubp to other architectures, we won't know for sure whether we've
done a complete job of capturing all the arch-specific stuff there.

Jim

> 
> > Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
> > ---
> >  arch/x86/Kconfig               |    1 +
> >  arch/x86/include/asm/uprobes.h |   27 +++++++++++++++++++++++++++
> >  2 files changed, 28 insertions(+)
> > 
> > Index: new_uprobes.git/arch/x86/Kconfig
> > ===================================================================
> > --- new_uprobes.git.orig/arch/x86/Kconfig
> > +++ new_uprobes.git/arch/x86/Kconfig
> > @@ -51,6 +51,7 @@ config X86
> >  	select HAVE_KERNEL_LZMA
> >  	select HAVE_HW_BREAKPOINT
> >  	select HAVE_UBP
> > +	select HAVE_UPROBES
> >  	select HAVE_ARCH_KMEMCHECK
> >  	select HAVE_USER_RETURN_NOTIFIER
> >  
> > Index: new_uprobes.git/arch/x86/include/asm/uprobes.h
> > ===================================================================
> > --- /dev/null
> > +++ new_uprobes.git/arch/x86/include/asm/uprobes.h
> > @@ -0,0 +1,27 @@
> > +#ifndef _ASM_UPROBES_H
> > +#define _ASM_UPROBES_H
> > +/*
> > + *  Userspace Probes (UProbes)
> > + *  uprobes.h
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> > + *
> > + * Copyright (C) IBM Corporation, 2008, 2009
> > + */
> > +#include <linux/signal.h>
> > +
> > +#define BREAKPOINT_SIGNAL SIGTRAP
> > +#define SSTEP_SIGNAL SIGTRAP
> > +#endif				/* _ASM_UPROBES_H */
> 
> 

