Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYKUIYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYKUIYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYKUIYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:24:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51233 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYKUIYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:24:09 -0500
Date: Fri, 21 Nov 2008 09:23:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, cpufreq@vger.kernel.org,
       stable@kernel.org, "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] x86: powernow-k8: ignore out-of-range PstateStatus
	value
Message-ID: <20081121082346.GK16242@elte.hu>
References: <20081107150811.GI15390@alberich.amd.com> <20081121080841.GD10940@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121080841.GD10940@alberich.amd.com>
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


nice fix! A few minor nits:

> +			/* a workaround for family 11h erratum 311 might cause
> +			   an "out-of-range Pstate if the core is in Pstate-0 */

Please use the customary comment style:

  /*
   * Comment .....
   * ...... goes here:
   */

and since it's multi-line anyway, keep to the 80-col limit too please.

> diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
> index ab48cfe..4078f5d 100644
> --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
> +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
> @@ -23,7 +23,9 @@ struct powernow_k8_data {
>          u32 exttype; /* extended interface = 1 */
>  
>  	/* keep track of the current fid / vid or pstate */
> -	u32 currvid, currfid, currpstate;
> +	u32 currvid, currfid;
> +	u32 currpstate;

Any reason why it has been moved to a separate line? (either split all 
fields or keep them all together)

> +#define INVALID_HW_PSTATE 0xff

Please use an enum, not a define in the middle of a struct.

Thanks,

        Ingo
