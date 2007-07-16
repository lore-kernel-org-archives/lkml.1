Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbXGPLjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbXGPLjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbXGPLj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:39:27 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4627 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbXGPLj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:39:26 -0400
Date: Mon, 16 Jul 2007 13:39:48 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
In-Reply-To: <19044.1184539364@lwn.net>
Message-ID: <Pine.LNX.4.64.0707161325040.1818@scrub.home>
References: <19044.1184539364@lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 15 Jul 2007, Jonathan Corbet wrote:

> Here's another approach: a reimplementation of msleep() and
> msleep_interruptible() using hrtimers.  On a system without real
> hrtimers this code will at least drop down to single-jiffy delays much
> of the time (though not deterministically so).  On my x86_64 system with
> Thomas's hrtimer/dyntick patch applied, msleep(1) gives almost exactly
> what was asked for.

One possible problem here is that setting up that timer can be 
considerably more expensive, for a relative timer you have to read the 
current time, which can be quite expensive (e.g. your machine now uses the 
PIT timer, because TSC was deemed unstable).
One question here would be, is it really a problem to sleep a little more?
Another possibility would be to add another sleep function, which uses 
hrtimer and could also take ktime argument.

bye, Roman
