Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbYJAHLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYJAHLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYJAHLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:11:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41856 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYJAHLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:11:46 -0400
Date: Wed, 1 Oct 2008 09:11:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: do not allow to optimize flag_is_changeable_p()
	(rev. 2)
Message-ID: <20081001071138.GB9366@elte.hu>
References: <20080930231751.58db0fff.krzysztof.h1@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930231751.58db0fff.krzysztof.h1@wp.pl>
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


* Krzysztof Helt <krzysztof.h1@wp.pl> wrote:

> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> The flag_is_changeable_p() is used by
> has_cpuid_p() which can return different results
> in the code sequence below:
> 
>  if (!have_cpuid_p())
>       identify_cpu_without_cpuid(c);
> 
>   /* cyrix could have cpuid enabled via c_identify()*/
>   if (!have_cpuid_p())
>       return;
> 
> Otherwise, the gcc 3.4.6 optimizes these two calls
> into one which make the code not working correctly.
> 
> Cyrix cpus have the CPUID instruction enabled before
> the second call to the have_cpuid_p() but
> it is not detected due to the gcc optimization.
> Thus the ARR registers (mtrr like) are not detected
> on such a cpu.
> 
> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>

applied to tip/x86/core, thanks Krzysztof!

	Ingo
