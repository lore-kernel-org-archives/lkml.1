Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbZDPRA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbZDPRA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZDPRAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:00:48 -0400
Received: from verein.lst.de ([213.95.11.210]:37891 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbZDPRAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:00:47 -0400
Date: Thu, 16 Apr 2009 18:58:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH 4/4] tracing/events: add trace-events-sample
Message-ID: <20090416165849.GF5933@lst.de>
References: <20090415031511.128139334@goodmis.org> <20090415031605.445499740@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415031605.445499740@goodmis.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 11:15:15PM -0400, Steven Rostedt wrote:
> +++ b/samples/trace_events/Makefile
> @@ -0,0 +1,8 @@
> +# builds the trace events example kernel modules;
> +# then to use one (as root):  insmod <module_name.ko>
> +
> +PWD := $(shell pwd)
> +
> +CFLAGS_trace-events-sample.o := -I$(PWD)/samples/trace_events/

CFLAGS_trace-events-sample.o += -I$(src)

That should better be written as.  But you'd easily get rid of that
by just including the file using #include "foo.h" instead of <foo.h>,
no?

> --- /dev/null
> +++ b/samples/trace_events/trace-events-sample.h
> @@ -0,0 +1,124 @@
> +/*
> + * Notice that this file is not protected like a normal header.
> + * We also must allow for rereading of this file. The
> + *
> + *  || defined(TRACE_HEADER_MULTI_READ)
> + *
> + * serves this purpose.
> + */
> +#if !defined(_TRACE_EVENT_SAMPLE_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_EVENT_SAMPLE_H

Why do we need this protection at all?  It only be included by the users
of the tracepoints, and it seems just fair to take some more than normal
precaution for more than unusual magic headers.

