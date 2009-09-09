Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbZIICxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbZIICxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZIICxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:53:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51245 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZIICxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:53:05 -0400
Subject: Re: [PATCH 1/2] tracing: Add sysctl to enable/disable tracing on
 oops
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AA715A3.8040108@cn.fujitsu.com>
References: <4AA7092C.4070706@cn.fujitsu.com>
	 <1252461867.11070.6.camel@gandalf.stny.rr.com>
	 <20090909113231.0CE6.A69D9226@jp.fujitsu.com>
	 <4AA715A3.8040108@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 08 Sep 2009 22:53:04 -0400
Message-Id: <1252464784.12982.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 10:40 +0800, Li Zefan wrote:

> > I have another silly question.
> > Why should we call tracing_off() in oops_enter()?
> > 
> 
> I guess it's because trace outputs generated during oops can
> overwrite/mess up those generated before oops?
> 
> It was added by this commit, but I can't find trace_printk_on_oops.

That's because Thomas did not bother looking up the actual variable he
was talking about. s/trace_printk_on_oops/ftrace_dump_on_oops/

-- Steve

> 
> commit bdff78707f3ce47e891f3201c9666122a70556ce
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Jul 24 15:30:45 2009 -0400
> 
>     trace: stop tracer in oops_enter()
> 
>     If trace_printk_on_oops is set we lose interesting trace information
>     when the tracer is enabled across oops handling and printing. We want
>     the trace which might give us information _WHY_ we oopsed.
> 

