Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbZBLOqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbZBLOqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbZBLOqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:46:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49920 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbZBLOqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:46:43 -0500
Date: Thu, 12 Feb 2009 15:46:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: [patch] rt: res_counter fix, v2
Message-ID: <20090212144624.GB14616@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere> <20090212101650.GA1096@elte.hu> <20090212102113.GA10031@elte.hu> <20090212142806.GA5865@nowhere> <1234449701.10603.10.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234449701.10603.10.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2009-02-12 at 15:28 +0100, Frederic Weisbecker wrote:
> > > [   45.228589] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
> > > [   45.228602] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
> > 
> > 
> > The reason for which I wanted to send an irqsoff trace is that the above lines are false.
> 
> copy_process() has:
> 
> #endif
> 	p->hardirq_enable_ip = 0;
> 	p->hardirq_enable_event = 0;
> 	p->hardirq_disable_ip = _THIS_IP_;
> 	p->hardirq_disable_event = 0;
> 	p->softirqs_enabled = 1;
> 	p->softirq_enable_ip = _THIS_IP_;
> 	p->softirq_enable_event = 0;
> 	p->softirq_disable_ip = 0;
> 	p->softirq_disable_event = 0;
> 	p->hardirq_context = 0;
> 	p->softirq_context = 0;
> #endif
> 
> the sequence count of 0 basically tells you it hasn't been set yet.

maybe we should initialize it to -1 to make this more apparent?

	Ingo
