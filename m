Return-Path: <linux-kernel-owner+w=401wt.eu-S1751477AbZIWMgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbZIWMgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZIWMgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:36:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54497 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbZIWMgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:36:41 -0400
Date: Wed, 23 Sep 2009 14:36:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: Check NX state before setting up GDT mapping
Message-ID: <20090923123616.GC19385@elte.hu>
References: <4AB7EC1D.5010102@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB7EC1D.5010102@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1567]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 0dd0c2c..5d701bf 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1083,6 +1083,11 @@ asmlinkage void __init xen_start_kernel(void)
>  
>  	__supported_pte_mask |= _PAGE_IOMAP;
>  
> +#ifdef CONFIG_X86_64
> +	/* Work out if we support NX */
> +	check_efer();
> +#endif
> +

btw., this #ifdef could sure be eliminated, right?

	Ingo
