Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYF0Pqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYF0Pqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYF0Pqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:46:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37940 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYF0Pqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:46:30 -0400
Date: Fri, 27 Jun 2008 17:46:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH] x86: don't destroy %rbp on kernel-mode faults
Message-ID: <20080627154607.GA15718@elte.hu>
References: <20080627152216.GA8852@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627152216.GA8852@damson.getinternet.no>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> >From the code:
> 
>     "B stepping K8s sometimes report an truncated RIP for IRET exceptions
>     returning to compat mode. Check for these here too."
> 
> The code then proceeds to truncate the upper 32 bits of %rbp. This means
> that when do_page_fault() is finally called, its prologue,
> 
>     do_page_fault:
>         push %rbp
>         movl %rsp, %rbp
> 
> will put the truncated base pointer on the stack. This means that the
> stack tracer will not be able to follow the base-pointer changes and
> will see all subsequent stack frames as unreliable.
> 
> This patch changes the code to use a different register (%rcx) for the
> checking and leaves %rbp untouched.

applied to tip/x86/debug - thanks Vegard!

	Ingo
