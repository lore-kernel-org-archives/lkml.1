Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZJ1Ubr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZJ1Ubr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbZJ1Ubq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:31:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62166 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbZJ1Ubq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:31:46 -0400
Subject: Re: [RFC Patch 2/4] Allow breakpoints to be enabled/disabled
 without yielding the breakpoint request through new APIs -
 <enable><disable>_hw_breakpoint()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091026211915.GC15529@in.ibm.com>
References: <20091026211225.214925175@xyz>
	 <20091026211915.GC15529@in.ibm.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 28 Oct 2009 16:31:49 -0400
Message-Id: <1256761909.26028.1794.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 02:49 +0530, K.Prasad wrote:

> Index: linux-2.6-tip.perf_hbkpt/include/asm-generic/hw_breakpoint.h
> ===================================================================
> --- linux-2.6-tip.perf_hbkpt.orig/include/asm-generic/hw_breakpoint.h
> +++ linux-2.6-tip.perf_hbkpt/include/asm-generic/hw_breakpoint.h
> @@ -102,11 +102,22 @@
>   * ----------------------------------------------------------------------
>   */
>  struct hw_breakpoint {
> +	/*
> +	 * Denotes if a breakpoint is currently enabled in physical debug
> +	 * registers. Not to be set directly by the end-user. Must be
> +	 * operated through <enable><disable>_hw_breakpoint() APIs only.
> +	 */
> +	atomic_t enabled;

Just a nit, but by looking at this structure as a whole, it's not easy
to see that the above comment is talking just about the "enabled" part
of the structure or the entire structure itself.

Probably want to add ...

	/*
	 * The enabled item denotes if ...


-- Steve

>  	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
>  	const cpumask_t *cpumask;
>  	struct arch_hw_breakpoint info;
>  };
>  
> +enum bp_status {
> +	BP_DISABLED	= 0,
> +	BP_ENABLED	= 1
> +};
> +

