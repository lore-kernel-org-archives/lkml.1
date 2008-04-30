Return-Path: <linux-kernel-owner+w=401wt.eu-S1763602AbYD3SOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763602AbYD3SOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758495AbYD3SOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:14:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46024 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbYD3SOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:14:23 -0400
Date: Wed, 30 Apr 2008 20:13:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
       Glauber Costa <gcosta@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Problems with -git14
Message-ID: <20080430181332.GC31726@elte.hu>
References: <20080430015655.5a42f63d@werewolf.home> <Pine.LNX.4.64.0804301516580.30549@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804301516580.30549@blonde.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Hugh Dickins <hugh@veritas.com> wrote:

>  static inline int cpu_present_to_apicid(int mps_cpu)
>  {
> -#ifdef CONFIG_X86_64
> -	if (cpu_present(mps_cpu))
> +	if (mps_cpu < NR_CPUS && cpu_present(mps_cpu))
>  		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
> -#else
> -	if (mps_cpu < get_physical_broadcast())
> -		return  mps_cpu;
> -#endif
>  	else
>  		return BAD_APICID;
>  }

applied. Thanks Hugh for the detective work! I love fixes that only 
remove code ;-)

	Ingo
