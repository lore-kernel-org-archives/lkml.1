Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbXLSTlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbXLSTlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbXLSTk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:40:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795AbXLSTk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:40:56 -0500
Date: Wed, 19 Dec 2007 20:40:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Voluntary leave_mm before entering ACPI C3
Message-ID: <20071219194032.GA8849@elte.hu>
References: <20071219183443.GA547@linux-os.sc.intel.com> <20071219193255.GA2158@elte.hu> <476972A0.3050105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476972A0.3050105@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
>> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>>
>>> Aviod TLB flush IPIs during C3 states by voluntary leave_mm() before 
>>> entering C3.
>>>
>>> The performance impact of TLB flush on C3 should not be significant with 
>>> respect to C3 wakeup latency. Also, CPUs tend to flush TLB in hardware 
>>> while in C3 anyways.
>>>
>
> Are there any CPUs around which *don't* flush the TLB across C3?  (I 
> guess it's not guaranteed by the spec, though, and as TLBs grow larger 
> there might be incentive to keep them online.)

i dont think it's required for C3 to even turn off any portion of the 
CPU - if an interrupt arrives after the C3 sequence is initiated but 
just before dirty cachelines have been flushed then the CPU can just 
return without touching anything (such as the TLB) - right? So i dont 
think there's any implicit guarantee of TLB flushing (nor should there 
be), but in practice, a good C3 sequence would (statistically) turn off 
large portions of the CPU and hence the TLB as well.

	Ingo
