Return-Path: <linux-kernel-owner+w=401wt.eu-S1751634AbZJWIBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbZJWIBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 04:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZJWIBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 04:01:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53199 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbZJWIBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 04:01:53 -0400
Date: Fri, 23 Oct 2009 10:01:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] X86: Suppress hundreds of Intel thermal MCE messages
	on high temps
Message-ID: <20091023080153.GD10067@elte.hu>
References: <200910230200.37267.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910230200.37267.trenn@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Renninger <trenn@suse.de> wrote:

> This is against 2.6.31, but it should still patch, tell me if not. 
> Should this also go to stable@kernel.org?
> 
> Thanks,
> 
>        Thomas
> 
> ---------
> This (introduced by Ingo some time ago):
>    if (!(was_throttled ^ is_throttled) &&
>         time_before64(tmp_jiffs, __get_cpu_var(next_check)))
> does not help much.
> The interrupts happening and the read out MSR seem to tell that
> the CPU gets throttled and unthrottled all the time.
> Thus current implementation results in hundreds (thousands?) of "above threshold"
> messages per minute.
> 
> This patch is more or less a revert back to the implementation in
> older kernels.
> The message:
>     printk(KERN_INFO "CPU%d: Temperature/speed normal\n", cpu);
> is not needed as it is suppressed anyway.
> 
> Reference of an affected Core 2 and a Celeron machine:
> http://bugzilla.novell.com/show_bug.cgi?id=533556
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>

Have you seen these upstream commits:

 b417c9f: x86: mce: Fix thermal throttling message storm
 3967684: x86: mce: Clean up thermal throttling state tracking code

?

If they solve the problem for you then please forward them to 
stable@kernel.org.

Thanks,

	Ingo
