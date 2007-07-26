Return-Path: <linux-kernel-owner+w=401wt.eu-S932759AbXGZHyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbXGZHyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 03:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbXGZHyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 03:54:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39825 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260AbXGZHyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 03:54:04 -0400
Date: Thu, 26 Jul 2007 09:53:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ankita Garg <ankita@in.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux@bohmer.net,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, mathieu.desnoyers@polymtl.ca
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
Message-ID: <20070726075353.GA19885@elte.hu>
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com> <1184615557.2698.3.camel@laptopd505.fenrus.org> <20070726072858.GC13061@in.ibm.com> <20070726073520.GA12206@elte.hu> <20070726074957.GA19398@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726074957.GA19398@in.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ankita Garg <ankita@in.ibm.com> wrote:

> > I'd suggest to not put a probe into a preempt-off section - put it 
> > to the beginning and to the end of schedule() to capture 
> > context-switches. _stp_print_flush() is in the systemtap-generated 
> > module, right? Maybe the problem is resolved by changing that 
> > spinlock to use raw_spinlock_t / DEFINE_RAW_SPIN_LOCK.
> 
> Yes, _stp_print_flush is in the systemtap-generated kprobe module. 
> Placing the probe at the beginning of schedule() also has the same 
> effect. Will try by changing the spinlock to raw_spinlock_t...

could you send us that module source ST generates? Perhaps there are 
preempt_disable() (or local_irq_disable()) calls in it too.

	Ingo
