Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYARJCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYARJCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYARJC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:02:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54238 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbYARJC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:02:27 -0500
Date: Fri, 18 Jan 2008 10:02:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: x86: kdump failure
Message-ID: <20080118090205.GA24337@elte.hu>
References: <478BB226.6090105@ct.jp.nec.com> <20080114190904.GA2288@elte.hu> <4790145C.9060102@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4790145C.9060102@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> kdump needs ELF_CORE_COPY_REGS in crash_save_cpu(). This lack of the 
> macro causes the following BUG.
> 
> SysRq : Trigger a crashdump
> ------------[ cut here ]------------
> kernel BUG at include/linux/elfcore.h:105!
> invalid opcode: 0000 [1] PREEMPT SMP

thanks, applied.

> +/*
> + * regs is struct pt_regs, pr_reg is elf_gregset_t (which is
> + * now struct_user_regs, they are different)
> + */
> +
> +#define ELF_CORE_COPY_REGS(pr_reg, regs) do {		\

this macro got removed by the regset patches. Roland, any ideas?

	Ingo
