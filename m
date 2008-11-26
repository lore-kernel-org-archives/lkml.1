Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbYKZOMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYKZOMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYKZOMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:12:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54616 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbYKZOMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:12:06 -0500
Date: Wed, 26 Nov 2008 15:11:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: Re: [patch 20/24] perfmon: system calls interface
Message-ID: <20081126141144.GF6562@elte.hu>
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
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


* eranian@googlemail.com <eranian@googlemail.com> wrote:

> +/*
> + * unlike the other perfmon system calls, this one returns a file descriptor
> + * or a value < 0 in case of error, very much like open() or socket()
> + */
> +asmlinkage long sys_pfm_create(int flags, struct pfarg_sinfo __user *ureq)
> +{
> +	struct pfm_context *new_ctx;
> +	struct pfarg_sinfo sif;
> +	int ret;
> +
> +	PFM_DBG("flags=0x%x sif=%p", flags, ureq);
> +
> +	if (perfmon_disabled)
> +		return -ENOSYS;

another gem. we check flags:

> +	if (flags) {
> +		PFM_DBG("no flags accepted yet");
> +		return -EINVAL;
> +	}

then we pass them into __pfm_create_context():

> +	ret = __pfm_create_context(flags, &sif, &new_ctx);

where we check the flag _again_:

+       /* no context flags supported yet */
+       if (ctx_flags)
+               goto error_alloc;

btw., 'error_alloc' is misnamed: that label is not used for allocation 
failure in this branch.

	Ingo
