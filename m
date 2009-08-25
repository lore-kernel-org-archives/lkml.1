Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbZHYPin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbZHYPin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 11:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbZHYPim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 11:38:42 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:47755 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZHYPim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 11:38:42 -0400
Date: Tue, 25 Aug 2009 17:38:26 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 00/12] add syscall tracepoints V3 - s390 arch update
Message-ID: <20090825153826.GF4639@cetus.boeblingen.de.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
	mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
	peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
	jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <cover.1249932670.git.jbaron@redhat.com> <20090825123111.GD4639@cetus.boeblingen.de.ibm.com> <20090825135228.GD6114@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825135228.GD6114@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 03:52:32PM +0200, Frederic Weisbecker wrote:
> On Tue, Aug 25, 2009 at 02:31:11PM +0200, Hendrik Brueckner wrote:
> > This patch includes s390 arch updates for:
> > - tracing: Map syscall name to number (syscall_name_to_nr())
> > - tracing: Call arch_init_ftrace_syscalls at boot
> > - tracing: add support traceopint ids (set_syscall_{enter,exit}_id())
> > 
> > The patch already uses "NR_syscalls" instead of FTRACE_SYSCALL_MAX.
> > 
> > The patch is based on today's linux-next (20090825).
> > Since few of your patches already include s390 changes,
> > I would appreciate if you could add the patch to your patch set.
> > 
> > If you have any remarks, please let me know. 
> >   
> > Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
> 
> 
> Looks good at a first glance.
Thanks

> > +int syscall_name_to_nr(char *name)
> > +{
> > +	int i;
> > +
> > +	if (!syscalls_metadata)
> > +		return -1;
> > +	for (i = 0; i < NR_syscalls; i++)
> > +		if (syscalls_metadata[i])
> > +			if (!strcmp(syscalls_metadata[i]->name, name))
> > +				return i;
> > +	return -1;
> > +}
> > +void set_syscall_enter_id(int num, int id)
> > +{
> > +	syscalls_metadata[num]->enter_id = id;
> > +}
> > +
> > +void set_syscall_exit_id(int num, int id)
> > +{
> > +	syscalls_metadata[num]->exit_id = id;
> > +}
> 
> The three helpers above seem very common between archs, I guess
> we can move them to the core: kernel/trace/trace_syscalls.c
I think it is a good idea to move the helper routines to
kernel/trace/trace_syscalls.c.
