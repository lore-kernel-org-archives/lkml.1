Return-Path: <linux-kernel-owner+w=401wt.eu-S1751634AbZIJPCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbZIJPCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 11:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZIJPCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 11:02:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50399 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbZIJPCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 11:02:48 -0400
Subject: Re: [PATCH 4/5] hw-breakpoints: Arbitrate access to pmu following
 registers constraints
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Walker <dwalker@fifo99.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <1252594635.7205.39.camel@laptop>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
	 <1252571367-25876-5-git-send-email-fweisbec@gmail.com>
	 <1252593698.30578.176.camel@desktop>  <1252594635.7205.39.camel@laptop>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 10 Sep 2009 11:02:45 -0400
Message-Id: <1252594965.18996.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 16:57 +0200, Peter Zijlstra wrote:
> On Thu, 2009-09-10 at 07:41 -0700, Daniel Walker wrote:
> > On Thu, 2009-09-10 at 10:29 +0200, Frederic Weisbecker wrote:
> > 
> > > +static unsigned int max_task_bp_pinned(int cpu)
> > >  {
> > > -	if (atomic_inc_return(&bp_slot) == HBP_NUM) {
> > > -		atomic_dec(&bp_slot);
> > > +	int i;
> > > +	unsigned int *tsk_pinned = per_cpu(task_bp_pinned, cpu);
> > >  
> > > -		return -ENOSPC;
> > > +	for (i = HBP_NUM -1; i >= 0; i--) {
> > > +		if (tsk_pinned[i] > 0)
> > > +			return i + 1;
> > >  	}
> > 
> > One checkpatch error in the code above..
> > 
> > ERROR: need consistent spacing around '-' (ctx:WxV)
> > #206: FILE: kernel/hw_breakpoint.c:81:
> > +       for (i = HBP_NUM -1; i >= 0; i--) {
> >                          ^
> 
> Don't you have anything useful to do?

Well, to Daniel's credit, this really should be fixed.

-- Steve


