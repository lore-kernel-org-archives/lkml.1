Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbXHFHOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbXHFHOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbXHFHNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:13:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58494 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXHFHNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:13:54 -0400
Date: Mon, 6 Aug 2007 09:13:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Beauchemin, Mark" <Mark.Beauchemin@sycamorenet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -rt] Preemption problem in kernel RT Patch
Message-ID: <20070806071345.GD5359@elte.hu>
References: <77B279EC7347F341A6AE891AA6AD68E93142D1@ranchero.sycamorenet.com> <77B279EC7347F341A6AE891AA6AD68E93142D2@ranchero.sycamorenet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77B279EC7347F341A6AE891AA6AD68E93142D2@ranchero.sycamorenet.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Beauchemin, Mark <Mark.Beauchemin@sycamorenet.com> wrote:

> sorry..  I sent the wrong patch file.  There was a warning in the 
> other one.

> -       int                     xmit_lock_owner;
> +#ifdef CONFIG_PREEMPT_RT
> +       void *                  xmit_lock_owner;
> +#else
> +       int                     xmit_lock_owner;
> +#endif

could you please change this to use 'current' (instead of the CPU 
number) as the xmit_lock_owner unconditionally? That results in much 
fewer #ifdefs and far cleaner code.

	Ingo
