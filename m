Return-Path: <linux-kernel-owner+w=401wt.eu-S1761195AbZDQPVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbZDQPVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759573AbZDQPUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:20:53 -0400
Received: from gw.goop.org ([64.81.55.164]:40085 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758692AbZDQPUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:20:53 -0400
Message-ID: <49E89E53.2010500@goop.org>
Date: Fri, 17 Apr 2009 08:20:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 3/5] tracing/events: add rcu locking around trace event
 prints
References: <20090416021830.556671772@goodmis.org> <20090416021928.467656424@goodmis.org> <alpine.DEB.2.00.0904171004210.14919@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904171004210.14919@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Ted, is this patch still needed?
>
> I'm starting to have second thoughts on this patch because it may require 
> adding: #include <linux/rcupdate.h> in include/trace/ftrace.h. Jeremy has 
> been struggling with include hell with these files.
>
> Hmm, maybe this is not an issue because we undef CREATE_TRACE_POINTS 
> before calling this.
>
> Jeremy,
>
> Do you see a problem if we include linux/rcupdate.h in ftrace.h?
> Remember, CREATE_TRACE_POINTS is undefined here.
>   
Hm, I don't think that matters; I'm seeing the #include problems when 
generating asm-offsets.h, which doesn't have CREATE_TRACE_POINTS set.

Or are you saying that you only need to include linux/rcupdate.h when 
CREATE_TRACE_POINTS is set?

    J
