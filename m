Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYHOIwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYHOIwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYHOIwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:52:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60801 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYHOIwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:52:12 -0400
Date: Fri, 15 Aug 2008 10:51:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] x86: make 32bit support per_cpu vector fix #1
Message-ID: <20080815085156.GB18748@elte.hu>
References: <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com> <1218766832-20476-2-git-send-email-yhlu.kernel@gmail.com> <1218766832-20476-3-git-send-email-yhlu.kernel@gmail.com> <1218766832-20476-4-git-send-email-yhlu.kernel@gmail.com> <20080815082147.GB4776@elte.hu> <86802c440808150129v6474bf66mc329c46129c24e3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808150129v6474bf66mc329c46129c24e3c@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Fri, Aug 15, 2008 at 1:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >> +#ifdef CONFIG_SMP
> >> +        return cpu_online_map;
> >> +#else
> >> +        return cpumask_of_cpu(0);
> >> +#endif
> >
> > unrelated sidenote - shouldnt the scheduler define cpu_online_map to
> > cpumask_of_cpu(0) on UP, to avoid such ugly #ifdefs?
> 
> copy that from mach_default...

sure, that's the right approach - preserve existing code to reduce risk.

> should double check if cpu_online_map is cpu_mask_of_cpu(0) if !CONFIG_SMP

yeah. Separate clean-up patch i think.

	Ingo
