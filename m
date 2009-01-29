Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbZA2XVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbZA2XVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759976AbZA2XVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:21:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48110 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759964AbZA2XU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:20:58 -0500
Date: Fri, 30 Jan 2009 00:20:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: allow 8 more cpus could be used
Message-ID: <20090129232042.GA30601@elte.hu>
References: <49822B1D.9070708@kernel.org> <20090129224236.GD1465@elte.hu> <4982315F.20705@kernel.org> <20090129230827.GA29611@elte.hu> <49823866.5060008@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49823866.5060008@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> Ingo Molnar wrote:
> >>> * Yinghai Lu <yinghai@kernel.org> wrote:
> >>>
> >>>> Impact: fix left out MARCO
> >>>>
> >>>> X86_PC will be always enabled. so need to check if we have bigsmp 
> >>>> support built in before cut off more than 8 cpus.
> >>> ah, that's a leftover reference to X86_PC. It can now be removed, together 
> >>> with the Kconfig X86_PC option.
> >>>
> >>>> -#if defined(CONFIG_X86_PC) && defined(CONFIG_X86_32)
> >>>> +#if defined(CONFIG_X86_PC) && !defined(CONFIG_X86_BIGSMP)
> >>>>  	if (def_to_bigsmp && nr_cpu_ids > 8) {
> >>>>  		unsigned int cpu;
> >>>>  		unsigned nr;
> >>> Could you please send a patch that removes both X86_PC and X86_BIGSMP - 
> >>> and removes the above cutoff code too, so that it will be built-in all the 
> >>> time?
> >> sure. maybe we could keep X86_BIGSMP for a while. So someone don't 
> >> enable BIGSMP for small system?
> > 
> > yeah, we can certainly keep it - the code to conditionalize it is there 
> > and isnt causing problems really.
> 
> it seems X86_PC will always to 'y'
> 
> we may remove it, just use x86 to replace it etc.
> 
> [PATCH] x86: remove X86_PC macro
> 
> Impact: fix cutoff and remove left over MACRO
> 
> X86_PC is default, so don't need it any more.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

applied to tip/x86/apic, thanks!

	Ingo
