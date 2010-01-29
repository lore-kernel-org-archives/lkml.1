Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805Ab0A2OuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab0A2OuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447Ab0A2OuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:50:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab0A2OuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:50:16 -0500
Message-ID: <4B62F61D.5060203@redhat.com>
Date: Fri, 29 Jan 2010 09:52:13 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH tracing/kprobes] kprobes: Disable booster when CONFIG_PREEMPT=y
References: <4B5E476C.9030303@redhat.com> <20100127215531.24775.26807.stgit@dhcp-100-2-132.bos.redhat.com> <20100129092135.GE10878@elte.hu>
In-Reply-To: <20100129092135.GE10878@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Disable kprobe booster when CONFIG_PREEMPT=y, because it can't ensure that 
>> all kernel threads preempted on kprobe's boosted slot run out from the slot 
>> even using freeze_processes().
> 
> hm, this really sucks as it makes preemptible kernels perform worse. Is there 
> no better solution?
> 
>> The booster on preemptive kernel will be resumed if synchronize_tasks() or 
>> something like that is introduced.
> 
> such as this one?

Yes, I think this synchronize_tasks(), which just (sleeping) wait until
all currently preempted tasks are wake up and scheduled, can ensure safety.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

