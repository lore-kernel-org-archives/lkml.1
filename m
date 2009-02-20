Return-Path: <linux-kernel-owner+w=401wt.eu-S1760541AbZBTRh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbZBTRh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760111AbZBTRfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:35:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42131 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbZBTRfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:35:14 -0500
Date: Fri, 20 Feb 2009 18:34:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5] ftrace, x86: do not depend on system state for
	kernel text info
Message-ID: <20090220173454.GK24538@elte.hu>
References: <20090220163846.709775139@goodmis.org> <20090220164046.528070886@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220164046.528070886@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Andrew Morton pointed out that using SYSTEM_STATE is a bad idea
> since there is no guarantee to what its state will actually be.
> 
> Instead, I moved the check into the set_kernel_text_* functions
> themselves, and use a local variable to determine when it is
> OK to change the kernel text RW permissions.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/x86/kernel/ftrace.c |    8 --------
>  arch/x86/mm/init_32.c    |   10 ++++++++++
>  arch/x86/mm/init_64.c    |   10 ++++++++++
>  3 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index c9ba2f9..025d783 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -28,20 +28,12 @@
>  
>  int ftrace_arch_modify_prepare(void)
>  {
> -	/* at boot up, we are still writable */
> -	if (system_state != SYSTEM_RUNNING)
> -		return 0;
> -

Since i suspect you'll rebase anyway, i'd suggest to squash this 
patch into patch #2, with credit to Andrew added.

	Ingo
