Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbZBYNiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbZBYNiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 08:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbZBYNhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 08:37:53 -0500
Received: from THUNK.ORG ([69.25.196.29]:57834 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbZBYNhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 08:37:52 -0500
Date: Wed, 25 Feb 2009 08:37:40 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-ID: <20090225133740.GF7064@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Masami Hiramatsu <mhiramat@redhat.com>,
	Steven Rostedt <srostedt@redhat.com>
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org> <20090224194548.3effb746.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224194548.3effb746.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 07:45:48PM -0800, Andrew Morton wrote:
> echo sched_wakeup > /debug/tracing/set_event
> echo sched_wakeup > /debug/tracing/clear_event
> echo 1 > /debug/tracing/clear_all_events

>From a usability point of view, I'd prefer this as well.  It's only
two extra files, but it means that filenames in /deb/tracing is
self-documenting, which is a good thing.  Otherwise, it's really not
obvious that "echo !event > /debug/tracing/set_event" will disable the
event, and it's *especially* not obvious "echo > /debug/tracing/set_event"
will disable all events.

It's also a tad bit too easy to typo "echo > /debug/tracing/set_event"
by editing command history, and hitting return a bit too soon after
clearing out the previous event name but before you manage to type the
new event name.

						- Ted
