Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbZCDRwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbZCDRwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZCDRv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:51:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44160 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbZCDRv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:51:56 -0500
Date: Wed, 4 Mar 2009 18:51:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, x86@kernel.org,
       Bill Metzenthen <billm@melbpc.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, math-emu: fix init_fpu for task != current
Message-ID: <20090304175122.GA29823@elte.hu>
References: <E1Le9vp-00020J-AA@mailer.emlix.com> <20090302195230.GA12252@elte.hu> <E1LetWv-0002Kq-Sq@mailer.emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1LetWv-0002Kq-Sq@mailer.emlix.com>
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


* Daniel Glöckner <dg@emlix.com> wrote:

> On 03/02/2009 08:52 PM, Ingo Molnar wrote:
> > * Daniel Glöckner <dg@emlix.com> wrote:
> [..]
> >> This patch creates a new function finit_task that takes a task_struct
> >> parameter. finit becomes a wrapper that simply calls finit_task with
> >> current. On the plus side this avoids many calls to get_current which
> >> would each resolve to an inline assembler mov instruction.
> [..]
> >> --- a/arch/x86/kernel/i387.c
> >> +++ b/arch/x86/kernel/i387.c
> >> @@ -136,7 +136,7 @@ int init_fpu(struct task_struct *tsk)
> >>  #ifdef CONFIG_X86_32
> >>  	if (!HAVE_HWFP) {
> >>  		memset(tsk->thread.xstate, 0, xstate_size);
> >> -		finit();
> >> +		finit_task(tsk);
> >>  		set_stopped_child_used_math(tsk);
> >>  		return 0;
> >>  	}
> [..]
> > 
> > ok, the fix looks good - but we sure want to define this 
> > function in the "# CONFIG_MATH_EMU is not set" case too, agreed?
> 
> To avoid linker errors if the compiler emits the call although 
> !HAVE_HWFP is always false? Sounds plausible. I also removed 
> finit from i387.h as the only other external call site, 
> reg_ld_str.c, gets its prototype from fpu_proto.h.

Could you please send a single combo patch with a full 
changelog, etc.

Thanks,

	Ingo
