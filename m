Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZBMIWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZBMIWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 03:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZBMIWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 03:22:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59058 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbZBMIWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 03:22:36 -0500
Date: Fri, 13 Feb 2009 09:22:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Davidson <md@google.com>
Cc: mbligh@google.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clockevents: avoid unnecessary reprograming of event
	timer
Message-ID: <20090213082223.GA4606@elte.hu>
References: <20090212222326.394E121B187@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212222326.394E121B187@localhost>
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


* Michael Davidson <md@google.com> wrote:

> From: Michael Davidson <md@google.com>
> 
> Don't reprogram the event timer if it is already set to expire
> at the correct time.
> 
> Signed-off-by: Michael Davidson <md@google.com>
> ---
> --- linux-2.6.29-rc4.orig/kernel/time/clockevents.c	2009-02-12 13:13:24.000000000 -0800
> +++ linux-2.6.29-rc4/kernel/time/clockevents.c	2009-02-12 13:25:42.525558000 -0800
> @@ -103,6 +103,9 @@
>  	if (delta <= 0)
>  		return -ETIME;
>  
> +	if (ktime_equal(dev->next_event, expires))
> +		return 0;
> +

Hm, given that a good high-res source has nanoseconds resolution,
what's the chance of this optimization triggering in practice?
Near zero i think - unless we trigger useless reprogramming without
having added or removed any new timers - but then we should
concentrate on analyzing the reason for that redundant reprogramming.

Does it trigger often for you?

	Ingo
