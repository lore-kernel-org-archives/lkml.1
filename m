Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYCUPIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYCUPIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbYCUPI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:08:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37434 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbYCUPI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:08:27 -0400
Date: Fri, 21 Mar 2008 16:07:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Richard Henderson <rth@twiddle.net>, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 6/8] ptrace: arch_ptrace -ENOSYS return
Message-ID: <20080321150734.GD1545@elte.hu>
References: <20080319211714.8B14226F995@magilla.localdomain> <20080319212024.EA03126F995@magilla.localdomain> <alpine.LFD.1.00.0803191935080.3020@woody.linux-foundation.org> <20080320081658.0B23826F995@magilla.localdomain> <alpine.LFD.1.00.0803210744470.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803210744470.3020@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > The reason I took the approach I did instead is incrementalism. I 
> > can't change that signature without breaking about 22 arch builds.
> 
> Don't worry about the arch builds. If that's your main worry and 
> reason for this, it's not worth it. Yes, ptrace changes, and yes, we 
> may have arch issues, but no, it's not that big of a deal. Just break 
> them.
> 
> Make sure x86[-64] works, and make sure that other architectures *can* 
> work (and explain it on linux-arch) when you have to fix something up, 
> but ptrace is a blip on the radar for people, it's not going to be a 
> huge issue.

for a long time all the nice but intrusive utrace improvements from 
Roland had this big adoption barrier. So Roland went around that and 
with a lot of effort he made it optional, incremental and per arch, so 
that we could try it on x86 and merge it upstream.

Now that we see how cleaner it is and that it actually was an almost 
regression-free endevour on x86 (we had 2 regressions so far, both fixed 
- which is an amazing feat for such wide changes IMO), i very much agree 
that we should just do the "rest" of this in one big step.

it's a bit of a chicken & egg problem for such changes. If it breaks 
architectures it gets dropped out of -mm - even though 90% of our 
developers, 95% of our testers and 99% of our active users are using x86 
only.

but in general, prototyping something on a single architecture in the 
first step is OK - and maybe even the first merge is OK. But once it has 
been proven on the most tested Linux platform that we have (and there's 
no blatant x86-ism in it), there's no reason not to mandate it.

	Ingo
