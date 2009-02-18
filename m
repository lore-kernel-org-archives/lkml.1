Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbZBRTPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbZBRTPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbZBRTPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:15:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33507 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbZBRTPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:15:40 -0500
Date: Wed, 18 Feb 2009 20:15:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v2] module: fix build for CONFIG_SYSFS=n
Message-ID: <20090218191529.GC8889@elte.hu>
References: <20090218191640.0b023029.sfr@canb.auug.org.au> <499C4D35.9000104@oracle.com> <20090218180932.GC19995@elte.hu> <499C54E8.7060004@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499C54E8.7060004@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > Is destroy_params() dependent on SYSFS? If yes then it would be 
> 
> Yes.
> 
> > far cleaner if there was a NOP destroy_params() inline for the 
> > !SYSFS case.
> 
> 
> 
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix this build error when CONFIG_SYSFS=n:
> 
> kernel/built-in.o: In function `free_module':
> module.c:(.text+0x4f8a2): undefined reference to `destroy_params'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  kernel/params.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- linux-next-20090218.orig/kernel/params.c
> +++ linux-next-20090218/kernel/params.c
> @@ -761,6 +761,12 @@ static int __init param_sysfs_init(void)
>  }
>  subsys_initcall(param_sysfs_init);
>  
> +#else	/* !CONFIG_SYSFS */
> +
> +inline void destroy_params(const struct kernel_param *params, unsigned num)
> +{
> +}
> +
>  #endif /* CONFIG_SYSFS */

thanks!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
