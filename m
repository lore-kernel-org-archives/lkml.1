Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYKCJmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYKCJmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 04:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbYKCJmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 04:42:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50456 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbYKCJma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 04:42:30 -0500
Date: Mon, 3 Nov 2008 10:41:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Abhishek Sagar <sagar.abhishek@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       ananth@in.ibm.com, jkenisto@us.ibm.com, mhiramat@redhat.com
Subject: Re: [PATCH] ftrace: use kretprobe trampoline name to test in output
Message-ID: <20081103094159.GA10400@elte.hu>
References: <483C53EE.2060602@gmail.com> <alpine.DEB.1.10.0810302227360.21031@gandalf.stny.rr.com> <alpine.DEB.1.10.0810311036130.20157@gandalf.stny.rr.com> <863e9df20810310832uadf4daay7b5a98b677d86561@mail.gmail.com> <alpine.DEB.1.10.0810311142220.22451@gandalf.stny.rr.com> <863e9df20810311233j13f996b8qa185cceddbd90849@mail.gmail.com> <alpine.DEB.1.10.0810311541280.28774@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810311541280.28774@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> [
>   Ingo,
> 
>   Can you get this ready for 2.6.28. Without this fix, tracing
>   breaks the ia64 build.
> ]
> 
> When a function is kprobed, the return address is set to the
> kprobe_trampoline, or something similar. This caused the output
> of the trace to look confusing when the parent seemed to be this
> "kprobe_trampoline" function.
> 
> To fix this, Abhishek Sagar added a test of the instruction pointer
> of the parent to see if it matched the kprobe_trampoline. If it
> did, the output would print a "[unknown/kretprobe'd]" instead.
> 
> Unfortunately, not all archs do this the same way, and the trampoline
> function may not be exported, which causes failures in builds.
> 
> This patch will compare the name instead of the pointer to see
> if it matches. This prevents us from depending on a function from
> being exported, and should work on all archs. The worst that can
> happen is that an arch might use a different name and then we
> go back to the confusing output. At least the arch will still build.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> Tested-by: Abhishek Sagar <sagar.abhishek@gmail.com>
> Acked-by: Abhishek Sagar <sagar.abhishek@gmail.com>
> ---
>  kernel/trace/trace.c |   39 +++++++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 18 deletions(-)

applied to tip/tracing/urgent, thanks!

	Ingo
