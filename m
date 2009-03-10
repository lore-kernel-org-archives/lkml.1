Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbZCJNrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbZCJNrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbZCJNrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:47:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42239 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbZCJNrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:47:08 -0400
Date: Tue, 10 Mar 2009 14:46:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: prasad@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090310134655.GA3850@elte.hu>
References: <20090305043726.GA17747@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305043726.GA17747@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* prasad@linux.vnet.ibm.com <prasad@linux.vnet.ibm.com> wrote:

> Hi Ingo,

> 	Please find the revised set of patches that implement 
> Hardware Breakpoint (or watchpoint) registers and an 
> arch-specific implementation for x86/x86_64.

General structure looks good, with a good deal of details 
that need to be addressed.

Firstly, as far as i can see this should work on 32-bit too, 
correct?

Secondly, what about other architectures - will they build just 
fine without any arch level glue code? kernel/hw_breakpoint.o 
get build unconditionally - without any benefit to non-x86 code. 
Perhaps an ARCH_HAS_HW_BREAKPOINTS Kconfig method would be 
useful to add.

There's also a number of (small) style issues. 
kernel/hw_breakpoint.c and other new .c files dont comply to the 
customary comment style of:

  /*
   * Comment .....
   * ...... goes here:
   */

also, the #include files section style should match that of 
arch/x86/mm/fault.c - it's a conflict-avoidance style.

also, things like this:

static struct notifier_block hw_breakpoint_exceptions_nb = {
        .notifier_call = hw_breakpoint_exceptions_notify,
        .priority = 0x7fffffff /* we need to be notified first */
};

should be:

static struct notifier_block hw_breakpoint_exceptions_nb = {
        .notifier_call		= hw_breakpoint_exceptions_notify,
	/* We need to be notified first: */
        .priority		= 0x7fffffff,
};

	Ingo
