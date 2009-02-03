Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbZBCMKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbZBCMKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZBCMKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:10:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49763 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZBCMKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:10:07 -0500
Date: Tue, 3 Feb 2009 13:09:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Message-ID: <20090203120925.GA19979@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain> <1233614927.18767.121.camel@pasglop> <200902030000.18049.rjw@sisk.pl> <1233620590.18767.138.camel@pasglop> <alpine.LFD.2.00.0902021635240.3247@localhost.localdomain> <20090203050648.GA14076@elte.hu> <1233659215.10184.19.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233659215.10184.19.camel@laptop>
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

> On Tue, 2009-02-03 at 06:06 +0100, Ingo Molnar wrote:
> > 
> > Mutexes should work just fine in irqs-off sections - they'll safely 
> > save/restore interrupts, even the debug variants.
> 
> mutex_lock() has might_sleep() which will generate a splat in atomic
> contexts.
> 
> That said, afaik the acpi code uses semaphores.

even the might_sleep() should be OK with Linus's system_state change to the 
suspend code:

void __might_sleep(char *file, int line)
{
#ifdef in_atomic
        static unsigned long prev_jiffy;        /* ratelimiting */

        if ((!in_atomic() && !irqs_disabled()) ||
                    system_state != SYSTEM_RUNNING || oops_in_progress)

	Ingo
