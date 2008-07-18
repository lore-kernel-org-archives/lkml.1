Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYGRIIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYGRIIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYGRIIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:08:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46428 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbYGRIIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:08:07 -0400
Date: Fri, 18 Jul 2008 10:07:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] tracehook
Message-ID: <20080718080751.GG6875@elte.hu>
References: <20080717072541.F390E15411D@magilla.localdomain> <20080717015105.f919f615.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717015105.f919f615.akpm@linux-foundation.org>
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

> On Thu, 17 Jul 2008 00:25:41 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:
> 
> > This patch series introduces the "tracehook" interface layer of 
> > inlines in <linux/tracehook.h>.
> 
> Looks sane to me from a quick scan.

same here.

Reviewed-by: Ingo Molnar <mingo@elte.hu>

> A ~200 byte increase in i386 allnoconfig .text is liveable with.  But 
> nothing defines CONFIG_HAVE_ARCH_TRACEHOOK yet.  What effect will that 
> have?

this is the second subtle step towards utrace and 
next-gen-instrumentation. (regset was the first, by far most risky step)

> I don't like the name!  We have ftrace and we have static tracepoints 
> and we have dynamic tracepoints and we have linux trace toolkit and 
> whatever is in kernel/trace/trace.c etc, etc.  Now this work comes 
> along with _userspace_ tracing capabilities and it goes and calls it, 
> of all things, "trace"!

> Apart from that, I think the other big issue with this patchset is 
> that it doesn't do anything yet.  It's effectively a blank cheque.  
> There's not a lot of point in merging all this work unless we also 
> merge something which uses it (is this correct?).  And afacit the 
> thing which will use it is utrace and utrace hasn't been sighted for a 
> year or more and it has met objections.
> 
> If we merge this and then utrace crashes on a rocky shore then there 
> was no (or little) point in having merged this.
> 
> Or am I wrong about that?  Does it have sufficient standalone value to 
> justify a standalone merge (yet alone to justify such a late merge)?

It has enough standalone value to me - it generally cleans up all things 
"abstract kernel events", collects them into a single entity and lets 
tracers interact with the kernel (not just passively observe its 
events). So it's good for next-gen debuggers too, etc.

And task_current_syscall() avoids us hundreds of crappy hooks in every 
syscall handler and gives us in-kernel strace in essence. (it's not just 
useful to sample blocked threads - it could also be used by ftrace&co to 
sample the currently executing task) That alone makes it worth it IMO 
;-)

also in places it cleans up current special-case-for-ptrace code and 
makes it shorter - like in kernel/exit.c. Well thought out scheme and 
structure - as we've come to expect from Roland.

	Ingo
