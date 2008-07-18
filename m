Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbYGRRWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbYGRRWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbYGRRWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:22:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47190 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937AbYGRRWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:22:41 -0400
Date: Fri, 18 Jul 2008 19:22:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Thomas Gleixner <tglx@linutronix.de> Gleixner" <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable polling for disabled screaming irqs
Message-ID: <20080718172231.GM6875@elte.hu>
References: <m13amho1fd.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13amho1fd.fsf@frodo.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> When we disable a screaming irq we never see it again.  If the irq 
> line is shared or if the driver half works this is a real pain.  So 
> periodically poll the handlers for screaming interrupts.
> 
> I use a timer instead of the classic irq poll technique of working off 
> the timer interrupt because when we use the local apic timers 
> note_interrupt is never called (bug?).  Further on a system with 
> dynamic ticks the timer interrupt might not even fire unless there is 
> a timer telling it it needs to.
> 
> I forced this case on my test system with an e1000 nic and my ssh 
> session remained responsive despite the interrupt handler only being 
> called every 10th of a second.

very nice idea!

I have applied your patch to tip/genirq, thanks Eric. We need more 
kernel robustness features like this.

	Ingo
