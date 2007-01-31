Return-Path: <linux-kernel-owner+w=401wt.eu-S933225AbXAaMpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225AbXAaMpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933219AbXAaMpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:45:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38117 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933207AbXAaMpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:45:19 -0500
Date: Wed, 31 Jan 2007 13:43:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 23/23] clocksource tsc: add verify routine
Message-ID: <20070131124300.GG1847@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033810.319576375@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131033810.319576375@mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4240]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> I've included this as another user of the clocksource interface. I 
> don't see a usage for this across all achitectures. So a fully generic 
> version isn't needed.

well, this implementation is buggy in at least two ways:

firstly, it allows a circular verification dependency in highres+dyntick 
mode between the jiffies and tsc clocksources.

secondly, verification is not done while the system is booting up:

>  static void verify_tsc_freq(unsigned long unused)
>  {

[...]
> +	if (unlikely(system_state != SYSTEM_RUNNING))
> +		goto out_timer;

so we should just go with Thomas' patch:

  clocksource-add-verification-watchdog-helper.patch

which has been based on and tested on actual systems affected by these 
problems.

	Ingo
