Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbZHZN5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbZHZN5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbZHZN5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:57:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51008 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398AbZHZN5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:57:22 -0400
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <alpine.DEB.2.00.0908260944540.27786@gandalf.stny.rr.com>
References: <20090825141547.GE6114@nowhere>
	 <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>
	 <20090826123550.GD6009@nowhere>
	 <20090826125943.GA5946@osiris.boeblingen.de.ibm.com>
	 <20090826133019.GE6009@nowhere>
	 <alpine.DEB.2.00.0908260944540.27786@gandalf.stny.rr.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 15:56:05 +0200
Message-Id: <1251294965.18584.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 09:48 -0400, Steven Rostedt wrote:
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

Weren't there a few sites in the kernel where kernel threads temporarily
borrow the mm from someone?
