Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbZIILsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbZIILsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 07:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZIILsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 07:48:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59933 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbZIILsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 07:48:04 -0400
Subject: Re: [PATCH 1/2] tracing: Add sysctl to enable/disable tracing on
 oops
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090909122425.0CEF.A69D9226@jp.fujitsu.com>
References: <4AA715A3.8040108@cn.fujitsu.com>
	 <1252464784.12982.4.camel@gandalf.stny.rr.com>
	 <20090909122425.0CEF.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 09 Sep 2009 07:48:05 -0400
Message-Id: <1252496885.27001.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 13:19 +0900, KOSAKI Motohiro wrote:
> > On Wed, 2009-09-09 at 10:40 +0800, Li Zefan wrote:
> > 
> > > > I have another silly question.
> > > > Why should we call tracing_off() in oops_enter()?
> > > > 
> > > 
> > > I guess it's because trace outputs generated during oops can
> > > overwrite/mess up those generated before oops?
> > > 
> > > It was added by this commit, but I can't find trace_printk_on_oops.
> > 
> > That's because Thomas did not bother looking up the actual variable he
> > was talking about. s/trace_printk_on_oops/ftrace_dump_on_oops/
> 
> After a bit thinking, I think ftrace_dump_on_oops and kernel dump with panic have
> very similar requirement.
> Then, I think we can reuse this infrastructure for kernel dump.
> 
> Requirement
>   - Need to know why the problem occur.
>   - Need to don't logging oops (panic) internal.
> 
> Unfortunately, panic() call panic_notifier after crash_kexec().
> it mean tracing_off() was not called when panic on the machine w/ kernel-dump.
> 
> 	NORET_TYPE void panic(const char * fmt, ...)
> 	{
> 	(snip)
> 	        crash_kexec(NULL);
> 	(snip)
> 	        atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
> 
> I think we can insert tracing_off() into panic() directly. it only
> bit mask operation, it mean it don't have side effect risk.
> 
> Perhaps, There are other kernel dump specific requrement. but I guess
> it's very small. Maybe it can be handled by trace_die_handler() or something like.
> 
> What do you think?

Yes, a tracing_off() should be in the beginning of panic. I had a patch
to do this, but I never sent it out :-/

-- Steve


