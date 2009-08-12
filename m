Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbZHLOBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbZHLOBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZHLOBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:01:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54603 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZHLOBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:01:12 -0400
Date: Wed, 12 Aug 2009 09:59:54 -0400
From: Jason Baron <jbaron@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [GIT PULL] tracing: Syscalls trace events + perf support
Message-ID: <20090812135954.GA2711@redhat.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <20090812091133.GA21655@elte.hu> <20090812110307.GA806@elte.hu> <20090812113308.GD6081@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812113308.GD6081@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 01:33:09PM +0200, Frederic Weisbecker wrote:
> On Wed, Aug 12, 2009 at 01:03:07PM +0200, Ingo Molnar wrote:
> > 
> > one thing i noticed is that we dont seem to be catching 
> > compat syscalls properly:
> 
> 
> Oh right. While looking at fs/compat.c, it seems most of the
> compat syscalls haven't been defined through the SYSCALL_DEFINE
> macro.
> 
> Grr...
> 

right. I mentioned this in a pervious mail that we weren't handling
compat syscalls. That said, the pervious syscall tracer also had the
same issue, so we haven't taken a step back. I guess we need to convert
some of the compat layer to use the DEFINE_SYSCALL() macros. Also, there
are a number of 64-bit syscalls that don't use DEFINE_SYSCALL either.
Those need to converted as well. The patchset I submitted converted a
couple of them....

thanks,

-Jason
