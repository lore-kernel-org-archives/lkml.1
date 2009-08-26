Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbZHZJOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbZHZJOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZHZJOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:14:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45746 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbZHZJOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:14:18 -0400
Date: Wed, 26 Aug 2009 11:14:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: [PATCH -tip] x86, mce: CE in last bank prevents panic by
	unknown MCE
Message-ID: <20090826091407.GA7743@elte.hu>
References: <4A94E244.3020301@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A94E244.3020301@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> [based on tip/x86/mce]
> 
> If MCE handler is called but none of mces_seen have machine check 
> event which might signal the MCE (i.e. event higher than 
> MCE_KEEP_SEVERITY), panic with "Machine check from unknown source" 
> will be taken since the MCE is assumed to be signaled from 
> external agent or so.
> 
> Usually mces_seen never point MCE_KEEP_SEVERITY event such as CE. 
> But it can happen because initial value of mces_seen is 
> accidentally modified by mce_no_way_out() - in case if 
> mce_no_way_out() run through all banks and the last bank has the 
> CE, mces_seen points the CE and the "panic by unknown" will not be 
> taken.
> 
> This patch fix this undesired behavior, and clarify the logic.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Reported-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> 
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

applied, thanks!

Btw., i had a quick look at 
arch/x86/kernel/cpu/mcheck/mce-severity.c, and it is quite a pile of 
unclean, over-engineered crap really.

Would you be interested in sending me a patch that converts that to 
clean, proper C code that just checks the bits in a straightforward, 
readable way? We dont need that silly, unreadable table with the 
macro jungle and we definitely dont want to expose it via debugfs - 
the debugfs bits can be removed altogether.

[ Plus in the mce_severity() implementation please rename 'a' to at
  least 'm' - that name choice for a variable shows zero taste. We
  dont program the kernel in BASIC with 'A', 'B' and 'C' variable
  names anymore. ]

Thanks,

	Ingo
