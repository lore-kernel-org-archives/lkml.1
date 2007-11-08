Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbXKHAyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbXKHAyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbXKHAym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:54:42 -0500
Received: from ns.suse.de ([195.135.220.2]:38574 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbXKHAym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:54:42 -0500
From: Andreas Schwab <schwab@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml@davidb.org, linux-kernel@vger.kernel.org, drepper@redhat.com,
       mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
References: <20071107224722.GA20204@old.davidb.org>
	<20071107152833.6f302c2a.akpm@linux-foundation.org>
	<20071107161853.044b6e8f.akpm@linux-foundation.org>
X-Yow: OKAY!!  Turn on the sound ONLY for TRYNEL CARPETING,
 FULLY-EQUIPPED R.V.'S and FLOATATION SYSTEMS!!
Date: Thu, 08 Nov 2007 01:54:40 +0100
In-Reply-To: <20071107161853.044b6e8f.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed\, 7 Nov 2007 16\:18\:53 -0800")
Message-ID: <je640dsgj3.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> diff -puN kernel/compat.c~a kernel/compat.c
> --- a/kernel/compat.c~a
> +++ a/kernel/compat.c
> @@ -162,7 +162,8 @@ asmlinkage long compat_sys_times(struct 
>  		if (copy_to_user(tbuf, &tmp, sizeof(tmp)))
>  			return -EFAULT;
>  	}
> -	return compat_jiffies_to_clock_t(jiffies);
> +	return compat_jiffies_to_clock_t((jiffies + INITIAL_JIFFIES) &
> +						LONG_MAX);

Are you sure you want LONG_MAX here, not 0x7fffffff?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
