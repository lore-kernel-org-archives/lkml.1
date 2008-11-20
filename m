Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYKTMDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYKTMDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 07:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYKTMDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 07:03:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53957 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbYKTMDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 07:03:24 -0500
Date: Thu, 20 Nov 2008 13:03:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28-rc5 04/11] kmemleak: Add modules support
Message-ID: <20081120120314.GC20724@elte.hu>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com> <20081120113050.16607.67335.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120113050.16607.67335.stgit@pc1117.cambridge.arm.com>
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


small nit:

> +#else
> +static inline void memleak_load_module(struct module *mod, Elf_Ehdr *hdr,
> +				       Elf_Shdr *sechdrs, char *secstrings)
> +{ }
> +#endif

this looks nicer:

static inline void
memleak_load_module(struct module *mod, Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
		    char *secstrings)
{
}

We dont use "{ }" in other places in the kernel, so lets not invent a 
new style if possible.

> +	/* the pointer to this block is stored in the module structure
> +	 * which is inside the block. Just mark it as not being a
> +	 * leak */

Comment style.

> +	/* the pointer to this block is stored in the module structure
> +	 * which is inside the block. This block doesn't need to be
> +	 * scanned as it contains data and code that will be freed
> +	 * after the module is initialized */

ditto.

Thanks,

	Ingo
