Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbYICTB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbYICTB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbYICTBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:01:46 -0400
Received: from www.tglx.de ([62.245.132.106]:34984 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbYICTBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:01:45 -0400
Date: Wed, 3 Sep 2008 21:01:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Mohr <andi@lisas.de>
cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, shaohua.li@intel.com
Subject: Re: [PATCH] Prevent clockevent event_handler ending up
 handler_noop
In-Reply-To: <20080903173627.GA7767@rhlx01.hs-esslingen.de>
Message-ID: <alpine.LFD.1.10.0809032058380.3243@apollo.tec.linutronix.de>
References: <20080903164356.GA31969@rhlx01.hs-esslingen.de> <alpine.LFD.1.10.0809031908270.3243@apollo.tec.linutronix.de> <20080903173627.GA7767@rhlx01.hs-esslingen.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Andreas Mohr wrote:
> On Wed, Sep 03, 2008 at 07:15:16PM +0200, Thomas Gleixner wrote:
> > On Wed, 3 Sep 2008, Andreas Mohr wrote:
> > > See what such highres-deprived people as myself (PIT, acpi_pm,
> > > _no_ HPET and thus no IRQed highres timer) are doing now,
> > 
> > Err. PIT + acpi_pm works with highres. acpi_pm is a stable clocksource
> > and PIT is not a good, but a usable oneshot timer.
> 
> Hmm. What I'm interested in is longer wakeup timeouts (ACPI C2/C3
> stuff), which would be a problem with PIT (~20 forced wakeups per second)
> but with my new timer that would work.
> Oh, side question: it _is_ easily possible to then disable PIT IRQs
> once my event device is registered, right? Otherwise I could forget
> about power management benefits...

When you register something better than PIT, then the PIT is
disabled completely. No more interrupts from there.

> So as I see it, the most beneficial thing I can do is to provide
> a clock_event_device only.

Right.
 
> Out of interest: how big would you believe the benefit to be?
> (overall system performance gains and ACPI PM benefits)

Hard to tell, your milage can vary.

     tglx

