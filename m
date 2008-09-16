Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbYIPImT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbYIPImT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYIPImM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:42:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50971 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbYIPImL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:42:11 -0400
Date: Tue, 16 Sep 2008 10:41:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
Message-ID: <20080916084143.GC17287@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com> <20080914150651.GK12522@elte.hu> <20080914150923.GB26984@elte.hu> <1221502142.19012.35.camel@bobble.smo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221502142.19012.35.camel@bobble.smo.corp.google.com>
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


* Frank Mayhar <fmayhar@google.com> wrote:

> > the wider question is, shouldnt the UP case be just the same as the 
> > SMP case? Especially the type assymetry struct thread_group_cputime 
> > looks ugly. (and assymetries like that tend to be a constant source 
> > of breakage like the one below.)
> 
> I'm not overly fond of this one, either; I did it at Roland's 
> suggestion (it's all _his_ fault, yeah, _that's_ the ticket! :-); his 
> opinion IIRC was that the UP case will perform better without the 
> extra pointer dereferences.  I agree that it's a potential source of 
> pain such as the one you point out.

i dont know ... 

lets try that simplification as a delta patch, ok? Please check the 
before/after size of 'vmlinux' in a 'make defconfig' [with SMP disabled 
after make defconfig] UP build. If there's visible size difference then 
Roland's point holds.

	Ingo
