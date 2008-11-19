Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbYKSIBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbYKSIBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYKSIBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:01:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41432 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbYKSIBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:01:36 -0500
Date: Wed, 19 Nov 2008 09:01:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] ftrace updates to tip/core/urgent
Message-ID: <20081119080124.GB1078@elte.hu>
References: <20081119053449.282336740@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119053449.282336740@goodmis.org>
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

> Ingo,
> 
> I ported the following patches to tip/core/urgent since they are 
> candidates for 2.6.28.
> 
> The first two are trivial, short, and should not be an issue. The 
> first two handle the printing of the set_ftrace_filter file 
> correctly.
> 
> The third is a bigger patch "108 lines changed" and is actually a 
> clean up and fix.  The difference is that the current logic to 
> determine if a function should be enabled or not is incorrect. With 
> different combinations of using set_ftrace_filter and 
> set_ftrace_notrace, incorrect functions may be traced, or not 
> traced.
> 
> But this bug that the patch fixes is not a critical bug. It should 
> not cause any stability problems with the kernel. The bug will only 
> produce undesirable traces.
> 
> But on the other hand, adding that last patch should not cause any 
> stability issues as well. And it makes the complex function cleaner 
> and more importantly, by coupling the ENABLED flag of the record 
> with the enabling (or disabling) of the tracing of the function the 
> record represents, makes the code more robust.

ok, agreed.

> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>       branch: tip/urgent
> 
> 
> Steven Rostedt (3):
>       ftrace: fix set_ftrace_filter
>       ftrace: make filtered functions effective on setting
>       ftrace: fix dyn ftrace filter selection
> 
> ----
>  kernel/trace/ftrace.c |  113 +++++++++++++++++++++++-------------------------
>  1 files changed, 54 insertions(+), 59 deletions(-)

pulled into tip/tracing/urgent, thanks Steve!

	Ingo
