Return-Path: <linux-kernel-owner+w=401wt.eu-S933089AbXAaLr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbXAaLr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 06:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932996AbXAaLr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 06:47:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35784 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086AbXAaLrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 06:47:55 -0500
Date: Wed, 31 Jan 2007 12:46:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 12/23] clocksource: add clocksource_get_clock()
Message-ID: <20070131114615.GB1847@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033806.795135512@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131033806.795135512@mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> One new API call clocksource_get_clock() which allows clocks to be 
> selected based on their name, or if the name is null the highest rated 
> clock is returned.

this one (and the dependent APIs utilizations) look a step in the right 
direction to me, but they are not fully consequent and thus a bit 
confusing at the moment:

- the current_clocksource is now something that is conceptually related 
  to timekeeping - while it still resides in the clocksource domain.

- if we do this split there should be a separate sysfs hierarchy for 
  timekeeping, separate of clocksource

- you use struct sys_device clocksource_sys_device from clocksource.c in 
  timekeeping.c, which is inconsistent as well.

so these bits need more work.

	Ingo
