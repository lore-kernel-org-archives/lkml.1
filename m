Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbZCBUCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbZCBUCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbZCBUCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:02:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48951 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbZCBUCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:02:34 -0500
Date: Mon, 2 Mar 2009 21:02:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, eric@lammerts.org
Subject: Re: [PATCH][retry 2] Conform L3 Cache Index Disable to
	Linuxstandards From:  Eric Lammerts <eric@lammerts.org>
Message-ID: <20090302200213.GA13699@elte.hu>
References: <200902201550.47415.mark.langsdorf@amd.com> <20090226163329.3a47b368.akpm@linux-foundation.org> <20090227080246.GA524@elte.hu> <6453C3CB8E2B3646B0D020C112613273C5AEF2@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AEF2@sausexmb4.amd.com>
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


* Langsdorf, Mark <mark.langsdorf@amd.com> wrote:

> > > > Add ABI Documentation entry and fix some /sys directory formating
> > > > issues with the L3 Cache Index Disable feature for future AMD
> > > > processors. __Add a check to disable it for family 0x10 models
> > > > that do not support it yet.
> > > 
> > > x86_64 allnoconfig:
> > > 
> > > arch/x86/kernel/cpu/intel_cacheinfo.c:556: warning: 
> > 'free_cache_attributes' defined but not used
> > > arch/x86/kernel/cpu/intel_cacheinfo.c:596: warning: 
> > 'detect_cache_attributes' defined but not used
> 
> My code doesn't modify either of these functions, so
> I'm not causing the regression.

The more serious problem is what i reported, that your patch 
triggers this build failure:

arch/x86/kernel/built-in.o: In function `store_cache_disable':
intel_cacheinfo.c:(.text+0xd322): undefined reference to `k8_northbridges'
arch/x86/kernel/built-in.o: In function `show_cache_disable':
intel_cacheinfo.c:(.text+0xd52c): undefined reference to `k8_northbridges'

so i've excluded it from tip:master for now. Please resubmit a 
fixed patch.

	Ingo
