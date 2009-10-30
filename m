Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZJ3AGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZJ3AGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZJ3AGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:06:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbZJ3AGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:06:14 -0400
Subject: Re: [PATCH 0/3][RFC] tracing/kprobes: prevent jprobes from
 crashing function graph tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
In-Reply-To: <4AEA23AB.9020605@redhat.com>
References: <20091029205151.852744305@goodmis.org>
	 <4AEA10EC.8000103@redhat.com>
	 <1256854653.26028.3255.camel@gandalf.stny.rr.com>
	 <4AEA23AB.9020605@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 29 Oct 2009 20:06:14 -0400
Message-Id: <1256861174.26028.3261.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 19:22 -0400, Masami Hiramatsu wrote:
> Steven Rostedt wrote:

> >> I think we can skip those user handlers, because those are irregular
> >> functions and user can control (enable/disable) it.
> > 
> > True, but it may be nice to still trace them.
> 
> Hm, in that case, I think we can change jprobe_return() to call
> f-g-tracer's return handler if needed as below;
> ---
> static inline jprobe_return(void)
> {
> 	implicit_function_return();	/* This executes f-g-tracer prologue */
> 	__jprobe_return();	/* This should be notraced */
> }

Hmm, That looks like it can be quite a hack. We don't know at that
moment if the handler has been traced or not. We can't always do the
function graph logic.

-- Steve


