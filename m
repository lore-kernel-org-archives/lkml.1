Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbYHMRkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbYHMRkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbYHMRjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:39:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36391 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322AbYHMRjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:39:55 -0400
Date: Wed, 13 Aug 2008 19:39:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Message-ID: <20080813173940.GA32214@elte.hu>
References: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com> <20080813141629.GD19397@elte.hu> <b6a2187b0808131010u7481f663n94d8e005b9dac2d1@mail.gmail.com> <b6a2187b0808131033m25a7e147x98235a48abd3eb3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0808131033m25a7e147x98235a48abd3eb3c@mail.gmail.com>
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


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> On Thu, Aug 14, 2008 at 1:10 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > On Wed, Aug 13, 2008 at 10:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> btw., could you please check that v2.6.27-rc3 (or later) kernels boot
> >> fine (with about 8 cpus) even if you have genericarch/bigsmp disabled,
> >> and do not silently hang as it happened on your box before?
> >
> > With 16 CPUs, it still hangs, but now the console is showing the
> > errors as intended.
> > ... but it is supposed to hang?
> 
> I tried with just CONFIG_NR_CPUS=8 and this time it booted, but stange
> thing is I only see 2 CPUs! To be more precise, it's without both
> CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
> 
> And when I tried to enable the CPUs, it complained about:
> 
> # cat cpu6/online
> 0
> # echo 1 > cpu6/online
> More than 8 CPUs detected - skipping them.
> Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
> -bash: echo: write error: Input/output error
> 
> Prior to the patch, the system booted with all 8 CPUs.
> 
> Again, if I enable both CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP,
> I get all 16 CPUs.

Yinghai, could the APIC ID enumeration be nonsequential and we skip CPUs 
starting at the third one already? I think we should accept all CPUs 
that are within our support range.

	Ingo
