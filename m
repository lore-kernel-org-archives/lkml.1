Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbZFBOSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbZFBOSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbZFBORz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:17:55 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:37773 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZFBORx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:17:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w2/VRMG2iPMW1SfvKW9V7ts3gkUxvZERiHFNLSdzWlZaKlbU1PmNwTcuv35o+KG7Eh
         CDyNEqyrmIa9lffeAzTUwRbKEn39gwxX25xUOockkB4fUkUiMuKZAY8HYUADIAJzGNHQ
         C1puOoARfEBpzSMFzXH95Cra6DdBNN3keEbpY=
Date: Tue, 2 Jun 2009 19:47:37 +0530
From: Rabin Vincent <rabin@rab.in>
To: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
Message-ID: <20090602141737.GA2449@debian>
References: <20090602071718.GA17710@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602071718.GA17710@linux-sh.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 04:17:18PM +0900, Paul Mundt wrote:
> sched: sched_clock() clocksource handling.
> 
> There are presently a number of issues and limitations with how the
> clocksource and sched_clock() interaction works today. Configurations
> tend to be grouped in to one of the following:
> 
>     - Platform provides a clocksource unsuitable for sched_clock()
>       and prefers to use the generic jiffies-backed implementation.
> 
>     - Platform provides its own clocksource and sched_clock() that
>       wraps in to it.
> 
>     - Platform uses a generic clocksource (ie, drivers/clocksource/)
>       combined with the generic jiffies-backed sched_clock().
> 
>     - Platform supports multiple sched_clock()-capable clocksources.
> 
> This patch adds a new CLOCK_SOURCE_USE_FOR_SCHED_CLOCK flag to address
> these issues, which can be set for any sched_clock()-capable clocksource.
> 
> The generic sched_clock() implementation is likewise switched over to
> always read from a designated sched_clocksource, which is default
> initialized to the jiffies clocksource and updated based on the
> availability of CLOCK_SOURCE_USE_FOR_SCHED_CLOCK sources. As this uses
> the generic cyc2ns() logic on the clocksource ->read(), most of the
> platform-specific sched_clock() implementations can subsequently be
> killed off.

80ea3bac3a47bc73efa334d0dd57099d0ff14216 ("ARM: OMAP: sched_clock()
corrected") seems to have switched omap from cyc2ns() to an open coded
calculation based on mult_orig because cyc2ns() uses the NTP-adjusted
mult instead.  Does that apply here or is that change incorrect?

Rabin
