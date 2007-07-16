Return-Path: <linux-kernel-owner+w=401wt.eu-S932895AbXGPOLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbXGPOLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765297AbXGPOLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:11:16 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4939 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764502AbXGPOLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:11:15 -0400
Date: Mon, 16 Jul 2007 16:11:38 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
In-Reply-To: <19044.1184539364@lwn.net>
Message-ID: <Pine.LNX.4.64.0707161601570.1818@scrub.home>
References: <19044.1184539364@lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 15 Jul 2007, Jonathan Corbet wrote:

> The OLPC folks and I recently discovered something interesting: on a
> HZ=100 system, a call to msleep(1) will delay for about 20ms.  The
> combination of jiffies timekeeping and rounding up means that the
> minimum delay from msleep will be two jiffies, never less.  That led to
> multi-second delays in a driver which does a bunch of short msleep()
> calls and, in response, a change to mdelay(), which will come back in
> something closer to the requested time.
> 
> Here's another approach: a reimplementation of msleep() and
> msleep_interruptible() using hrtimers.  On a system without real
> hrtimers this code will at least drop down to single-jiffy delays much
> of the time (though not deterministically so).  On my x86_64 system with
> Thomas's hrtimer/dyntick patch applied, msleep(1) gives almost exactly
> what was asked for.

BTW there is another thing to consider. If you already run with hrtimer/ 
dyntick, there is not much reason to keep HZ at 100, so you could just 
increase HZ to get the same effect.

bye, Roman
