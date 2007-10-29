Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbXJ2XRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbXJ2XRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbXJ2XRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:17:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59533 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbXJ2XRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:17:20 -0400
Date: Tue, 30 Oct 2007 00:17:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       jeremy@goop.org, --cc@redhat.com, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
Subject: Re: [PATCH] raise tsc clocksource rating
Message-ID: <20071029231702.GA8506@elte.hu>
References: <11936994092607-git-send-email-gcosta@redhat.com> <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com> <20071029224852.GA27547@elte.hu> <1193698505.9793.90.camel@bodhitayantram.eng.vmware.com> <20071029230213.GA1982@elte.hu> <1193699638.9793.97.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193699638.9793.97.camel@bodhitayantram.eng.vmware.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zachary Amsden <zach@vmware.com> wrote:

> On Tue, 2007-10-30 at 00:02 +0100, Ingo Molnar wrote:
> > * Zachary Amsden <zach@vmware.com> wrote:
> 
> > > Not every guest support paravirt, but for correctness, all guests 
> > > require TSC, which must be exposed all the way up to userspace, no 
> > > matter what the efficiency or accuracy may be.
> > 
> > but if there's a perfect TSC available (there is such hardware) then the 
> > TSC _is_ the best clocksource. Paravirt now turns it off unconditionally 
> > in essence.
> 
> No, if no paravirt clocksource is detected, nothing can override the
> perfect TSC hardware clocksource rating of 400.  And if a paravirt
> clocksource is detected, it is always better than TSC.
> 
> > anyway, that's at most an optimization issue. No strong feelings here, 
> > and we can certainly delay this patch until this gets all sorted out.
> 
> This patch should be nacked, since it is just wrong.  This is not an 
> optimization issue.  It is an accuracy issue for all virtualization 
> environments that affects long term kernel clock stability, which is 
> important to fix, and the best way to do that is to use a paravirt 
> clocksource.

i know it's not an optimization issue. Your current pessimisation of 
even perfect TSCs _is_ an optimization issue.

(and note that if the TSC is unstable the guest will/should notice it 
and will fall back to the hyper clocksource)

	Ingo
