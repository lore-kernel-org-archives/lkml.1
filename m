Return-Path: <linux-kernel-owner+w=401wt.eu-S1161109AbXBAAQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161109AbXBAAQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161107AbXBAAQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:16:45 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:32991 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161110AbXBAAQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:16:44 -0500
Subject: Re: [PATCH 14/23] clocksource: increase initcall priority
From: Daniel Walker <dwalker@mvista.com>
To: tglx@linutronix.de
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1170285826.29240.227.camel@localhost.localdomain>
References: <20070131194311.4B8381FD833@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <1170283629.9781.163.camel@imap.mvista.com>
	 <1170285826.29240.227.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 16:15:12 -0800
Message-Id: <1170288912.9781.177.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 00:23 +0100, Thomas Gleixner wrote:
> Daniel,
> 
> On Wed, 2007-01-31 at 14:47 -0800, Daniel Walker wrote:
> > > So don't assume any platform doesn't use clocksource initcalls.
> > 
> > What does your OMAP clocksource do now ? I thought one of the changes
> > that you made was to have both 32k and mpu both registered ..
> 
> It is up to the clocksource driver, when the clocksource_register() call
> is done. This may happen in early boot as well as after initializing
> some other things first.
> 
> Johns clocksource code works with ARM which does the register call in
> timer_init() as well as with some other hardware which gets initialized
> late in the boot process.
> 
> clocksource_initcall is simply superfluid. 
> 


My position has always been that clocksources should be registered as
early as possible .. The fs_initcall() usage is a compromise stemming
from early resistance that John, and you gave to moving the clocks up in
the initcall sequence. the clocksource_initcall() exists only to allow
the clocks easily be raised if it was needed ..

I'm glad that you, John, and myself have come to a consensus on the
issue offline ..

Daniel 

