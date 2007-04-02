Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbXDBHJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbXDBHJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbXDBHJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:09:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59153 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbXDBHJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:09:16 -0400
Date: Mon, 2 Apr 2007 09:09:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] enhance initcall_debug, measure latency
Message-ID: <20070402070907.GA18480@elte.hu>
References: <20070401181614.GA25648@elte.hu> <20070401182801.GA25956@elte.hu> <p73vegfyzlw.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73vegfyzlw.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > so 93.6% of the allyesconfig bootup time is in 2.5% of the 
> > initcalls. If they were fixed then an allyesconfig bzImage, which 
> > would be capable to run on every PC known to mankind without any 
> > module whatsoever, would
> 
> Assuming that every PC has enough memory @) Allyes is >35MB

yes :)

> > take around 10 seconds to boot up (which is acceptable for kernel 
> > bootup time).
> 
> It might make sense to measure idle ticks vs busy ticks too. If it's 
> idle cycles perhaps things can be more easily fixed by multi threading 
> the initialization. If it's busy cycles perhaps they can be converted 
> into sleeping cycles.
> 
> Perhaps you should tell the individual maintainers for those? If they 
> still have one. A lot of them look like old hardware where there might 
> be no working ones left, perhaps just deprecation would make sense.

note that i have done another run today too, with common drivers (see 
the same thread).

But obviously it doesnt really scale for me to notify every maintainer, 
we've basically got no infrastructure to bulk-mail maintainers based on 
a list of symbols. (maybe git could be extended to know about things 
like who-owns-this-and-that-file? Or the source could be annotated so 
that automated tools could parse it out.) So i did the notification the 
usual way: by mailing to lkml ;-)

> > initcall 0xc1f5487d ran for 23083 msecs: pca_isa_init+0x0/0x143() 
> > initcall 0xc1f54fba ran for 17121 msecs: pcf8574_init+0x0/0x20()
> 
> e.g. those just look like bugs.

it's ok i think: it's ISA so it spends its time fairly to tickle the 
ports in a loop.

	Ingo
