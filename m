Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbZEVSgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbZEVSgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 14:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbZEVSgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 14:36:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52949 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbZEVSgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 14:36:36 -0400
Date: Fri, 22 May 2009 20:36:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Zick" <lkml@morethan.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090522183622.GA8385@elte.hu>
References: <200905221139.26941.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905221139.26941.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Michael S. Zick <lkml@morethan.org> wrote:

> Found in the bit-rot for 32-bit, x86, Uni-processor builds:
> 
> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
> index f6aa18e..3c790ef 100644
> --- a/arch/x86/include/asm/alternative.h
> +++ b/arch/x86/include/asm/alternative.h
> @@ -35,7 +35,7 @@
>                 "661:\n\tlock; "
> 
>  #else /* ! CONFIG_SMP */
> -#define LOCK_PREFIX ""
> +#define LOCK_PREFIX "\n\tlock; "
>  #endif

What is your motivation for this change? At first sight this makes 
the UP kernel a bit larger and a bit smaller. Are you fixing some 
real regression/bug here?

	Ingo
