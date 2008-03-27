Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbYC0Uzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbYC0Uzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 16:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbYC0Uzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 16:55:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758553AbYC0Uzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 16:55:42 -0400
Date: Thu, 27 Mar 2008 21:55:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080327205527.GA21912@elte.hu>
References: <20080327200309.GA18550@elte.hu> <alpine.LFD.1.00.0803271325430.14670@woody.linux-foundation.org> <1206650939.24940.43.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206650939.24940.43.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> -#ifdef CONFIG_X86_32
>  	/* Catch an obscure case of prefetch inside an NX page: */
> -	if ((__supported_pte_mask & _PAGE_NX) && (error_code & 16))
> -		return 0;
> -#endif
> -
> -	/* If it was a exec fault on NX page, ignore */
> -	if (error_code & PF_INSTR)
> +	if ((__supported_pte_mask & _PAGE_NX) && (error_code & PF_INSTR))
>  		return 0;

heh, did the exact same cleanup :)

i suspect we would be fine with a simple:

	if (error_code & PF_INSTR)
  		return 0;

because if we get a fault on an instruction fetch then it clearly cannot 
be a prefetch erratum ... The NX condition simply comes from a cautious 
32-bit workaround. (on 64-bit we always have NX - at least on AMD which 
has this erratum.)

and thus the currently pulled code is not incorrect, just ugly and 
nonsensical.

	Ingo
