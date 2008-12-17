Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756904AbYLQEQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYLQEQm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 23:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbYLQEQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 23:16:32 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:59683 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbYLQEQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 23:16:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAKwGSElMROB9/2dsb2JhbACBbLp4V5E+gn8
Date: Tue, 16 Dec 2008 23:16:28 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ltt-dev] [PATCH] Simple LTTng userspace events through debugfs
Message-ID: <20081217041628.GA5409@Krystal>
References: <20081215231040.GA5936@Krystal> <20081216194201.GE843@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081216194201.GE843@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:12:00 up 30 days,  4:52,  2 users,  load average: 4.68, 4.81,
	3.36
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi,
> > 
> > I looked at kmemtrace and noticed that the presence of a debugfs 
> > "marker" file, which lets userspace write events into the trace buffers.
> > 
> > So I just did the same with a
> > 
> > /debugfs/ltt/write_event
> 
> you mean similar to ftrace's /debug/tracing/trace_marker ? ;-)
> 

Quite similar, yes :)

Looking at tracing_mark_write(), I am wondering if the fact that it
returns a count including the added \n is an expected side effect ? A
write() returning a count larger than the number of bytes written seems
to be a bit unexpected... But if we remove the \n from the count, then
the case where one write \0 into the event content would end up doing an
endless loop.

Mathieu

> 	Ingo
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
