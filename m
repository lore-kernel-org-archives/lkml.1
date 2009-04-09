Return-Path: <linux-kernel-owner+w=401wt.eu-S1765317AbZDIOvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765317AbZDIOvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbZDIOvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:51:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44004 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418AbZDIOvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:51:06 -0400
Date: Thu, 9 Apr 2009 10:51:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86,edac: fix for compiler error in traps.c
In-Reply-To: <20090409035839.GC20692@elte.hu>
Message-ID: <alpine.DEB.2.00.0904091048590.15932@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0904081954530.16430@gandalf.stny.rr.com> <alpine.DEB.2.00.0904082004070.16430@gandalf.stny.rr.com> <20090409035839.GC20692@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 9 Apr 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Impact: compile fix
> > 
> >  I got this compile failure on both tip/tracing/core as well as on 
> >  v2.6.30-rc1.
> >  
> >    LD      .tmp_vmlinux1
> >  arch/x86/kernel/built-in.o: In function `do_nmi':
> >  (.text+0x3c18): undefined reference to `edac_handler_set'
> >  arch/x86/kernel/built-in.o: In function `do_nmi':
> >  (.text+0x3c48): undefined reference to `edac_atomic_assert_error'
> >  make: *** [.tmp_vmlinux1] Error 1
> >  [root@bxrhel51 linux-trace.git]# grep edac_handler_set 
> >  [root@bxrhel51 linux-trace.git]# Grep edac_handler_set '*.[ch]'
> >  find .  -name "*.[ch]" ! -type d  | xargs grep  "edac_handler_set"
> >  ./arch/x86/kernel/traps.c:	if (edac_handler_set()) {
> >  ./include/linux/edac.h:extern int edac_handler_set(void);
> >  ./drivers/edac/edac_stub.c:int edac_handler_set(void)
> >  ./drivers/edac/edac_stub.c:EXPORT_SYMBOL_GPL(edac_handler_set);
> >  
> > This patch seems to fix it.
> 
> > -obj-$(CONFIG_EDAC)			:= edac_stub.o
> > +obj-$(CONFIG_EDAC)			+= edac_stub.o
> >  obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
> 
> It's weird that this breaks for you. What other bit of the kernel 
> introduces CONFIG_EDAC rules?
> 
> And it's clean to start driver rules with the := assignment and then 
> append to them via +=. The initial += should not be needed.
> 
> Are you sure you have a pristine build environment?

Good question.

I'll do a make clean and try again and let you know.

-- Steve

