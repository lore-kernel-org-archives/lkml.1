Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbZIWHdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbZIWHdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbZIWHdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:33:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33699 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbZIWHdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:33:05 -0400
Date: Wed, 23 Sep 2009 09:32:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Malley <mail@chrismalley.co.uk>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf sched record hangs machine
Message-ID: <20090923073253.GA18022@elte.hu>
References: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com> <20090922212453.GB6062@nowhere> <1253686585.7695.84.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253686585.7695.84.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

>         .size   default_send_IPI_self, .-default_send_IPI_self
> 
> Which seems to suggest that cmove is in __prepare_ICR, but I'm not 
> sure how that can cause a page-fault, as that function is rather 
> pointer-less.
> 
> Did it maybe delay evaluating apic->dest_logical that late, it appear 
> to be the first usage of that argument?
> 
> Ingo, any ideas?

Yeah, the problem is:

[    0.042445] Local APIC not detected. Using dummy APIC emulation.

we shouldnt be trying to program the lapic in that case - all ops should 
be a NOP, including send-ipi-self. Cyrill?

	Ingo
