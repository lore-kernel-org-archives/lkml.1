Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0BJOFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 09:05:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58304 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab0BJOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 09:05:09 -0500
X-Authority-Analysis: v=1.0 c=1 a=I-JJUczq-h8A:10 a=7U3hwN5JcxgA:10 a=I-GeybmLbXDaOxhVHy8A:9 a=M02sSpJTzzKKQGYdHxjfm6JRmEcA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 02/11] tracing: Introduce TRACE_EVENT_INJECT
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20100210100440.GA5035@nowhere>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
	 <1265188475-23509-3-git-send-regression-fweisbec@gmail.com>
	 <1265381266.24386.32.camel@gandalf.stny.rr.com>
	 <1265381604.22001.682.camel@laptop>
	 <1265382452.24386.38.camel@gandalf.stny.rr.com>
	 <20100206122004.GF5062@nowhere> <1265462370.4561.12179.camel@frodo>
	 <20100210100440.GA5035@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 10 Feb 2010 09:05:06 -0500
Message-ID: <1265810706.24386.58.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 11:04 +0100, Frederic Weisbecker wrote:

> > We can add a register_event_injector later. For now, why not just add
> > the TRACE_EVENT() and then hook to it in perf using the normal
> > tracepoint mechanism.
> > 
> > You could add some macro around the trace_init_lock_class() call that
> > would facilitate finding all the locks you need. This would probably be
> > a bit more straight forward than to overload TRACE_EVENT() again.
> 
> 
> 
> I'm not sure what you mean by that.

Looking back at where trace_lock_class_init() was placed, you don't need
a wrapper. But instead, why not just have perf hook directly into the
trace_lock_class_init trace point, and do its injection directly.
Instead of needing to add some hack to TRACE_EVENT()?

-- Steve


