Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbXGHJ64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbXGHJ64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 05:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbXGHJ6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 05:58:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39998 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbXGHJ6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 05:58:48 -0400
Date: Sun, 8 Jul 2007 11:58:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux@bohmer.net
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: PI mutex support on ARM
Message-ID: <20070708095841.GA4601@elte.hu>
References: <3efb10970707080124i7a9323c5o9257b4adcb2ac493@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3efb10970707080124i7a9323c5o9257b4adcb2ac493@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Remy Bohmer <l.pinguin@gmail.com> wrote:

> --- linux-2.6.21.orig/include/asm/futex.h	2007-04-26 05:08:32.000000000 +0200

patch format problem: never diff the asm/ files, diff the asm-arm/ 
files.

> +	local_irq_save(flags);
> +
> +	err = get_user(uval, uaddr);

is it safe to do a get_user() with irqs off?

> +	if (err)
> +	{
> +		local_irq_restore(flags);
> +		 return -EFAULT;
> +	}

(style problems. Use scripts/checkpatch.pl to verify your patches.)

> +	local_irq_restore(flags);

is this method of atomic ops SMP-safe?

	Ingo
