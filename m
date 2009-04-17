Return-Path: <linux-kernel-owner+w=401wt.eu-S1761792AbZDQQSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761792AbZDQQSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbZDQQSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:18:36 -0400
Received: from THUNK.ORG ([69.25.196.29]:36748 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbZDQQSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:18:35 -0400
Date: Fri, 17 Apr 2009 12:18:21 -0400
From: Theodore Tso <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 3/5] tracing/events: add rcu locking around trace event
	prints
Message-ID: <20090417161820.GA26479@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
References: <20090416021830.556671772@goodmis.org> <20090416021928.467656424@goodmis.org> <alpine.DEB.2.00.0904171004210.14919@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904171004210.14919@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 10:08:57AM -0400, Steven Rostedt wrote:
> 
> Ted, is this patch still needed?
> 
> I'm starting to have second thoughts on this patch because it may require 
> adding: #include <linux/rcupdate.h> in include/trace/ftrace.h. Jeremy has 
> been struggling with include hell with these files.

Well, I either need that or I need a way of having a TP_PRINTK_PRE()
and TP_PRINTK_POST() so I can drop in the rcu_read_lock() and
rcu_read_unlock() where needed.  Or I need a TP_PRINTK_DELCARE() so I
can declare the temporary buffer, and we can go down that route.

I haven't been following all of the e-mail threads about the include
hell problem; what are the issues, exactly?  What's the problem with
simply including <linux/rcuupdate.h>, and any needed prequisites in
ftrace.h?

					- Ted
