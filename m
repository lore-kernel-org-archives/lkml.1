Return-Path: <linux-kernel-owner+w=401wt.eu-S1762640AbXGPKtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762640AbXGPKtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 06:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761291AbXGPKsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 06:48:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50402 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760781AbXGPKsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 06:48:53 -0400
Date: Mon, 16 Jul 2007 12:48:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
Message-ID: <20070716104843.GA31527@elte.hu>
References: <19044.1184539364@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19044.1184539364@lwn.net>
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


* Jonathan Corbet <corbet@lwn.net> wrote:

> The OLPC folks and I recently discovered something interesting: on a 
> HZ=100 system, a call to msleep(1) will delay for about 20ms.  The 
> combination of jiffies timekeeping and rounding up means that the 
> minimum delay from msleep will be two jiffies, never less.  That led 
> to multi-second delays in a driver which does a bunch of short 
> msleep() calls and, in response, a change to mdelay(), which will come 
> back in something closer to the requested time.
> 
> Here's another approach: a reimplementation of msleep() and 
> msleep_interruptible() using hrtimers.  On a system without real 
> hrtimers this code will at least drop down to single-jiffy delays much 
> of the time (though not deterministically so).  On my x86_64 system 
> with Thomas's hrtimer/dyntick patch applied, msleep(1) gives almost 
> exactly what was asked for.
> 
> jon
> 
> Use hrtimers for msleep() and msleep_interruptible()
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

i certainly like this - an msleep() is like mdelay(), so there are real 
delays (and not timeouts) involved, so converting to hrtimers is the 
right thing to do from a conceptual POV too.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
