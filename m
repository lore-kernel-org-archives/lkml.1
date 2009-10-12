Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbZJLSAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbZJLSAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbZJLSAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:00:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40389 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907AbZJLSAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:00:07 -0400
Date: Mon, 12 Oct 2009 19:59:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86 UV: Fixes for UV rtc timers
Message-ID: <20091012175920.GB17138@elte.hu>
References: <20091009134727.GB3218@sgi.com> <20091012162317.GC1272@elte.hu> <20091012175233.GA8129@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012175233.GA8129@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> On Mon, Oct 12, 2009 at 06:23:17PM +0200, Ingo Molnar wrote:
> > hm, why is the (unnecessary seeming) pushing of the 
> > ack/exit_idle()/irq_enter()/irq_exit() sequence into the 
> > generic_interrupt_extension() function a cleanup?
> 
> It seems to make more sense to allow the users of generic_interrupt to 
> provide their own sequence, rather than being forced into this one.

An IRQ handler is an irq handler. We should make it _more_ generic, not 
less generic.

Also, the generic_interrupt_extension() name sucks a bit. Something like 
x86_platform_ipi_callback() would be better.

> > Also, the commit log is rather terse - what is being fixed and why isnt 
> > it separate from any cleanups?
> 
> I have added to the commit log.  See below.

Please separate out the fix and do the cleanups on top of that.

Thanks,

	Ingo
