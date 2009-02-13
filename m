Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbZBMJjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbZBMJjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbZBMJjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:39:40 -0500
Received: from www.tglx.de ([62.245.132.106]:40885 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbZBMJjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:39:39 -0500
Date: Fri, 13 Feb 2009 10:39:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Michael Davidson <md@google.com>, mbligh@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clockevents: avoid unnecessary reprograming of event
 timer
In-Reply-To: <20090213082223.GA4606@elte.hu>
Message-ID: <alpine.LFD.2.00.0902131029330.16972@localhost.localdomain>
References: <20090212222326.394E121B187@localhost> <20090213082223.GA4606@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Feb 2009, Ingo Molnar wrote:
> > +	if (ktime_equal(dev->next_event, expires))
> > +		return 0;
> > +
> 
> Hm, given that a good high-res source has nanoseconds resolution,
> what's the chance of this optimization triggering in practice?
> Near zero i think - unless we trigger useless reprogramming without
> having added or removed any new timers - but then we should
> concentrate on analyzing the reason for that redundant reprogramming.
> 
> Does it trigger often for you?

The only point where this should trigger is when we come out of C2/C3
and switch the local APIC timer back on. There we reload the
next_event which was discarded in the hardware before we entered C2/C3
and switched to the broadcast timer. So this change would prevent the
rearming of the local APIC after coming out of C2/C3 and probably give
us some new C-State related headaches.

Thanks,

	tglx
