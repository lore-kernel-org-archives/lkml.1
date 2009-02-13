Return-Path: <linux-kernel-owner+w=401wt.eu-S1751465AbZBMJz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbZBMJz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZBMJzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:55:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36594 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZBMJzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:55:17 -0500
Date: Fri, 13 Feb 2009 10:55:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Davidson <md@google.com>, mbligh@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clockevents: avoid unnecessary reprograming of event
	timer
Message-ID: <20090213095506.GE17774@elte.hu>
References: <20090212222326.394E121B187@localhost> <20090213082223.GA4606@elte.hu> <alpine.LFD.2.00.0902131029330.16972@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902131029330.16972@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 13 Feb 2009, Ingo Molnar wrote:
> > > +	if (ktime_equal(dev->next_event, expires))
> > > +		return 0;
> > > +
> > 
> > Hm, given that a good high-res source has nanoseconds resolution,
> > what's the chance of this optimization triggering in practice?
> > Near zero i think - unless we trigger useless reprogramming without
> > having added or removed any new timers - but then we should
> > concentrate on analyzing the reason for that redundant reprogramming.
> > 
> > Does it trigger often for you?
> 
> The only point where this should trigger is when we come out of C2/C3
> and switch the local APIC timer back on. There we reload the
> next_event which was discarded in the hardware before we entered C2/C3
> and switched to the broadcast timer. So this change would prevent the
> rearming of the local APIC after coming out of C2/C3 and probably give
> us some new C-State related headaches.

yes, that was my other thought. Albeit arguably the CE code should
set next_event to -1 or so when suspending, out of caution, right?

	Ingo
