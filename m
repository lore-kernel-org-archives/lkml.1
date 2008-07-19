Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbYGSVoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbYGSVoN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 17:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbYGSVn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 17:43:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52238 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbYGSVn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 17:43:57 -0400
Date: Sat, 19 Jul 2008 23:43:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <20080719214329.GA836@elte.hu>
References: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl> <20080718105259.GY6875@elte.hu> <86802c440807180925t6fadfa58r6bf7740f8145482e@mail.gmail.com> <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com> <20080718210348.GB24373@elte.hu> <86802c440807181413n7e79e821l90afaae86b322de9@mail.gmail.com> <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl> <1216420937.30348.30.camel@bodhitayantram.eng.vmware.com> <20080718224922.GB4507@linux-os.sc.intel.com> <1216424592.30348.33.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216424592.30348.33.camel@bodhitayantram.eng.vmware.com>
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


* Zachary Amsden <zach@vmware.com> wrote:

> On Fri, 2008-07-18 at 15:49 -0700, Suresh Siddha wrote:
> 
> > > Thank you for cleaning this up Yinghai, but this really begs the
> > > question - is having write_atomic REALLY worthwhile?
> > 
> > And this thread is about,  Maciej's cleanup patch which removed
> > write_atomic completely :)
> > 
> > Thanks to Maciej who posted this fix. It was on my todo list for
> > sometime now!
> 
> Awesome!  I just felt the need to use 'flaming crap' in a sentence 
> today, and broken APICs seemed like an easy target.  Glad to know it's 
> gone.

it's gone, but without breaking or limiting old hardware: it's done by 
moving the code into a quirk. And that's the general direction which we 
want to take in such cases - move ugly non-standard stuff into 
low-maintenance-overhead quirks.

	Ingo
