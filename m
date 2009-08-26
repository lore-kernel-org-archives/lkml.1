Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbZHZNsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbZHZNsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbZHZNsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:48:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58379 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388AbZHZNst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:48:49 -0400
Date: Wed, 26 Aug 2009 09:48:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
In-Reply-To: <20090826133019.GE6009@nowhere>
Message-ID: <alpine.DEB.2.00.0908260944540.27786@gandalf.stny.rr.com>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090826123550.GD6009@nowhere> <20090826125943.GA5946@osiris.boeblingen.de.ibm.com> <20090826133019.GE6009@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Aug 2009, Frederic Weisbecker wrote:
> > 
> > That won't always work as pointed out in the other example:
> > - Process doing sys_init_module then scheduled away
> > - User enables syscall tracing -> TIF_SYSCALL_FTRACE gets set
> > - init function of the module gets called and is doing kernel_thread()
> >   (old API) -> kernel thread inherits TIF_SYSCALL_FTRACE.
> > 
> > I don't think that's what you want. You might want to clear the flag for
> > new processes during fork (only for kernel threads I would guess).
> > 
> > At least the current patch leaves a hole.
> 
> 
> Ah, there are callsites that use kernel_thread() directly?
> Does it means that t->mm could be non NULL for such resulting
> kernel threads, in that case it would be hard to hook on
> do_fork() to check that.

All kernel threads have a NULL t->mm. Since do_fork is called by kthreadd 
and not by kthread_create, the caller of do_fork will also have a
t->mm = NULL.

-- Steve

