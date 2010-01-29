Return-Path: <linux-kernel-owner+w=401wt.eu-S932314Ab0A2LbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0A2LbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 06:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349Ab0A2LbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 06:31:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab0A2LbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 06:31:21 -0500
Subject: Re: [PATCH tracing/kprobes] kprobes: Disable booster when
 CONFIG_PREEMPT=y
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <20100129092135.GE10878@elte.hu>
References: <4B5E476C.9030303@redhat.com>
	 <20100127215531.24775.26807.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20100129092135.GE10878@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 12:30:48 +0100
Message-ID: <1264764648.4283.2231.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 10:21 +0100, Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > Disable kprobe booster when CONFIG_PREEMPT=y, because it can't ensure that 
> > all kernel threads preempted on kprobe's boosted slot run out from the slot 
> > even using freeze_processes().
> 
> hm, this really sucks as it makes preemptible kernels perform worse. Is there 
> no better solution?

We could pre-allocate 1 slot per kernel thread.

