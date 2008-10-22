Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYJVG2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYJVG2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 02:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbYJVG20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 02:28:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48038 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbYJVG2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:28:25 -0400
Date: Wed, 22 Oct 2008 08:28:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, npiggin@suse.de, jdike@addtoit.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: + mm-invoke-oom-killer-from-page-fault.patch added to -mm tree
Message-ID: <20081022062802.GF651@elte.hu>
References: <200810212140.m9LLeq1B026364@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810212140.m9LLeq1B026364@imap1.linux-foundation.org>
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


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      mm: invoke oom-killer from page fault
> has been added to the -mm tree.  Its filename is
>      mm-invoke-oom-killer-from-page-fault.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: mm: invoke oom-killer from page fault
> From: Nick Piggin <npiggin@suse.de>
> 
> Rather than have the pagefault handler kill a process directly if it gets
> a VM_FAULT_OOM, have it call into the OOM killer.
> 
> With increasingly sophisticated oom behaviour (cpusets, memory cgroups,
> oom killing throttling, oom priority adjustment or selective disabling,
> panic on oom, etc), it's silly to unconditionally kill the faulting
> process at page fault time.  Create a hook for pagefault oom path to call
> into instead.
> 
> Only converted x86 and uml so far.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

the x86 bits look sane in principle. Needs a lot of testing obviously.

Acked-by: Ingo Molnar <mingo@elte.hu>

a small nit:

> +	/*
> +	 * Give "p" a good chance of killing itself before we
> +	 * retry to allocate memory unless "p" is current
> +	 */
> +	if (!test_thread_flag(TIF_MEMDIE))
> +		schedule_timeout_uninterruptible(1);

comment does not match up the code anymore, we only deal with 'current' 
here.

	Ingo
