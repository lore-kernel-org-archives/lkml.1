Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752459AbYLRKf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbYLRKf2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYLRKfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:35:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51942 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbYLRKfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:35:10 -0500
Date: Thu, 18 Dec 2008 11:34:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer
	interrupt infinite loop
Message-ID: <20081218103459.GD10513@elte.hu>
References: <4949A2CC.6040209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4949A2CC.6040209@gmail.com>
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

> Impact: fix a system hang on slow systems
> 
> While testing the function graph tracer on VirtualBox, I had a system hang
> immediatly after enabling the tracer.
>
> If hrtimer is enabled on kernel, a slow system can spend too much time 
> during tracing the hrtimer_interrupt which will do eternal loops, 
> assuming it always have to retry its process because too much time 
> elapsed during its time update. Now we provide a feature which lurks at 
> the number of retries on hrtimer_interrupt. After 10 retries, the 
> function graph tracer will definetly stop its tracing.

hm, i dont really like this solution - it just works around the problem by 
'speeding up' the system. If we have a _real_ slow system, there's no such 
way for us to speed it up.

Thomas, what do you think - would you expect this lockup to happen on 
really slow systems? If yes, is there a way we could avoid it from 
happening - by driving some sort of 'mandatory interval', that is doubled 
in size every time we detect such a bad hrtimer loop?

	Ingo
