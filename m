Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbYKRIKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbYKRIKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYKRIKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:10:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53196 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbYKRIKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:10:06 -0500
Date: Tue, 18 Nov 2008 09:09:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Support always running TSC on Intel CPUs
Message-ID: <20081118080952.GE17838@elte.hu>
References: <20081118001137.GA12350@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118001137.GA12350@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> +	if (c->x86_power & (1 << 8)) {
>  		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
> +		set_cpu_cap(c, X86_FEATURE_NOSTOP_TSC);
> +	}

hm, the naming is a bit confusing. We now have 3 variants:

  X86_FEATURE_TSC
  X86_FEATURE_CONSTANT_TSC
  X86_FEATURE_NOSTOP_TSC

NOSTOP_TSC is basically what CONSTANT_TSC should have been to begin 
with ;-)

i'd suggest to rename it to this:

  X86_FEATURE_TSC
  X86_FEATURE_CONSTANT_FREQ_TSC
  X86_FEATURE_STABLE_TSC

... with CONSTANT_FREQ_TSC not having any real role in the long run. 
(it's similarly problematic to a completely unstable TSC)

does this sound ok?

	Ingo
