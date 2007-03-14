Return-Path: <linux-kernel-owner+w=401wt.eu-S1161039AbXCNKJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161039AbXCNKJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 06:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161042AbXCNKJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 06:09:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46120 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161039AbXCNKJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 06:09:48 -0400
Date: Wed, 14 Mar 2007 11:08:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, Johannes Bauer <JohannesBauer@gmx.de>,
       linux-kernel@vger.kernel.org, schwab@suse.de,
       Stable Kernel Team <stable@kernel.org>, Greg KH <greg@kroah.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
Message-ID: <20070314100816.GA10799@elte.hu>
References: <45F6F3A6.9060405@gmx.de> <45F7033B.2030204@redhat.com> <1173817985.13341.120.camel@localhost.localdomain> <1173866413.13341.154.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173866413.13341.154.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> hrtimer_forward() does not check for the possible overflow of 
> timer->expires. This can happen on 64 bit machines with large interval 
> values and results currently in an endless loop in the softirq because 
> the expiry value becomes negative and therefor the timer is expired 
> all the time.
> 
> Check for this condition and set the expiry value to the max. expiry 
> time in the future.
> 
> The fix should be applied to stable kernel series as well.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix,de>

ouch ... nice one.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
