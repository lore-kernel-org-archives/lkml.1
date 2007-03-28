Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbXC1KHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbXC1KHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 06:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbXC1KHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 06:07:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:37054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbXC1KHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 06:07:51 -0400
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       davej@codemonkey.org.uk, johnstul@us.ibm.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] Add support for deferrable timers (respun)
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net>
	<20070322140532.GA120@tv-sign.ru>
	<20070322151817.GA29840@linux-os.sc.intel.com>
	<20070322161355.GA160@tv-sign.ru>
	<20070327204344.GA21529@linux-os.sc.intel.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 28 Mar 2007 13:06:35 +0200
In-Reply-To: <20070327204344.GA21529@linux-os.sc.intel.com>
Message-ID: <p734po54og4.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi <venkatesh.pallipadi@intel.com> writes:
> +++ new/kernel/timer.c	2007-03-26 15:19:35.000000000 -0800
> @@ -74,7 +74,7 @@
>  	tvec_t tv3;
>  	tvec_t tv4;
>  	tvec_t tv5;
> -} ____cacheline_aligned_in_smp;
> +} ____cacheline_aligned;

Why this change?  It should be aligned to 2 bytes anyways.

>  static DEFINE_PER_CPU(tvec_base_t *, tvec_bases) = &boot_tvec_bases;
>  
> +/*
> + * The lowest bit of base ptr in timer is used as a flag to indicate
> + * 'deferrable' nature of the timer. Functions below help us manage that flag.
> + */
> +static inline unsigned int tbase_get_deferrable(struct tvec_t_base_s *base)
> +{
> +	return ((unsigned int)base & TBASE_DEFERRABLE_FLAG);

This will warn on 64bit for cast ptr -> int


-Andi
