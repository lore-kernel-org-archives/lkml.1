Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbXGUMAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbXGUMAD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 08:00:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761877AbXGUL7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 07:59:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58755 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758492AbXGUL7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 07:59:54 -0400
Date: Sat, 21 Jul 2007 13:59:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Tiefenbruck <mark@fluxbox.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Dell Inspiron 1501 fails to boot in 2.6.21+
Message-ID: <20070721115948.GA29178@elte.hu>
References: <c96265a60707201937t39f9b69ep48e76ed61ce1044e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c96265a60707201937t39f9b69ep48e76ed61ce1044e@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Tiefenbruck <mark@fluxbox.org> wrote:

>  IO window: disabled.
>  MEM window: c0200000-c02fffff
>  PREFETCH window: disabled.
> PCI: Bridge: 0000:00:14.4
>  IO window: disabled.
>  MEM window: c0300000-c03fffff
>  PREFETCH window: disabled.
> PCI: Setting latency timer of device 0000:00:05.0 to 64
> PCI: Setting latency timer of device 0000:00:06.0 to 64
> NET: Registered protocol family 2
> 
> The next few lines are usually as follows, but recent kernels never 
> get to them:

thanks for the detailed report and bisection test! The above hang 
strongly implicates some sort of high-res timers, dynticks or 
clocksource problem. Most likely timer interrupts do not come as 
expected, and the above place is one of the first spots where the kernel 
waits for a (short) timeout - so you see it hang indefinitely.

Besides the options Thomas suggested, you could also try 
clocksource=pm_timer?

	Ingo
