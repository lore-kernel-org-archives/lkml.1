Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbZHZNxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbZHZNxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbZHZNxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:53:47 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:13658 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbZHZNxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:53:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JsRWFmm/5D2AOvhf86ORkYnT7eXKywkiz7+F6DgSx/vIu9olMGMFWbJjk2wwrG3f9g
         Lng7j1yAXiyN8/rNSTzrATp1So2CEYk9B7qyNNq0Ed9t2WidMSu2JSHZiIOYFL5Frgdk
         u33OnZBtnFUSJMfldkTRge3upK3oNNICA0XGQ=
Date: Wed, 26 Aug 2009 15:53:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826135331.GF6009@nowhere>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090826123550.GD6009@nowhere> <20090826125943.GA5946@osiris.boeblingen.de.ibm.com> <20090826133019.GE6009@nowhere> <alpine.DEB.2.00.0908260944540.27786@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908260944540.27786@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 09:48:48AM -0400, Steven Rostedt wrote:
> 
> On Wed, 26 Aug 2009, Frederic Weisbecker wrote:
> > > 
> > > That won't always work as pointed out in the other example:
> > > - Process doing sys_init_module then scheduled away
> > > - User enables syscall tracing -> TIF_SYSCALL_FTRACE gets set
> > > - init function of the module gets called and is doing kernel_thread()
> > >   (old API) -> kernel thread inherits TIF_SYSCALL_FTRACE.
> > > 
> > > I don't think that's what you want. You might want to clear the flag for
> > > new processes during fork (only for kernel threads I would guess).
> > > 
> > > At least the current patch leaves a hole.
> > 
> > 
> > Ah, there are callsites that use kernel_thread() directly?
> > Does it means that t->mm could be non NULL for such resulting
> > kernel threads, in that case it would be hard to hook on
> > do_fork() to check that.
> 
> All kernel threads have a NULL t->mm. Since do_fork is called by kthreadd 
> and not by kthread_create, the caller of do_fork will also have a
> t->mm = NULL.
> 
> -- Steve
> 

Yeah, that's the case with kthread_create() creation fashion,
but what if you create a kernel thread using the low level
kernel_thread() directly (ie: without relaying on kthreadd queue)?

Especially in Heiko example, it seems to be a duplication of user
task.

I wonder what obvious think I'm missing here...

