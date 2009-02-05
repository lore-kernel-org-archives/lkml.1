Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZBEOxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZBEOxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZBEOx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:53:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41858 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZBEOxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:53:25 -0500
Date: Thu, 5 Feb 2009 15:53:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kirill Korotaev <dev@parallels.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH] x86: fix hpet timer reinit for x86_64
Message-ID: <20090205145311.GB23903@elte.hu>
References: <20090204134933.GC17024@elte.hu> <C5B07773.B781%dev@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5B07773.B781%dev@parallels.com>
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


* Kirill Korotaev <dev@parallels.com> wrote:

> On 2/4/09 4:49 PM, "Ingo Molnar" <mingo@elte.hu> wrote:
> 
> > 
> > 
> > * Pavel Emelyanov <xemul@openvz.org> wrote:
> > 
> >> There's a small problem with hpet_rtc_reinit function - it checks
> >> for the
> >>       hpet_readl(HPET_COUNTER) - hpet_t1_cmp > 0
> >> to continue increasing both the HPET_T1_CMP (register) and the
> >> hpet_t1_cmp (variable).
> >> 
> >> But since the HPET_COUNTER is always 32-bit, if the hpet_t1_cmp
> >> is 64-bit this condition will always be FALSE once the latter hits
> >> the 32-bit boundary, and we can have a situation, when we don't
> >> increase the HPET_T1_CMP register high enough.
> >> 
> >> The result - timer stops ticking, since HPET_T1_CMP becomes less,
> >> than the COUNTER and never increased again.
> >> 
> >> The solution is to cut the upper 32-bit from the hpet_t1_cmp
> >> variable to make the comparison to HPET_COUNTER correct.
> >> 
> >> Reported-by: Kirill Korotaev <dev@openvz.org>
> >> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> > 
> > applied to tip/timers/urgent, thanks Pavel!
> > 
> > I'm wondering, what symptoms were seen due to the bug? Did system time stop,
> > or did it become erratic, or were there outright lockups?
> 
> Symptoms were observed in user space. An application doing read() on
> /dev/rtc blocked sometimes for a long periods of time (as turned out - until
> counter gets wrap around).

okay. Could you guys please put this info in the commit log on the 
resubmitted patch? Thanks,

	Ingo
