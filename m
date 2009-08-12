Return-Path: <linux-kernel-owner+w=401wt.eu-S1751447AbZHLL7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbZHLL7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZHLL7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:59:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56636 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbZHLL7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:59:46 -0400
Date: Wed, 12 Aug 2009 13:59:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Johannes Stezenbach <js@sig21.net>, x86@kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: *PING* [PATCH]: x86: mce: fix mce warning with disabled lapic
Message-ID: <20090812115920.GA24215@elte.hu>
References: <20090807170942.GB9177@sig21.net> <87k51cgdt8.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k51cgdt8.fsf@basil.nowhere.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> *PING* can someone please take the patch in there and process the 
> other suggestions?

Firstly, a basic patch submission technical matter: could you please 
stop spamming maintainers of the x86/MCE code with such '*PING*' 
private mails, for patches you never properly submitted to begin 
with?

The proper way to submit an upstream kernel fix, as you should well 
be aware of, is to send a patch with a proper title and to Cc: it to 
lkml and the maintainers affected. You never did that, you only 
posted a for-testing patch into a discussion. Please stop this 
self-important posturing, it's somewhat annoying.

Also, another, patch log quality issue, please credit Johannes 
properly. You put this into the changelog:

> Originally reported by Johannes Stezenbach 
> 
> This is a 2.6.31 candidate because it fixes a regression.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

The proper way is to put this into the changelog:

  Reported-by: Johannes Stezenbach <js@sig21.net>

And given that Johannes also tested the patch, another line of:

  Tested-by: Johannes Stezenbach <js@sig21.net>

Would be appropriate as well.

Thirdly, we can do better with the fix itself too:

> +++ linux/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -236,6 +236,9 @@ void intel_init_thermal(struct cpuinfo_x
>  	int tm2 = 0;
>  	u32 l, h;
>  
> +	if (!cpu_has_apic || disable_apic)
> +		return;
> +
>  	/* Thermal monitoring depends on ACPI and clock modulation*/
>  	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
>  		return;

we already have that X86_FEATURE_ACPI and X86_FEATURE_ACC check and 
a return statement. Would be better to expand that with the APIC 
checks. Plus update the comment to also mention APIC as a 
requirement plus fix the small error in the comment too while at it.

If these problems are fixed i'll apply the fix to tip:x86/urgent.

Thanks,

	Ingo
