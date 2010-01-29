Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013Ab0A2JWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab0A2JWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157Ab0A2JWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:22:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab0A2JWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:22:02 -0500
Date: Fri, 29 Jan 2010 10:21:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH tracing/kprobes] kprobes: Disable booster when
 CONFIG_PREEMPT=y
Message-ID: <20100129092135.GE10878@elte.hu>
References: <4B5E476C.9030303@redhat.com>
 <20100127215531.24775.26807.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127215531.24775.26807.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Disable kprobe booster when CONFIG_PREEMPT=y, because it can't ensure that 
> all kernel threads preempted on kprobe's boosted slot run out from the slot 
> even using freeze_processes().

hm, this really sucks as it makes preemptible kernels perform worse. Is there 
no better solution?

> The booster on preemptive kernel will be resumed if synchronize_tasks() or 
> something like that is introduced.

such as this one?

	Ingo
