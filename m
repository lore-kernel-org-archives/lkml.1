Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYK2JRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYK2JRG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 04:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbYK2JQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 04:16:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55407 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYK2JQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 04:16:53 -0500
Date: Sat, 29 Nov 2008 10:16:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/branch-tracer: include missing irqflags.h
Message-ID: <20081129091647.GA25109@elte.hu>
References: <4930B32E.6060403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4930B32E.6060403@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: fix build error on branch tracer
> 
> This should fix a build error reported on alpha in linux-next:
> 
>  CC      kernel/trace/trace_branch.o
> kernel/trace/trace_branch.c: In function 'probe_likely_condition':
> kernel/trace/trace_branch.c:44: error: implicit declaration of function 'raw_local_irq_save'
> kernel/trace/trace_branch.c:76: error: implicit declaration of function 'raw_local_irq_restore'

applied to tip/tracing

> Unfortunately, I can't test it since I don't have any Alpha build 
> environment.

it does not trigger with an Alpha defconfig - we do test that.

And the thing is, lockdep (which introduced irqflags tracing) has been 
introduced upstream two years ago - and Alpha still does not have it 
implemented. The architecture should be marked CONFIG_BROKEN if it 
continues to cause problems like this.

Alexey, you seem to be using and relying on the Alpha architecture, could 
you please have a shot at this and implement the missing irqflags 
infrastructure? Thanks,

	Ingo
