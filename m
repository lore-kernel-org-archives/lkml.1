Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbZDNTX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbZDNTX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 15:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZDNTXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 15:23:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41479 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZDNTXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 15:23:50 -0400
Subject: Re: [PATCH 5/8] tracing/events: move the ftrace event tracing code
 to core
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
In-Reply-To: <20090414172641.457760734@goodmis.org>
References: <20090414172337.280621613@goodmis.org>
	 <20090414172641.457760734@goodmis.org>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 21:23:06 +0200
Message-Id: <1239736986.22720.266.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 13:23 -0400, Steven Rostedt wrote:
> + * static struct trace_event ftrace_event_type_<call> = {
> + *     .trace                  = ftrace_raw_output_<call>, <-- stage 2
> + * };

> + * static struct ftrace_event_call __used
> + * __attribute__((__aligned__(4)))
> + * __attribute__((section("_ftrace_events"))) event_<call> = {
> + *     .name                   = "<call>",
> + *     .system                 = "<system>",
> + *     .raw_init               = ftrace_raw_init_event_<call>,
> + *     .regfunc                = ftrace_reg_event_<call>,
> + *     .unregfunc              = ftrace_unreg_event_<call>,
> + *     .show_format            = ftrace_format_<call>,
> + * }

Is there a good reason these are two different structs?

I've always wondered about that, it seems natural to unify them and to
generalize the reverse lookup hash that is now private to trace_output.

The trace_event_profile code could use that reverse lookup, that linear
search it currently does it really lame.

