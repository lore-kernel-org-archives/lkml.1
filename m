Return-Path: <linux-kernel-owner+w=401wt.eu-S932940AbXAaKTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940AbXAaKTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932942AbXAaKTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:19:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39310 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940AbXAaKTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:19:24 -0500
Date: Wed, 31 Jan 2007 11:17:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 09/23] clocksource: add block notifier
Message-ID: <20070131101710.GB22377@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033805.815147778@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131033805.815147778@mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4806]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> Adds a call back interface for register/rating change events. This is 
> also used later in this series to signal other interesting events.

This patch adds:

> +#define CLOCKSOURCE_NOTIFY_REGISTER	1
> +#define CLOCKSOURCE_NOTIFY_RATING	2
> +#define CLOCKSOURCE_NOTIFY_FREQ		4

and a later patch adds:

> +#define CLOCKSOURCE_NOTIFY_UNSTABLE	8

while i tentatively agree with the introduction of clocksource driver 
notifications in general (given any actual real users of that 
infrastructure), i can see three problems with your notifier changes:

firstly, with the full changes applied, CLOCKSOURCE_NOTIFY_RATING is 
totally unused (and not even driven by the core clocksource code).

secondly, CLOCKSOURCE_NOTIFY_REGISTER is only used by the core 
clocksource code and no register-notifier interface is exposed: this 
makes the whole thing an expensive NOP.

thirdly, CLOCKSOURCE_NOTIFY_FREQ is totally unused as well.

(there are tons of examples in the kernel of how to do driver 
notification APIs properly.)

	Ingo
