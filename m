Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbZCUPpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbZCUPpq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 11:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZCUPpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 11:45:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38182 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbZCUPpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 11:45:35 -0400
Date: Sat, 21 Mar 2009 16:45:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090321154501.GA2707@elte.hu>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014244.9ADF1FC3AB@magilla.sf.frob.com> <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321050422.d1d99eec.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> [...]  Let's fix systemtap?

Yes, it needs to be fixed.

The main issue i see is that no kernel developer i work with on a 
daily basis uses SystemTap - and i work with a lot of people. Yes, i 
could perhaps name two or three people from lkml using it, but its 
average penetration amongst kernel folks is essentially zero.

Was any critical analysis done why that penetration is so absymally 
low for a tool with such a promise and with years of availability, 
and what are the measures planned to address those problems?

To me personally there are two big direct usability issues with 
SystemTap:

 1) It relies on DEBUG_INFO for any reasonable level of utility.
    Yes, it will limp along otherwise as well, but most of the
    actual novel capabilities depend on debuginfo. Which is an
    acceptable constraint for enterprise usage where kernels are
    switched every few months and having a debuginfo package is not
    a big issue. Not acceptable for upstream kernel development. It 
    also puts way too trust into the compiler generating 1GB+ of 
    debuginfo correctly. I want to be able to rely on tools all the 
    time and thus i want tools to have some really simple and 
    predictable foundations.

 2) It's not upstream and folks using it seem to insist on not 
    having it upstream ;-) This 'distance' to upstream seems to have 
    grown during the past few years - instead of shrinking. As a 
    result it simply does not matter and there's no know-how and no 
    visibility of it upstream.

If these fundamental problems are addressed then i'd even argue for 
the totality of SystemTap to be aimed upstreamed (including the 
scripting language, etc.), because for something this fundamental 
there's just no good reason not to have a turn-key solution there.

Plus then there should be a (steadily growing) library of utility 
scripts in the kernel proper as well.

Anything less does not make much sense IMO. Having a separate tool 
will reduce efficiency, increases the latency of fixes and 
enhancements and creates ABI-like expectations - which are all 
counter-productive to good instrumentation.

These are the aspects of SystemTap that i have to say were never 
done right, and these are the aspects of SystemTap that need to 
change most. Putting utrace upstream now will just make it more 
convenient to have SystemTap as a separate entity - without any of 
the benefits. Do we want to do that? Maybe, but we could do better i 
think.

	Ingo
