Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbZEVNrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbZEVNrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 09:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbZEVNrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 09:47:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57778 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbZEVNrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 09:47:02 -0400
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	 <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 22 May 2009 15:46:56 +0200
Message-Id: <1243000016.6582.574.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 14:27 +1000, Paul Mackerras wrote:
> +       next_ctx = next->perf_counter_ctxp;
> +       if (next_ctx && context_equiv(ctx, next_ctx)) {
> +               task->perf_counter_ctxp = next_ctx;
> +               next->perf_counter_ctxp = ctx;
> +               ctx->task = next;
> +               next_ctx->task = task;
> +               return;
> +       }

Ingo just pointed out that there is nothing there to close the race with
attaching a counter.

That is, you could end up attaching your counter to the wrong task.

