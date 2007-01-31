Return-Path: <linux-kernel-owner+w=401wt.eu-S932926AbXAaKBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbXAaKBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932927AbXAaKBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:01:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40322 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932926AbXAaKBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:01:11 -0500
Date: Wed, 31 Jan 2007 10:59:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 08/23] clocksource: drop duplicate register checking
Message-ID: <20070131095935.GA22377@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033805.498958666@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131033805.498958666@mvista.com>
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

> This is something Thomas already dropped, [...]

(i think you forgot to Cc: Thomas here, nor is this something that 
Thomas' change dropped.)

> [...] and I'm just sticking with that .. If you register your 
> clocksource _twice_ your kernel will likely not work correctly (and 
> might crash).

this is a quite bad change. John's original clocksource code protects 
against double registry:

         if (is_registered_source(c)) {
                 printk("register_clocksource: Cannot register %s. "
                        "Already registered!", c->name);
                 ret = -EBUSY;

and Thomas' change keeps that property, but doesnt printk. Your change 
makes double registry possible, potentially crashing the kernel later 
on! (And this isnt theoretical, double registry did happen in practice 
when i debugged suspend problems on my SMP laptop.)

	Ingo
