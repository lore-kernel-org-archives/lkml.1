Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbZCLRvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbZCLRvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 13:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZCLRve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 13:51:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54788 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbZCLRve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:51:34 -0400
Date: Thu, 12 Mar 2009 13:51:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/core: bring back raw trace_printk for dynamic
 formats strings
In-Reply-To: <49b94a35.03e9300a.3afc.42cc@mx.google.com>
Message-ID: <alpine.DEB.2.00.0903121350490.3062@gandalf.stny.rr.com>
References: <49b94a35.03e9300a.3afc.42cc@mx.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Mar 2009, Frederic Weisbecker wrote:

> Impact: fix callsites with dynamic format strings
> 
> Since its new binary implementation, trace_printk() internally uses static
> containers for the format strings on each callsites.
> But the value is assigned once at build time, which means that it can't take
> dynamic formats.
> 
> So this patch unearthes the raw trace_printk implementation for the callers
> that will need trace_printk to be able to carry these dynamic format strings.
> The trace_printk() macro will use the appropriate implementation for each
> callsite.
> Most of the time however, the binary implementation will still be used.
> 
> The other impact of this patch is that mmiotrace_printk() will use the old
> implementation because it calls the low level trace_vprintk and we can't guess
> here whether the format passed in it is dynamic or not.
> 
> Some parts of this patch have been written by Steven Rostedt (most notably the
> part that chooses the appropriate implementation for each callsites).
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks Frederic!

Ingo, I'm going to pull this in my tree, since I have some patches 
dependent on it.

-- Steve
