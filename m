Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZA0NQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZA0NQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZA0NQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:16:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50046 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360AbZA0NQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:16:08 -0500
Date: Tue, 27 Jan 2009 14:15:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@redhat.com>,
       Tejun Heo <tj@kernel.org>, Kyle McMartin <kyle@infradead.org>,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] module: kzalloc mod->ref
Message-ID: <20090127131534.GG23121@elte.hu>
References: <20090114033533.GL25103@bombadil.infradead.org> <200901151521.47326.rusty@rustcorp.com.au> <200901261751.21817.rusty@rustcorp.com.au> <200901271206.51248.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901271206.51248.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> @@ -344,8 +339,11 @@ struct module
>  	/* Destruction function. */
>  	void (*exit)(void);
>  
> -	/* Reference counts */
> -	struct module_ref ref[NR_CPUS];
> +#ifdef CONFIG_SMP
> +	char *refptr;
> +#else
> +	local_t ref;
> +#endif

hm, that construct looks rather ugly. Is there no way to provide a clean 
data type and APIs for this that just work symmetrically on both SMP and 
UP?

	Ingo
