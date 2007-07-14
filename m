Return-Path: <linux-kernel-owner+w=401wt.eu-S1760335AbXGNRJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbXGNRJM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 13:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbXGNRI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 13:08:59 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:5847 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971AbXGNRI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 13:08:59 -0400
Subject: Re: [PATCH -rt 3/5] asm/local.h cmpxchg
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070714175839.921317000@chello.nl>
References: <20070714175733.194012000@chello.nl>
	 <20070714175839.921317000@chello.nl>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 09:52:43 -0700
Message-Id: <1184431963.2601.8.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 19:57 +0200, Peter Zijlstra wrote:
> ===================================================================
> ---
> linux-2.6.22-rc6-mm1.orig/include/asm-generic/local.h       2007-07-12
> 19:44:18.000000000 -0700
> +++ linux-2.6.22-rc6-mm1/include/asm-generic/local.h    2007-07-12
> 19:44:57.000000000 -0700
> @@ -46,13 +46,34 @@ typedef struct
>  #define local_add_unless(l, a, u) atomic_long_add_unless((&(l)->a),
> (a), (u))
>  #define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
>  
> -/* Non-atomic variants, ie. preemption disabled and won't be touched
> - * in interrupt, etc.  Some archs can optimize this case well. */
> +/*
> + * Establish a state necessary for __local_xx functions to work.
> + */
> +#define __local_begin(flags)   local_irq_disable(flags) 

Did you mean local_irq_save(flags)? local_irq_disable() doesn't take any
arguments.

Daniel

