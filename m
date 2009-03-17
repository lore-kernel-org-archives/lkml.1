Return-Path: <linux-kernel-owner+w=401wt.eu-S1762964AbZCQH7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762964AbZCQH7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 03:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZCQH66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 03:58:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbZCQH65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 03:58:57 -0400
Date: Tue, 17 Mar 2009 03:58:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/7] tracing: replace TP<var> with TP_<var>
Message-ID: <20090317075852.GA9960@infradead.org>
References: <20090310045710.286915983@goodmis.org> <20090310045810.833427485@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310045810.833427485@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 12:57:12AM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: clean up
> 
> The macros TPPROTO, TPARGS, TPFMT, TPRAWFMT, and TPCMD all look a bit
> ugly. This patch adds an underscore to their names.

Honestly I think they still look ugly.

>  DECLARE_TRACE(subsys_eventname,
> -	TPPROTO(int firstarg, struct task_struct *p),
> -	TPARGS(firstarg, p));
> +	TP_PROTO(int firstarg, struct task_struct *p),
> +	TP_ARGS(firstarg, p));

Compare that to a

DECLARE_TRACE(subsys_eventname,
	trace_proto(int firstarg, struct task_struct *p),
	trace_args(firstarg, p));

or even when you insist on UPPERCASE:

DECLARE_TRACE(subsys_eventname,
	TRACE_PROTO(int firstarg, struct task_struct *p),
	TRACE_ARGS(firstarg, p));


