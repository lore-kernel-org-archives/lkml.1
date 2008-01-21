Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbYAUQlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbYAUQlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 11:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYAUQlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 11:41:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37737 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbYAUQlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 11:41:09 -0500
Date: Mon, 21 Jan 2008 17:40:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr
	patch series v3)
Message-ID: <20080121164052.GA11364@elte.hu>
References: <200801161114.239449000@suse.de> <200801181734.51193.ak@suse.de> <20080118164853.GA17589@elte.hu> <200801181819.58675.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801181819.58675.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <ak@suse.de> wrote:

> > i pointed it out how to port a larger series ontop of a whitespace 
> > cleanup patch:
> > 
> >  http://lkml.org/lkml/2008/1/18/281
> > 
> > the "there's an easy technique" bit.
> 
> But it will be even easier to just redo the cleanup stuff at the end. 
> If I do what you describe here I'm sure I will make a mistake 
> somewhere and I would rather not risk that.

FYI, i've done the proper splitup of your CPA patchset - see today's 
x86.git#mm for the details. I've extracted all the c_p_a() fixes from 
your series and eliminated the 'undo cleanups' patch as well.

It's a first shot so it might not yet be perfect - although so far it 
looks good in testing on 4-5 testsystems here, on mixed 64-bit and 
32-bit boxes. Doing it this way was a pretty straightforward process, it 
took less than an hour - and the end result feels much better in terms 
of maintainability.

I left the clflush feature bits out for now - fixes and cleanups go 
first. We first need to see whether this is robust enough before making 
other changes to c_p_a(). There's enough on the arch/x86 plate for 
v2.6.25 already - we can try the clflush optimizations in v2.6.26. 
(since there's no high-freq in-kernel user of the c_p_a() API at the 
moment, there's no pressing need for this either.)

Anyway, could you check today's x86.git and see whether any of those 
fixes have some implicit dependency on other changes i left out of this 
splitup? That's the main high-level risk i can see for now. (besides the 
large number of changes to this fragile API)

Also, CPA_DEBUG still produces warnings all around the place - as it did 
with your series.

	Ingo
