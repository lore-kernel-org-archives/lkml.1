Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZGQU2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZGQU2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZGQU2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:28:30 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:53316 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbZGQU23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:28:29 -0400
Date: Fri, 17 Jul 2009 22:28:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>
Subject: Re: [RFC][ PATCH -tip v2 3/7] Kbuild: disable gcc crossjumping
Message-ID: <20090717202825.GA6872@merkur.ravnborg.org>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
	lkml <linux-kernel@vger.kernel.org>,
	systemtap <systemtap@sources.redhat.com>,
	DLE <dle-develop@lists.sourceforge.net>,
	Jim Keniston <jkenisto@us.ibm.com>,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Anders Kaseorg <andersk@ksplice.com>,
	Tim Abbott <tabbott@ksplice.com>
References: <20090622212255.5384.53732.stgit@localhost.localdomain> <20090622212313.5384.84166.stgit@localhost.localdomain> <alpine.DEB.2.00.0906271611280.12592@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906271611280.12592@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 04:13:04PM -0400, Steven Rostedt wrote:
> 
> A change like this requires an ACK from Sam Ravnborg.
> 
> -- Steve

Overdue review...

I do not know the gcc option so I cannot comment on theeffect of it.

> 
> > 
> > diff --git a/Makefile b/Makefile
> > index 2903e13..f73b139 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -524,6 +524,10 @@ else
> >  KBUILD_CFLAGS	+= -O2
> >  endif
> >  
> > +ifdef CONFIG_DISABLE_CROSSJUMP
> > +KBUILD_CFLAGS	+= -fno-crossjumping
> > +endif
> > +
> >  include $(srctree)/arch/$(SRCARCH)/Makefile

Why do we add this option _before_ we include the arch specific Makefile?
If we do not want the arch specific Makefile to undo this then move it lower.

Also please add a comment what the effect of the disabling is.
There is no reason I should fire up info gcc to find out
what -fno-crossjumping is about.


> >  
> >  ifneq ($(CONFIG_FRAME_WARN),0)
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index 8da7467..f88e6b8 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -673,6 +673,13 @@ config FRAME_POINTER
> >  	  larger and slower, but it gives very useful debugging information
> >  	  in case of kernel bugs. (precise oopses/stacktraces/warnings)
> >  
> > +config DISABLE_CROSSJUMP
> > +	bool "Disable cross-function jump optimization"
> > +	help
> > +	  This build option disables cross-function jump optimization
> > +	  (crossjumping) of gcc. Disabling crossjumping might increase
> > +	  kernel binary size a little.

So the above comment tells me that is I disable crossjumping I will
increase the kernel image a little.
That is by no means a good explanation.

Please explain the potential advantage of disabling crossjumping.

	Sam
