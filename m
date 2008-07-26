Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYGZKPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYGZKPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 06:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYGZKPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 06:15:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38532 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYGZKPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 06:15:36 -0400
Date: Sat, 26 Jul 2008 12:15:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/24] x86/oprofile: Add CONFIG_OPROFILE_IBS option
Message-ID: <20080726101520.GJ25890@elte.hu>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-23-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216753748-11261-23-git-send-email-robert.richter@amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> +config OPROFILE_IBS
> +	bool "OProfile AMD IBS support (EXPERIMENTAL)"
> +	default n
> +	depends on OPROFILE && SMP && X86
> +	help
> +          Instruction-Based Sampling (IBS) is a new profiling
> +          technique that provides rich, precise program performance
> +          information. IBS is introduced by AMD Family10h processors
> +          (AMD Opteron Quad-Core processor ???Barcelona???) to overcome
> +          the limitations of conventional performance counter
> +          sampling.

weird UTF characters in the description - please try to use ASCII in 
such general Kconfig help-texts.

also, it would be nice to have a pure technical description. I.e. 
something like:

> +          Instruction-Based Sampling (IBS) is a new hardware feature
> +          that provides precise, non-statistical profiling 
> +          information. IBS is available in AMD Family10h processors.
> +          (AMD Barcelona).

> +#ifdef CONFIG_OPROFILE_IBS
>  	op_amd_handle_ibs(regs, msrs);
> +#endif

please hide #ifdefs by making the op_amd_handle_ibs() function general.

	Ingo
