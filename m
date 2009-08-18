Return-Path: <linux-kernel-owner+w=401wt.eu-S1759157AbZHROUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157AbZHROUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZHROUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:20:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54963 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZHROUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:20:36 -0400
Date: Tue, 18 Aug 2009 10:19:06 -0400
From: Jason Baron <jbaron@redhat.com>
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH] tracing: Move tracepoint callbacks into DEFINE
Message-ID: <20090818141906.GA2669@redhat.com>
References: <1250580227-24363-1-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250580227-24363-1-git-send-email-jistone@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 12:23:47AM -0700, Josh Stone wrote:
> It's not strictly correct for the tracepoint reg/unreg callbacks to
> occur when a client is hooking up, because the actual tracepoint may no
> be present yet.  This happens to be fine for syscall, since that's in
> the core kernel, but it would cause problems for tracepoints defined in
> a module that hasn't been loaded yet.  It also means the reg/unreg has
> to be EXPORTed for any modules to use the tracepoint (as in SystemTap).
> 
> This patch removes DECLARE_TRACE_WITH_CALLBACK, and instead introduces
> DEFINE_TRACE_WITH_CALLBACK which stores the callbacks in struct
> tracepoint.  The callbacks are used now when the active state of the
> tracepoint changes in set_tracepoint & disable_tracepoint.
> 
> This also introduces TRACE_EVENT_WITH_CALLBACK, so those events can also
> provide callbacks if needed.
> 

this makes sense...Ingo also suggested having the two high level
tracepoints be 'TRACE_EVENT' style. That is we should be able to
register with the syscall entry and get the *all* the syscall numbers
and arguments, and likewise on exit we should be able to get *all*
syscall exit return values. see:

http://marc.info/?l=linux-kernel&m=125008740803571&w=2 

does this patch allow/do that?

thanks,

-Jason
