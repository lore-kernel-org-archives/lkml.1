Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZDPQsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZDPQsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbZDPQsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:48:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:36143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbZDPQsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:48:04 -0400
Subject: Re: [PATCH 2/2] tracing/events/lockdep: move tracepoints within
 recursive protection
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20090416161746.831882528@goodmis.org>
References: <20090416161543.199331330@goodmis.org>
	 <20090416161746.831882528@goodmis.org>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 18:47:49 +0200
Message-Id: <1239900469.23397.3128.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 12:15 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0002-tracing-events-lockdep-move-tracepoints-within-recu.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> With the current location of the tracepoints in lockdep, the system
> can hard lockup in minutes when the tracepoints are enabled.
> 
> Moving the tracepoints outside inside the lockdep protection solves
> the issue.

NAK

the idea is to eventually move lockdep on top of the tracepoints. The
tracer should grow to be more robust and handle recursion itself.

Its likely a case of the tracer using a spinlock or mutex in the
tracepoint code. When I did the tracepoints I converted one such to a
raw_spinlock_t in the trace_print code.



