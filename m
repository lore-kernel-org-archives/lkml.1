Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbYLPRSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbYLPRSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYLPRSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:18:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59332 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYLPRSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:18:13 -0500
Date: Tue, 16 Dec 2008 18:18:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com
Subject: Re: [patch 1/3] x86, bts: clear bts bits on fork
Message-ID: <20081216171801.GA11683@elte.hu>
References: <20081216154842.A29980@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216154842.A29980@sedona.ch.intel.com>
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


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> -#ifdef CONFIG_X86_DS
> +#ifdef CONFIG_X86_PTRACE_BTS
>  	/* Free any BTS tracers that have not been properly released. */
>  	if (unlikely(current->bts)) {
>  		ds_release_bts(current->bts);
> @@ -258,7 +258,7 @@
>  		current->bts_buffer = NULL;
>  		current->bts_size = 0;
>  	}
> -#endif /* CONFIG_X86_DS */

Please eliminate the #ifdef from here by introducing a helper function - 
possibly inlined.

> +#ifdef CONFIG_X86_DS
> +	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
> +	p->thread.ds_ctx = NULL;
> +#endif
> +#ifdef CONFIG_X86_PTRACE_BTS
> +	p->thread.bts_ovfl_signal = 0;
> +#endif

ditto.

> +#ifdef CONFIG_X86_PTRACE_BTS
> +	p->bts = NULL;
> +	p->bts_buffer = NULL;
> +	p->bts_size = 0;
> +#endif

this one too please.

There's generally little reason to put #ifdefs into .c files.

	Ingo
