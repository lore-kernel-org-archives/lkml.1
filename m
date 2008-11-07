Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbYKGXxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbYKGXxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYKGXxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:53:45 -0500
Received: from smtp4.Stanford.EDU ([171.67.219.84]:40404 "EHLO
	smtp4.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYKGXxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:53:44 -0500
Subject: Re: 2.6.26.6-rt11: BUGs (sleeping function called from invalid
	context)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1226094472.31966.93.camel@lappy.programming.kicks-ass.net>
References: <1226083858.20569.14.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0811071400570.3711@gandalf.stny.rr.com>
	 <1226085407.31966.58.camel@lappy.programming.kicks-ass.net>
	 <1226093710.20569.23.camel@localhost.localdomain>
	 <1226094472.31966.93.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 15:52:17 -0800
Message-Id: <1226101937.7647.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 22:47 +0100, Peter Zijlstra wrote:
> On Fri, 2008-11-07 at 13:35 -0800, Fernando Lopez-Lezcano wrote:
> > On Fri, 2008-11-07 at 20:16 +0100, Peter Zijlstra wrote:
> > > On Fri, 2008-11-07 at 14:01 -0500, Steven Rostedt wrote:
> > > > Peter, I think we've seen this before. It is the highmem code sleeping.
> > > 
> > > I've been working on an alternative kmap_atomic implementation for -rt,
> > > the below has been build and booted but not stressed, anybody care to
> > > give it a spin ?
> > 
> > I'll give it a try. Anything in particular I should try to do? Or not
> > do? Or watch for?
> 
> Lots of I/O should stress the i386 highmem stuff. If all is well it
> works, if not, crashes and splats.

Crashes and splats on boot... sorry, I don't have a way to capture the
kernel oops (or whatever happens, I can only see the end of the
printout)

-- Fernando

PS: things left on the screen (top to bottom):

? speedstep_detect_processor
? __copy_from_user_ll_noccache_nozero
iov_iter_copy_from_user_atomic
? generic_file_buffered_write
generic_file_buffered_write
? avs_has_perm_noaudit
? __rt_spin_lock
? selinux_inode_need_killpriv
? __rt_spin_lock
mnt_drop_write
__generic_file_aio_write_nolock
generic_file_aio_write
do_sync_write
? __enqueue_entity
? autoremove_wake_function
? selinux_file_oermission
? security_file_permission
? do_sync_write
vfs_write
sys_write
? schedule_tail
? ret_from_fork
? thread_kernel_helper


> > -- Fernando
> > 
> > 
> > > ---
> > >  arch/x86/mm/highmem_32.c  |  130 ++++++++++++++++++++++++++++++++++++++++++---
> > >  include/asm-x86/highmem.h |   11 ----
> > >  include/linux/sched.h     |    5 ++
> > >  kernel/sched.c            |   10 ++++
> > >  4 files changed, 137 insertions(+), 19 deletions(-)
> > >  [MUNCH]
> > 
> > 

