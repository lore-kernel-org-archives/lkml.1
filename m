Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758243AbYLPWDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbYLPWDj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYLPWD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:03:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45570 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbYLPWD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:03:27 -0500
Date: Tue, 16 Dec 2008 23:03:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: re-enable MCE on secondary CPUS after
	suspend/resume
Message-ID: <20081216220319.GB14787@elte.hu>
References: <20081212180650.GS19144@alberich.amd.com> <20081212181021.GU19144@alberich.amd.com> <873agtnrgy.fsf@basil.nowhere.org> <20081215190509.GB5620@alberich.amd.com> <20081215223310.GX25779@one.firstfloor.org> <20081215224139.GC5620@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215224139.GC5620@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> On Mon, Dec 15, 2008 at 11:33:10PM +0100, Andi Kleen wrote:
> > > void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
> > > {
> > >         static cpumask_t mce_cpus = CPU_MASK_NONE;
> > > 
> > >         mce_cpu_quirks(c);
> > > 
> > >         if (mce_dont_init ||
> > >             cpu_test_and_set(smp_processor_id(), mce_cpus) ||
> > >             !mce_available(c))
> > >   =>             return;
> > > 
> > >         mce_init(NULL);
> > >         mce_cpu_features(c);
> > > }
> > > 
> > > But we need to call mce_init to clear all MCE state.
> > > IMHO the best location to call mce_init for APs is the cpu notifier.
> > 
> > Ah got it. Thanks that makes sense. 
> > 
> > But I think the better fix is to just drop the mce_cpus check and
> > then handly it naturally in the standard bootup path. I'm not
> > sure what it was good for anyways. I copied it into the 64bit code
> > from 32bit, but I suppose even there it isn't really needed and on 
> > 32bit it is already gone even.
> > 
> > How about this patch. Does it fix the problem for you too?
> 
> Yup, works as well:
> 
> Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>

applied to tip/x86/urgent, thanks guys.

	Ingo
