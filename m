Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbZFMWGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbZFMWGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZFMWGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:06:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57793 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbZFMWGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:06:30 -0400
Date: Sat, 13 Jun 2009 21:40:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: [PATCH] Bring sparc64 dynamic ftrace up to snuff...
Message-ID: <20090613194027.GA25439@elte.hu>
References: <20090613.011020.214065340.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090613.011020.214065340.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0468]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

>  int ftrace_update_ftrace_func(ftrace_func_t func)
>  {
>  	unsigned long ip = (unsigned long)(&ftrace_call);
> -	unsigned char old[MCOUNT_INSN_SIZE], *new;
> +	u32 old, new;
>  
> -	memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
> +	old = *(u32 *) &ftrace_call;

btw., just one (really stupid) question here: can ftrace_call be 
misaligned, and is misalignment a problem on Sparc? If it's not a 
problem then disregard the rest of the mail.

I dont see a particular alignment done in mcount.S:

ftrace_caller:
        mov             %i7, %o1
        mov             %o7, %o0
        .globl          ftrace_call
ftrace_call:
        call            ftrace_stub

so replacing an memcpy (which can copy misaligned buffers) with a 
direct assignment (which cannot) - wont that cause misalignment on 
Sparc?

	Ingo
