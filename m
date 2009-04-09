Return-Path: <linux-kernel-owner+w=401wt.eu-S935113AbZDIPHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935113AbZDIPHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763233AbZDIPHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:07:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51312 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762283AbZDIPHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:07:37 -0400
Date: Thu, 9 Apr 2009 11:07:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] x86,edac: fix for compiler error in traps.c
In-Reply-To: <20090408174833.b9bb56ec.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0904091105550.15932@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0904081954530.16430@gandalf.stny.rr.com> <alpine.DEB.2.00.0904082004070.16430@gandalf.stny.rr.com> <20090408174833.b9bb56ec.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew, I guess this change is not needed. Ingo was correct, there must 
have been something wrong with my build environment. Not sure what 
happened, but I had this failure right after updating my git repo. I did 
not do a make clean, so my build environment was not pristine. After doing 
a make clean, I no longer have this error.

Sorry for the noise.

-- Steve



On Wed, 8 Apr 2009, Andrew Morton wrote:

> On Wed, 8 Apr 2009 20:06:53 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
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
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
> > index a5fdcf0..cc2bcb4 100644
> > --- a/drivers/edac/Makefile
> > +++ b/drivers/edac/Makefile
> > @@ -7,7 +7,7 @@
> >  #
> >  
> >  
> > -obj-$(CONFIG_EDAC)			:= edac_stub.o
> > +obj-$(CONFIG_EDAC)			+= edac_stub.o
> >  obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
> >  
> >  edac_core-objs	:= edac_mc.o edac_device.o edac_mc_sysfs.o edac_pci_sysfs.o
> 
> OK, thanks, I'll send that Linuswards asap.
> 
> I guess it could/should be
> 
> 	obj-y += edac_stub.o
> 
> because CONFIG_EDAC is known to be true in drivers/edac/.  But that's
> just a consistency/style thing for Doug to scratch his head over ;)
> 
