Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbXEPWFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbXEPWFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbXEPWFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:05:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46026 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbXEPWFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:05:34 -0400
Date: Thu, 17 May 2007 00:04:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: v2.6.21-rt2
Message-ID: <20070516220444.GA27081@elte.hu>
References: <20070516180447.GA17922@elte.hu> <1179348842.20519.20.camel@imap.mvista.com> <20070516210104.GA17240@elte.hu> <1179350448.20519.25.camel@imap.mvista.com> <20070516213259.GC19850@elte.hu> <1179352036.20519.36.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179352036.20519.36.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> I don't know. irqs_off_preempt_count() could get used someplace else, 
> where you would want to flip the preempt_count() check .. It seems 
> sane to combine your patch with mine ..
> 
> irqs_off_preempt_count() (!__get_cpu_var(trace_cpu_idle) && 
> preempt_count())
> 
> You can't call __get_cpu_var() without the a positive preempt_count(), 
> so the check seems backwards regardless of the other factors ..

yeah. The whole trace_preempt_enter_idle() thing looks a bit suspect. 
Why cannot those architectures simply disable/enable preemption and get 
the same effect? It's not like we ever want to allow the preemption of 
the idle task.

and once that is solved, irqs_off_preempt_count() can again include the 
hardirq and preempt count check only and doesnt have to check the 
idle_cpu flag. This would make the whole thing simpler and would avoid 
silly bugs like this.

	Ingo
