Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbYKLLaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbYKLLaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 06:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYKLL3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 06:29:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49231 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbYKLL3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:29:54 -0500
Date: Wed, 12 Nov 2008 12:29:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: ia32_signal: remove unnecessary padding
Message-ID: <20081112112937.GA6372@elte.hu>
References: <491A48E9.8020909@ct.jp.nec.com> <491A496B.5010505@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491A496B.5010505@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: cleanup
> 
> Remove unnecessary paddings, this saves 4 bytes.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/ia32/ia32_signal.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)

applied your patches to tip/x86/signal:

 9cc3c49: x86: ia32_signal: remove unnecessary padding
 4a61204: x86: signal_32: introduce retcode and rt_retcode

thanks!

A question - this change:

> @@ -427,12 +427,10 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
>  		u16 poplmovl;
>  		u32 val;
>  		u16 int80;
> -		u16 pad;
>  	} __attribute__((packed)) code = {
>  		0xb858,		 /* popl %eax ; movl $...,%eax */
>  		__NR_ia32_sigreturn,
>  		0x80cd,		/* int $0x80 */
> -		0,
>  	};
>  
>  	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
> @@ -508,8 +506,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
>  		u8 movl;
>  		u32 val;
>  		u16 int80;
> -		u16 pad;
> -		u8  pad2;
> +		u8  pad;
>  	} __attribute__((packed)) code = {
>  		0xb8,
>  		__NR_ia32_rt_sigreturn,

does not impact any ABI, because it's only about the signal trampoline 
the kernel pushes to the user-space stack - not about any 
userspace-visible signal frame detail, right?

	Ingo
