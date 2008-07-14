Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYGNQeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYGNQeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYGNQeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:34:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35905 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYGNQeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:34:14 -0400
Date: Mon, 14 Jul 2008 18:34:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@qumranet.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
Message-ID: <20080714163402.GB21068@elte.hu>
References: <20080714144828.GA22666@elte.hu> <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org> <20080714151247.GA27145@elte.hu> <alpine.LFD.1.10.0807140856130.3305@woody.linux-foundation.org> <487B7A10.9050104@qumranet.com> <alpine.LFD.1.10.0807140917050.3305@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807140917050.3305@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 14 Jul 2008, Avi Kivity wrote:
> > 
> > We could add a printk to the #GP handler that alerts the reader that a
> > poisoned list is suspected, if we find the address pattern in one of the
> > registers.
> 
> I wouldn't worry too much - it's going to be pretty visible anyway.
> 
> The only thing I _would_ worry about is the AMD prefetch bug - some AMD 
> cores raise a spurious page fault for prefetch instructions, and we ignore 
> it.
> 
> I _think_ that bug is a pure TLB issue and would never trigger for an 
> address that doesn't do page fault handling at all because it gets caught 
> in the "is the address valid" code, but it does make me go "Hmm".
> 
> See
> 
> 	http://lkml.org/lkml/2003/9/10/397
> 
> from Rich Brunner. The AMD errata listing does say just page fault, 
> and does talk about speculative TLB reloads, so I think we're all 
> good.

one of my testboxes has this erratum and i saw related bugs in the past 
during stress-tests so it will show up if the non-canonical address 
causes any problems. So i think 0xdead000000000000 will be fine, and 
even if it isnt, we'll catch any problems fast enough.

	Ingo
