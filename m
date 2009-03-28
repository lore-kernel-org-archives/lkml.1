Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZC1MIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZC1MIq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 08:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZC1MIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 08:08:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45028 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbZC1MIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 08:08:35 -0400
Date: Sat, 28 Mar 2009 13:08:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
	cmci
Message-ID: <20090328120825.GB14464@elte.hu>
References: <49CB3F24.8040804@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CB3F24.8040804@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

> This patch adds a kernel parameter "mce_threshold=n" to enable us
> to change the default threshold for CMCI(Corrected Machine Check
> Interrupt) that recent Intel processor supports.
> 
> And it also supports CMCI disabling by setting mce_threshold=0.
> It would be useful if your hardware does something wrong and/or
> if polling by timer is preferred than the threshold interrupt.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  Documentation/kernel-parameters.txt       |    5 +++
>  arch/x86/include/asm/msr-index.h          |    1 +
>  arch/x86/kernel/cpu/mcheck/mce_intel_64.c |   56 +++++++++++++++++++++++++++--
>  3 files changed, 59 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 1d8af36..7a0d117 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1267,6 +1267,11 @@ and is between 256 and 4096 characters. It is defined in the file
>  
>  	mce=option	[X86-64] See Documentation/x86/x86_64/boot-options.txt
>  
> +	mce_threshold=	[X86-64,intel] Default CMCI threshold
> +			Should be unsigned integer. Setting 0 disables cmci.
> +			Format: <integer>
> +			Default: 1

Makes sense. CMCI is a new CPU feature so having boot controls to 
disable it is generally a good idea - while still having old-style 
MCE support in place.

Applied to tip:x86/mce2, thanks Hidetoshi!

	Ingo
