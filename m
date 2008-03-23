Return-Path: <linux-kernel-owner+w=401wt.eu-S1760606AbYCWLBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbYCWLBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 07:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757829AbYCWLBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 07:01:45 -0400
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:56566 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195AbYCWLBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 07:01:44 -0400
Date: Sun, 23 Mar 2008 13:01:33 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: tracing and mmiotrace
Message-ID: <20080323130133.4104c552@daedalus.pq.iki.fi>
In-Reply-To: <Pine.LNX.4.58.0803221609550.12942@gandalf.stny.rr.com>
References: <20080321233955.66e75a57@daedalus.pq.iki.fi>
 <20080322120746.GF13264@elte.hu>
 <20080322173245.01e69743@daedalus.pq.iki.fi>
 <Pine.LNX.4.58.0803221609550.12942@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008 16:16:48 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 22 Mar 2008, Pekka Paalanen wrote:
> 
> > First you see my check in __trace_special() trigger, and then NULL
> > pointer dereference BUG at ffffffff80259332 which translates to
> > kernel/trace/trace.c:639 in tracing_generic_entry_update(), line:
> > 	entry->preempt_count	= pc & 0xff;
> > I don't understand why it tries to dereference NULL even when I
> > check for it.
> 
> Interesting. I'll have to look into that more on Monday.

I found the culprit.

My code never calls tracing_reset(). If I had enabled
FTRACE_STARTUP_TEST, the selftest code would run tracing_reset().
So I copied stack_reset() from trace_sysprof.c and now recording works.
My bad.

btw. the semantics of verbose iter_ctrl seem inverted from user point
of view. I also noticed that 'trace' file does not consume the data and
'trace_pipe' does consume the data. This is important information for the
user.

I think it would be nice, if iter_ctrl listed only the flags the current
tracer supports. This would also imply, that the tracer is not started
automatically when selected. Most of the flags are not useful for
mmiotrace.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
