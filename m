Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbYJCTng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbYJCTng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbYJCTmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:42:46 -0400
Received: from www.tglx.de ([62.245.132.106]:47765 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbYJCTmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:42:44 -0400
Date: Fri, 3 Oct 2008 21:41:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [regression] Latest git has WARN_ON storm with e1000e driver
In-Reply-To: <alpine.LFD.2.00.0810030901170.3185@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0810032139100.4573@apollo>
References: <200810031041.49350.borntraeger@de.ibm.com> <200810031720.53923.borntraeger@de.ibm.com> <alpine.LFD.2.00.0810030825190.3262@nehalem.linux-foundation.org> <200810031755.55931.borntraeger@de.ibm.com>
 <alpine.LFD.2.00.0810030901170.3185@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Linus Torvalds wrote:
> On Fri, 3 Oct 2008, Christian Borntraeger wrote:
> > 
> > kernel_init does lock_kernel (which does preempt_disable).
> > The kernel_unlock is done in init_post. As far as I can see, this happens 
> > after the driver init calls.
> 
> Yes. I just came to the same conclusion: preempt_count is 1 already in 
> do_one_initcall().
> 
> So this whole bug is actually because that debug test is just _broken_. It 
> shouldn't be WARN_ON(preempt_count()), it should be 'might_sleep()', which 
> does it right.
> 
> The right thing to check is "in_atomic() || irqs_disabled()".
> 
> Duh. That was wasted effort for a buggy test.

Stupid me. Yes I should have used might_sleep. It just did not trigger
here as I did not have the driver compiled into the kernel.

Sorry,

	tglx
