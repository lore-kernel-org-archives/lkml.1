Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbZCJOg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbZCJOg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZCJOgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:36:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54611 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbZCJOgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:36:49 -0400
Date: Tue, 10 Mar 2009 15:35:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: prasad@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 04/11] Introduce virtual debug register in
	thread_struct and wrapper-routines around process related functions
Message-ID: <20090310143543.GE3850@elte.hu>
References: <20090305043440.189041194@linux.vnet.ibm.com> <20090305043830.GE17747@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305043830.GE17747@in.ibm.com>
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


* prasad@linux.vnet.ibm.com <prasad@linux.vnet.ibm.com> wrote:

> This patch introduces virtual debug registers to used by the 
> per-thread structure ad wrapper routines to manage debug 
> registers by process-related functions.

this is somewhat confusing. It would be much clearer to name it 
'user debug registers'.
  
and why is this:

> @@ -427,13 +427,9 @@ struct thread_struct {
>  	unsigned long		ip;
>  	unsigned long		fs;
>  	unsigned long		gs;
> -	/* Hardware debugging registers: */
> -	unsigned long		debugreg0;
> -	unsigned long		debugreg1;
> -	unsigned long		debugreg2;
> -	unsigned long		debugreg3;
> -	unsigned long		debugreg6;
> -	unsigned long		debugreg7;
> +	/* Hardware breakpoint info */
> +	unsigned long	vdr6;
> +	struct thread_hw_breakpoint	*hw_breakpoint_info;

detached from thread_struct? There's a lot of complications 
(alloc/free, locking, etc.) from this for no good reason - the 
hardware-breakpoints info structure is alway per thread and is 
quite small, so there's no reason not to embedd it directly 
inside thread_struct.

That way we get its allocation and freeing logic for free in 
essence.

	Ingo
