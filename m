Return-Path: <linux-kernel-owner+w=401wt.eu-S1160998AbXAaXXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160998AbXAaXXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161028AbXAaXXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:23:05 -0500
Received: from www.osadl.org ([213.239.205.134]:42451 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1160998AbXAaXXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:23:03 -0500
Subject: Re: [PATCH 14/23] clocksource: increase initcall priority
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Daniel Walker <dwalker@mvista.com>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1170283629.9781.163.camel@imap.mvista.com>
References: <20070131194311.4B8381FD833@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <1170283629.9781.163.camel@imap.mvista.com>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 00:23:46 +0100
Message-Id: <1170285826.29240.227.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Wed, 2007-01-31 at 14:47 -0800, Daniel Walker wrote:
> > So don't assume any platform doesn't use clocksource initcalls.
> 
> What does your OMAP clocksource do now ? I thought one of the changes
> that you made was to have both 32k and mpu both registered ..

It is up to the clocksource driver, when the clocksource_register() call
is done. This may happen in early boot as well as after initializing
some other things first.

Johns clocksource code works with ARM which does the register call in
timer_init() as well as with some other hardware which gets initialized
late in the boot process.

clocksource_initcall is simply superfluid. 

Adjusting the initcalls of a particular device to the point where it
becomes available is a seperate topic. I'm not in the way of that and I
think John's patch draft to solve the sound issue is heading into
exactly this direction.

We do not need another initcall level, especially not one which just
aliases an existing one.

The only thing we really want to control explicitely is when we actually
switch away from jiffies_clocksource. But this does not need an
artificial initcall at all.

	tglx


