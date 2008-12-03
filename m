Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYLCIMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYLCIMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 03:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYLCIMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 03:12:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56143 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbYLCIMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 03:12:12 -0500
Date: Wed, 3 Dec 2008 09:11:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/5] ftrace: print real return in dumpstack for
	function graph
Message-ID: <20081203081151.GE21006@elte.hu>
References: <20081203045001.367443457@goodmis.org> <20081203045043.769665847@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203045043.769665847@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> This does give a funny side effect in the stack tracer output:
> 
>         Depth   Size      Location    (80 entries)
>         -----   ----      --------
>   0)     4144      48   save_stack_trace+0x2f/0x4d
>   1)     4096     128   ftrace_call+0x5/0x2b
>   2)     3968      16   mempool_alloc_slab+0x16/0x18
>   3)     3952     384   return_to_handler+0x0/0x73
>   4)     3568    -240   stack_trace_call+0x11d/0x209
>   5)     3808     144   return_to_handler+0x0/0x73
>   6)     3664    -128   mempool_alloc+0x4d/0xfe
>   7)     3792     128   return_to_handler+0x0/0x73
>   8)     3664     -32   scsi_sg_alloc+0x48/0x4a [scsi_mod]
> 
> As you can see, the real functions are now negative. This is due
> to them not being found inside the stack.

Can we do something to output something less funny?

	Ingo
