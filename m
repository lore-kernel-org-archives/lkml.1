Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbZEOOjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbZEOOjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZEOOj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:39:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37076 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZEOOj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:39:28 -0400
Date: Fri, 15 May 2009 16:39:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3 v2] perf_counter: allow arch to supply event misc
	flags and instruction pointer
Message-ID: <20090515143912.GA5478@elte.hu>
References: <18956.1272.818511.561835@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18956.1272.818511.561835@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul Mackerras <paulus@samba.org> wrote:

> At present the values we put in overflow events for the misc flags 
> indicating processor mode and the instruction pointer are obtained 
> using the standard user_mode() and instruction_pointer() 
> functions. Those functions tell you where the performance monitor 
> interrupt was taken, which might not be exactly where the counter 
> overflow occurred, for example because interrupts were disabled at 
> the point where the overflow occurred, or because the processor 
> had many instructions in flight and chose to complete some more 
> instructions beyond the one that caused the counter overflow.
> 
> Some architectures (e.g. powerpc) can supply more precise 
> information about where the counter overflow occurred and the 
> processor mode at that point.  This introduces new functions, 
> perf_misc_flags() and perf_instruction_pointer(), which arch code 
> can override to provide more precise information if available.  
> They have default implementations which are identical to the 
> existing code.
> 
> This also adds a new misc flag value, PERF_EVENT_MISC_HYPERVISOR, for
> the case where a counter overflow occurred in the hypervisor.  We
> encode the processor mode in the 2 bits previously used to indicate
> user or kernel mode; the values for user and kernel mode are unchanged
> and hypervisor mode is indicated by both bits being set.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> Patches 1/3 and 3/3 of this series are unchanged.  Ingo, do you need
> me to repost them?

no need, picked them all up, thanks Paul!

	Ingo
