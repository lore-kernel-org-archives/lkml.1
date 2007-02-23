Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbXBWJzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbXBWJzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 04:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbXBWJzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 04:55:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43114
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752182AbXBWJzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 04:55:21 -0500
Date: Fri, 23 Feb 2007 01:55:20 -0800 (PST)
Message-Id: <20070223.015520.125893182.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: Re: sparc generic time / clockevents
From: David Miller <davem@davemloft.net>
In-Reply-To: <1172224579.25076.219.camel@localhost.localdomain>
References: <1172165959.25076.192.camel@localhost.localdomain>
	<20070223.012519.48528691.davem@davemloft.net>
	<1172224579.25076.219.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 23 Feb 2007 10:56:18 +0100

> On Fri, 2007-02-23 at 01:25 -0800, David Miller wrote:
> > > Yes, all you need is to omit the CLOCK_EVT_FEAT_PERIODIC flag when you
> > > register your device.
> > 
> > Thanks a lot Thomas.
> > 
> > I noticed while doing this work that the generic clock code is
> > incompatible with the time interpolator, since both provide a
> > do_{get,set}timeofday() implementation.  Just FYI...
> 
> John, can you have a look at this ?

Note we may not care :-)  All the interpolator does is provide
a generic tick based gettimeofday implementation, and the generic
clock code does essentially the same thing.

And the generic clock code must in fact provide the implementations
in order to deal with dyntick issues.

The only other platform using the time interpolator is IA64,
and after my dyntick implementation on sparc64 the one and
only user will be IA64 :-)
